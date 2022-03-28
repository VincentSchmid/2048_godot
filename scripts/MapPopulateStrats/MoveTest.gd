extends MapPopulateStrategy


class_name MoveTest

func populate_map(map_size: int, piece_count: int, starting_pieces: Array) -> Array:
	var map = .get_empty_map(map_size)
	map[0][1] = 2

	return map
