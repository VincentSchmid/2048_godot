extends MapPopulateStrategy


class_name MergeTest

func populate_map(map_size: int, piece_count: int, starting_pieces: Array) -> Array:
	var map = get_empty_map(map_size)
	map[1][0] = 2
	map[1][1] = 2
	map[1][2] = 4
	map[1][3] = 2

	return map
