extends Node

const MAP_SIZE = 4
const MAP_PIXEL_SIZE = 1770
const MARGIN = 50.0
const STARTING_PIECE_COUNT = 2
const POSSIBLE_STARING_PIECES = [2, 4]

onready var SwipeHandler = get_node("SwipeHandler")
onready var map = get_node("Board")
onready var piece_factory = get_node("Pieces")

var check_direction
var new_piece_values = []

class_name Controller


func _ready() -> void:
	SwipeHandler.connect("swiped", self, "on_swipe")
	map.init_map()
	start_game()
	map.draw_board()
	
func on_swipe(swipe_direction):
	print(swipe_direction)
	var check_columns = false
	var check_in_order = false
	
	match swipe_direction:
		
		Enums.SwipeDirection.SWIPE_LEFT:
			print("left")
			check_columns = true
			check_in_order = true
			continue
			
		Enums.SwipeDirection.SWIPE_RIGHT:
			print("right")
			check_columns = true
			check_in_order = false
			continue
		
		Enums.SwipeDirection.SWIPE_UP:
			print("up")
			check_columns = false
			check_in_order = true
			continue
			
		Enums.SwipeDirection.SWIPE_DOWN:
			print("down")
			check_columns = false
			check_in_order = false
			continue
	
	var check_order = range(MAP_SIZE) if check_in_order else range(MAP_SIZE, 0)
	
	if check_columns:
		for x in check_order:
			var col = map.get_column(x)
			for y in range(col.size()):
				var piece = col[y]
				if piece != null:
					move(Vector2(x, y), piece, swipe_direction)
	
	else:
		for y in check_order:
			var row = map.get_row(y)
			for x in range(row.size):
				var piece = row[x]
				if piece != null:
					move(Vector2(x, y), piece, swipe_direction)

	draw()

func start_game():
	for count in STARTING_PIECE_COUNT:
		place_random_piece()

func move(board_position: Vector2, piece, direction):
	check_direction = get_check_array(direction)
	var next_board_position = board_position

	while map.is_free(next_board_position + check_direction):
		next_board_position += check_direction

	if map.is_mergeable(next_board_position + check_direction, piece.value):
		next_board_position += check_direction
		merge(piece, map.get_piece(next_board_position), next_board_position)

	piece.next_position = get_global_position(next_board_position)
	map.move_piece(board_position, next_board_position)

func merge(piece1, piece2, board_position):
	piece1.delete_after_move = true
	piece2.delete_after_move = true
	new_piece_values.append({"position": board_position, "value": piece1.value * 2})
	
func place_random_piece():
	var rng = RandomNumberGenerator.new()
	var rnd_value = POSSIBLE_STARING_PIECES[rng.randi_range(0, POSSIBLE_STARING_PIECES.size()-1)]
	place_piece(map.get_random_free_position(), rnd_value)

func place_piece(board_position: Vector2, value: int):
	var piece = piece_factory.create_piece(get_global_position(board_position), value)
	map.set_piece(piece, board_position)

func draw():
	map.draw_board()
	for new_piece in new_piece_values:
		place_piece(new_piece["position"], new_piece["value"])

func get_global_position(board_position) -> Vector2:
	return Vector2(MARGIN + (MAP_PIXEL_SIZE - (2*MARGIN)) / MAP_SIZE * board_position.x,
	MARGIN + 1.0 * (MAP_PIXEL_SIZE - (2*MARGIN)) / MAP_SIZE * board_position.y)

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
