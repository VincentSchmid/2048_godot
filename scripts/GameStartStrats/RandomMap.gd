extends Node

class_name RandomMap


var rng = RandomNumberGenerator.new()

var map = []
const EMPTY_CELL = 0

func populate_map(map_size: int, piece_count: int, starting_pieces: Array) -> Array:
	rng.randomize()
	map = get_empty_map(map_size)
	
	for piece in piece_count:
		var rnd_value = starting_pieces[rng.randi_range(0, starting_pieces.size()-1)]
		var rnd_free_pos = get_random_free_position(map_size)
		map[rnd_free_pos.y][rnd_free_pos.x] = rnd_value

	return map

func get_random_free_position(map_size) -> Vector2:
	var random_position = get_random_position(map_size)
	while not is_free(random_position):
		random_position = get_random_position(map_size)

	return random_position

func get_random_position(map_size) -> Vector2:
	return Vector2(rng.randi_range(0, map_size-1), rng.randi_range(0, map_size-1))

func is_free(position: Vector2):
	return map[position.y][position.x] == EMPTY_CELL

func get_empty_map(map_size) -> Array:
	var _map = [];
	for y in map_size:
		_map.append([]);
		for x in map_size:
			_map[y].append(EMPTY_CELL);
	
	return _map
