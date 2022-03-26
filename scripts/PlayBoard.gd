extends Node

class_name PlayBoard

# [0, 0] is top left

var _map_size
var placed_pieces = 0
var map: Array = []
onready var rng = RandomNumberGenerator.new()

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
		map[to_position.y][to_position.x] = map[from_position.y][from_position.x]
		map[from_position.y][from_position.x] = null

func set_piece(piece, position: Vector2):
	map[position.y][position.x] = piece

func get_piece(position: Vector2):
	return map[position.y][position.x]
	
func is_mergeable(position: Vector2, value) -> bool:
	var piece = get_piece(position)
	
	if piece == null:
		return false
		
	return not piece.has_merged and piece.value == value
	
func remove_piece(position: Vector2):
	get_piece(position).queue_free()
	map[position.y][position.x] = null

func is_free(position: Vector2) -> bool:
	return is_on_map(position) && get_piece(position) == null
	
func is_on_map(position: Vector2) -> bool:
	var x = position.x
	var y = position.y
	
	return (x >= 0 && x < _map_size) && (y >= 0 && y < _map_size)
	
func draw_board():
	for col in map:
		for piece in col:
			if piece != null:
				piece.move()
