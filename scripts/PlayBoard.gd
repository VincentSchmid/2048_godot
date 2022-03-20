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
var rng
var piece_scence = preload("res://scenes/piece_generic_nonkin.tscn")

func _init(map_size):
	rng = RandomNumberGenerator.new()
	rng.randomize()
	_map_size = map_size
	map = init_map()

func init_map() -> Array:
	var array = [];
	for y in _map_size:
		array.append([]);
		for x in _map_size:
			array[y].append(null);
	return array;

func populate_map():
	for i in STARTING_PIECES:
		place_new_piece()

func place_new_piece():
	var is_piece_placed = false

	while not is_piece_placed:
		var random_position = get_random_position()
		if is_free(Vector2(random_position[0], random_position[1])):
			set_piece(_get_random_piece(), Vector2(random_position[0], random_position[1]))
			is_piece_placed = true

func get_random_free_position() -> Vector2:
	var random_position = get_random_position()
	while not is_free(random_position):
		random_position = get_random_position()
	
	return random_position

func place_at_random_position(piece):
	set_piece(piece, get_random_free_position())

func get_column(index):
	var column = []
	for y in _map_size:
		column.append(map[y][index])
		
	return column

func get_row(index):
	return map[index]

func get_piece_instance():
	var piece = piece_scence.instance()
	add_child(piece)
	return piece

func _get_random_piece():
	var piece = get_piece_instance()
	piece.value = POSSIBLE_STARING_PIECES[rng.randi_range(0, POSSIBLE_STARING_PIECES.size()-1)]
	return piece

func move_piece(from_position, to_position):
	map[to_position.y][to_position.x] = map[from_position.y][from_position.x]
	map[from_position.y][from_position.x] = null

func set_piece(piece, position):
	map[position.y][position.x] = piece

func get_piece(position):
	return map[position.y][position.x]
	
func is_mergeable(position: Vector2, value) -> bool:
	var piece = get_piece(position)
	return not piece.has_merged and piece.value == value
	
func remove_piece(position: Vector2):
	get_piece(position).queue_free()
	map[position.y][position.x] = null

func is_free(position: Vector2) -> bool:
	return get_piece(position) == null

func get_random_position() -> Array:
	return [rng.randi_range(0, _map_size), rng.randi_range(0, _map_size)]

func get_global_position(board_position):
	return Vector2(_size - (2*_margin) / _map_size * (board_position.x + 1), _size - (2*_margin) / _map_size * (board_position.y + 1))
	
func draw_board():
	for col in map:
		for piece in col:
			if piece != null:
				piece.move()
