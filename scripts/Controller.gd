extends Node


const MAP_SIZE = 4
const PIECE_SIZE = 200
const MARGIN = 50.0
const STARTING_PIECE_COUNT = 2
const POSSIBLE_STARING_PIECES = [2, 4]
const ADD_PIECE_AFTER_MOVE = true
const UNDO_COUNT = 5

var WINDOW_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var WINDOW_WIDTH = ProjectSettings.get_setting("display/window/size/width")

onready var undo_button = get_node("Undo")
onready var new_game_button = get_node("NewGame")
onready var SwipeHandler = get_node("SwipeHandler")
onready var map = get_node("Board")
onready var piece_factory = get_node("Pieces")
onready var mapPopulateStrat = RandomMap.new()
onready var rng_gen = RngGen.new(UNDO_COUNT, POSSIBLE_STARING_PIECES, map)
var commandHandler: CommandHandler
var game: Game

var playing: bool

signal game_over()

func _ready() -> void:
	ProjectSettings.set("2048/layout/margin", MARGIN)
	ProjectSettings.set("2048/layout/window_height", WINDOW_HEIGHT)
	ProjectSettings.set("2048/layout/map_pixel_size", WINDOW_WIDTH)
	ProjectSettings.set("2048/layout/map_size", MAP_SIZE)
	
	commandHandler = CommandHandler.new(UNDO_COUNT)
	game = Game.new(
		ADD_PIECE_AFTER_MOVE,
		MAP_SIZE,
		map, 
		rng_gen,
		commandHandler,
		piece_factory)

	SwipeHandler.connect("swiped", self, "on_swipe")
	undo_button.connect("pressed", self, "on_undo")
	new_game_button.connect("pressed", self, "on_new_game")
	self.connect("game_over", self, "on_game_over")
	
	start_game()
	
func _process(delta):
	if playing and game.is_game_over():
		emit_signal("game_over")

func on_swipe(swipe_direction):
	game.move_phase(swipe_direction)
	commandHandler.process_stack()
	game.post_turn_phase()
	commandHandler.process_stack()
	
func on_undo():
	commandHandler.undo()
	
func on_new_game():
	start_game()
	
func on_game_over():
	playing = false
	print("game over")

func start_game():
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
	AddPieceCommand.new(null, piece_factory, map, piece_factory, board_position, value).execute()
