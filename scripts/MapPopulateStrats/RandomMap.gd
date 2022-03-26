extends MapPopulateStrategy


class_name RandomMap

var map

func populate_map(map_size: int, piece_count: int, starting_pieces: Array) -> Array:
	map = .get_empty_map(map_size)
	
	for piece in piece_count:
		var rnd_value = .rand_val(starting_pieces)
		var rnd_free_pos = .get_random_free_position(map, map_size)
		map[rnd_free_pos.y][rnd_free_pos.x] = rnd_value

	return map
