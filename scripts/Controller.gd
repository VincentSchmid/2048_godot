extends Node


const MAP_SIZE = 4
const PIECE_SIZE = 200
const MARGIN = 50.0
const STARTING_PIECE_COUNT = 2
const POSSIBLE_STARING_PIECES = [2, 4]
const ADD_PIECE_AFTER_MOVE = true

var WINDOW_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var WINDOW_WIDTH = ProjectSettings.get_setting("display/window/size/width")

onready var SwipeHandler = get_node("SwipeHandler")
onready var map = get_node("Board")
onready var piece_factory = get_node("Pieces")
onready var mapPopulateStrat = MergeTest.new()
var game: Game

var check_direction
var new_piece_values = []
var piece_has_moved = false
var command_stack = []

func _ready() -> void:
	ProjectSettings.set("2048/layout/margin", MARGIN)
	ProjectSettings.set("2048/layout/window_height", WINDOW_HEIGHT)
	ProjectSettings.set("2048/layout/map_pixel_size", WINDOW_WIDTH)
	ProjectSettings.set("2048/layout/map_size", MAP_SIZE)

	game = Game.new(
		POSSIBLE_STARING_PIECES, 
		ADD_PIECE_AFTER_MOVE,
		map, 
		MAP_SIZE, 
		command_stack, 
		piece_factory)

	SwipeHandler.connect("swiped", self, "on_swipe")
	map.init_map(MAP_SIZE)
	start_game()
	
func on_swipe(swipe_direction):
	game.move_phase(swipe_direction)
	process_stack()
	game.post_turn_phase()
	process_stack()

func start_game():
	var value_map = mapPopulateStrat.populate_map(MAP_SIZE,
		STARTING_PIECE_COUNT,
		POSSIBLE_STARING_PIECES)
	
	place_pieces(value_map)
	
func process_stack():
	for command in command_stack:
		command.execute()

func place_pieces(value_map: Array):
	for y in value_map.size():
		for x in value_map[y].size():
			var value = value_map[y][x]
			if value > 0:
				place_piece(Vector2(x, y), value)

func place_piece(board_position: Vector2, value: int):
	AddPieceCommand.new(board_position, value, piece_factory, map, piece_factory).execute()

func draw():
	map.draw_board()
	for new_piece in new_piece_values:
		place_piece(new_piece["position"], new_piece["value"])
