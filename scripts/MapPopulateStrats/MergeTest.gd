extends MapPopulateStrategy


class_name MergeTest

func populate_map(map_size: int, piece_count: int, starting_pieces: Array) -> Array:
	map = get_empty_map(map_size)
	map[1][0] = 2
	map[1][2] = 2

	return map
