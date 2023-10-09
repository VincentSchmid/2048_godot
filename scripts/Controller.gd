extends Node


const MAP_SIZE = 4
const PIECE_SCALE = 4 * 0.5 / MAP_SIZE
const MARGIN = 50.0
const STARTING_PIECE_COUNT = 2
const POSSIBLE_STARING_PIECES = [2, 4]
const ADD_PIECE_AFTER_MOVE = true
const UNDO_COUNT = 5

var WINDOW_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var WINDOW_WIDTH = ProjectSettings.get_setting("display/window/size/width")

@onready var undo_button = get_node("Undo")
@onready var game_over_overlay = get_node("GameOver")
@onready var new_game_button = get_node("NewGame")
@onready var SwipeHandler = get_node("SwipeHandler")
@onready var map = get_node("Board")
@onready var piece_factory = get_node("Pieces")
@onready var mapPopulateStrat = RandomMap.new()
@onready var rng_gen = RngGen.new(UNDO_COUNT, POSSIBLE_STARING_PIECES, map)
var commandHandler: CommandHandler
var game: Game
var commadFactory: CommandFactory

var playing: bool

signal game_over()

func _ready() -> void:
	piece_factory.set_piece_scale(PIECE_SCALE)
	ProjectSettings.set("2048/layout/margin", MARGIN)
	ProjectSettings.set("2048/layout/window_height", WINDOW_HEIGHT)
	ProjectSettings.set("2048/layout/map_pixel_size", WINDOW_WIDTH)
	ProjectSettings.set("2048/layout/map_size", MAP_SIZE)
	
	commandHandler = CommandHandler.new(UNDO_COUNT)
	commadFactory = CommandFactory.new(rng_gen, map, piece_factory)
	game = Game.new(
		ADD_PIECE_AFTER_MOVE,
		MAP_SIZE,
		map,
		commandHandler,
		commadFactory)

	SwipeHandler.swiped.connect(self.on_swipe)
	undo_button.pressed.connect(self.on_undo)
	new_game_button.pressed.connect(self.on_new_game)
	self.game_over.connect(self.on_game_over)
	
	start_game()
	
func _process(_delta):
	if playing and game.game_over:
		emit_signal("game_over")

func on_swipe(swipe_direction):
	if playing:
		game.move_phase(swipe_direction)
		commandHandler.process_stack()
		game.post_turn_phase()
		commandHandler.process_stack()
	
func on_undo():
	playing = true
	game_over_overlay.visible = false
	commandHandler.undo()
	
func on_new_game():
	start_game()
	
func on_game_over():
	playing = false
	game_over_overlay.visible = true

func start_game():
	game_over_overlay.visible = false
	map.init_map(MAP_SIZE)
	var value_map = mapPopulateStrat.populate_map(MAP_SIZE,
		STARTING_PIECE_COUNT,
		POSSIBLE_STARING_PIECES)
	
	place_pieces(value_map)
	playing = true

func place_pieces(value_map: Array):
	for y in value_map.size():
		for x in value_map[y].size():
			var value = value_map[y][x]
			if value > 0:
				place_piece(Vector2(x, y), value)

func place_piece(board_position: Vector2, value: int):
	commadFactory.create_add_piece_command(board_position, value).execute()
