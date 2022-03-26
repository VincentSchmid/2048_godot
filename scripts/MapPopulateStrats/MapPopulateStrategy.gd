extends Node

# Returns starting map arrays

class_name MapPopulateStrategy

const EMPTY_CELL = 0

var rng = RandomNumberGenerator.new()

func _init():
	rng.randomize()

func get_empty_map(map_size) -> Array:
	var _map = [];
	for y in map_size:
		_map.append([]);
		for x in map_size:
			_map[y].append(EMPTY_CELL);
	
	return _map

func get_random_free_position(map, map_size) -> Vector2:
	var random_position = get_random_position(map_size)
	while not is_free(map, random_position):
		random_position = get_random_position(map_size)

	return random_position

func get_random_position(map_size) -> Vector2:
	return Vector2(rng.randi_range(0, map_size-1), rng.randi_range(0, map_size-1))

func is_free(map: Array, position: Vector2):
	return map[position.y][position.x] == EMPTY_CELL

func rand_val(arr: Array):
	return arr[rng.randi_range(0, arr.size()-1)]
