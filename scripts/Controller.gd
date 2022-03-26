extends Node

const MAP_SIZE = 4
const PIECE_SIZE = 200
const MARGIN = 50.0
const STARTING_PIECE_COUNT = 2
const POSSIBLE_STARING_PIECES = [2, 4]
const ADD_PIECE_AFTER_MOVE = true

var WINDOW_HEIGHT = ProjectSettings.get_setting("display/window/size/height")
var WINDOW_WIDTH = ProjectSettings.get_setting("display/window/size/width")
var MAP_PIXEL_SIZE = WINDOW_WIDTH

onready var SwipeHandler = get_node("SwipeHandler")
onready var map = get_node("Board")
onready var piece_factory = get_node("Pieces")
onready var mapPopulateStrat = RandomMap.new()

var check_direction
var new_piece_values = []
var piece_has_moved = false

func _ready() -> void:
	SwipeHandler.connect("swiped", self, "on_swipe")
	map.init_map(MAP_SIZE)
	start_game()
	
func on_swipe(swipe_direction):
	var check_columns = false
	var check_in_order = false
	
	match swipe_direction:
		
		Enums.SwipeDirection.SWIPE_LEFT:
			check_columns = true
			check_in_order = true
			continue
			
		Enums.SwipeDirection.SWIPE_RIGHT:
			check_columns = true
			check_in_order = false
			continue
		
		Enums.SwipeDirection.SWIPE_UP:
			check_columns = false
			check_in_order = true
			continue
			
		Enums.SwipeDirection.SWIPE_DOWN:
			check_columns = false
			check_in_order = false
			continue
	
	var check_order = range(MAP_SIZE) if check_in_order else range(MAP_SIZE-1, -1, -1)
	
	if check_columns:
		for x in check_order: # could run in parallel
			var col = map.get_column(x)
			for y in range(col.size()):
				var piece = col[y]
				if piece != null:
					move(Vector2(x, y), piece, swipe_direction)
	
	else:
		for y in check_order: # could run in parallel
			var row = map.get_row(y)
			for x in range(row.size()):
				var piece = row[x]
				if piece != null:
					move(Vector2(x, y), piece, swipe_direction)

	draw()
	if ADD_PIECE_AFTER_MOVE and piece_has_moved:
		piece_has_moved = false
		place_random_piece()

func start_game():
	var value_map = mapPopulateStrat.populate_map(MAP_SIZE,
												STARTING_PIECE_COUNT,
												POSSIBLE_STARING_PIECES)

	place_pieces(value_map)

func move(board_position: Vector2, piece, direction):
	var next_board_position = board_position
	check_direction = get_check_array(direction)

	while map.is_free(next_board_position + check_direction):
		piece_has_moved = true
		next_board_position += check_direction

	if map.is_mergeable(next_board_position + check_direction, piece.value):
		piece_has_moved = true
		next_board_position += check_direction
		merge(piece, map.get_piece(next_board_position), next_board_position)

	piece.next_position = get_global_position(next_board_position)
	map.move_piece(board_position, next_board_position)

func merge(moving_piece, stationary_piece, board_position):
	map.remove_piece(stationary_piece)
	moving_piece.set_value(moving_piece.value * 2)
	moving_piece.has_merged = true

func place_random_piece():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnd_value = POSSIBLE_STARING_PIECES[rng.randi_range(0, POSSIBLE_STARING_PIECES.size()-1)]
	place_piece(map.get_random_free_position(), rnd_value)


func place_pieces(value_map: Array):
	for y in value_map.size():
		for x in value_map[y].size():
			var value = value_map[y][x]
			if value > 0:
				place_piece(Vector2(x, y), value)

func place_piece(board_position: Vector2, value: int):
	var piece = piece_factory.create_piece(get_global_position(board_position), value)
	map.set_piece(piece, board_position)

func draw():
	map.draw_board()
	for new_piece in new_piece_values:
		place_piece(new_piece["position"], new_piece["value"])

func get_global_position(board_position) -> Vector2:
	return Vector2(MARGIN + (MAP_PIXEL_SIZE - (2*MARGIN)) / MAP_SIZE * board_position.x,
				  ((WINDOW_HEIGHT - MAP_PIXEL_SIZE) / 2) + MARGIN + (MAP_PIXEL_SIZE - (2*MARGIN)) / MAP_SIZE * board_position.y)

func get_check_array(direction):
	if direction == Enums.SwipeDirection.SWIPE_UP:
		check_direction = Vector2(0, -1)
	
	elif direction == Enums.SwipeDirection.SWIPE_DOWN:
		check_direction = Vector2(0, 1)	

	elif direction == Enums.SwipeDirection.SWIPE_LEFT:
		check_direction = Vector2(-1, 0)

	elif direction == Enums.SwipeDirection.SWIPE_RIGHT:
		check_direction = Vector2(1, 0)
	
	return check_direction
