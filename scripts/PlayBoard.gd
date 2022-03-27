extends Node

class_name PlayBoard

# [0, 0] is top left

var _map_size
var placed_pieces = 0
var map: Array = []
var garbage_pieces = []
onready var rng = RandomNumberGenerator.new()

var _moving = []

func init_map(map_size):
	_map_size = map_size
	rng.randomize()
	
	map = [];
	for y in _map_size:
		map.append([]);
		for x in _map_size:
			map[y].append(null);

func get_column(index):
	var column = []
	for y in _map_size:
		column.append(map[y][index])
		
	return column

func get_row(index):
	return map[index]

func move_piece(from_position: Vector2, to_position: Vector2 ):
	if from_position != to_position:
		set_piece(to_position, get_piece(from_position))
		map[from_position.y][from_position.x] = null

func set_piece(position: Vector2, piece):
	map[position.y][position.x] = piece

func get_piece(position: Vector2):
	return map[position.y][position.x]
	
func is_mergeable(position: Vector2, value) -> bool:
	if not is_on_map(position):
		return false
	
	var piece = get_piece(position)
	
	if piece == null:
		return false
		
	return not piece.has_merged and piece.value == value
	
func is_full():
	for y in map:
		for piece in map[y]:
			if piece == null:
				return false
	
	return true
	
func remove_piece(piece):
	garbage_pieces.append(piece)

func is_free(position: Vector2) -> bool:
	return is_on_map(position) && get_piece(position) == null
	
func is_on_map(position: Vector2) -> bool:
	var x = position.x
	var y = position.y
	
	return (x >= 0 && x < _map_size) && (y >= 0 && y < _map_size)
	
func remove_piece_by_pos(position: Vector2):
	map[position.y][position.y] = null
	
func get_random_position() -> Vector2:
	return Vector2(rng.randi_range(0, _map_size-1), rng.randi_range(0, _map_size-1))

func get_random_free_position() -> Vector2:
	var random_position = get_random_position()
	while not is_free(random_position):
		random_position = get_random_position()
	
	return random_position

func draw_board():
	for col in map:
		for piece in col:
			if piece != null:
					piece.move()
					wait_for_move_complete(piece)
	
func wait_for_move_complete(piece):
	_moving.append(1)
	yield(piece, "arrived")
	_moving.pop_front()
	
	if _moving == []:
		clear_garbage()

func clear_garbage():
	for piece in garbage_pieces:
		piece.queue_free()
	garbage_pieces = []
