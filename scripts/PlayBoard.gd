extends Node

class_name PlayBoard

# [0, 0] is top left

const STARTING_PIECES = 2
const POSSIBLE_STARING_PIECES = [2, 4]

var _map_size = 4
var placed_pieces = 0
var _size = 1170
var _margin = 100
var map: Array = []
onready var rng = RandomNumberGenerator.new()

func init_map():
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
	
func get_random_position() -> Vector2:
	return Vector2(rng.randi_range(0, _map_size-1), rng.randi_range(0, _map_size-1))

func get_random_free_position() -> Vector2:
	var random_position = get_random_position()
	while not is_free(random_position):
		random_position = get_random_position()
	
	return random_position

func move_piece(from_position, to_position):
	map[to_position.y][to_position.x] = map[from_position.y][from_position.x]
	map[from_position.y][from_position.x] = null

func set_piece(piece, position: Vector2):
	map[position.y][position.x] = piece

func get_piece(position: Vector2):
	return map[position.y][position.x]
	
func is_mergeable(position: Vector2, value) -> bool:
	var piece = get_piece(position)
	return not piece.has_merged and piece.value == value
	
func remove_piece(position: Vector2):
	get_piece(position).queue_free()
	map[position.y][position.x] = null

func is_free(position: Vector2) -> bool:
	return get_piece(position) == null

func get_global_position(board_position):
	return Vector2(_margin + _size - (2*_margin) / _map_size * board_position.x, 
	_margin + _size - (2*_margin) / _map_size * board_position.y)
	
func draw_board():
	for col in map:
		for piece in col:
			if piece != null:
				piece.move()
