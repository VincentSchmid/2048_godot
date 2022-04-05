extends MapPopulateStrategy


class_name FullBoardTest

func populate_map(map_size: int, piece_count: int, starting_pieces: Array) -> Array:
	var map = .get_empty_map(map_size)
	var num = 0
	for y in map.size():
		for x in map.size()-1:
			map[y][x] = pow(2, num + 1)
			num += 1

	return map
