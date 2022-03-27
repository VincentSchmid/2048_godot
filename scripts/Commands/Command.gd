extends Node


class_name Command

func execute():
	pass
	
func undo():
	pass

static func get_global_position(board_position) -> Vector2:
	
	var margin = ProjectSettings.get("2048/layout/margin")
	var window_height = ProjectSettings.get("2048/layout/window_height")
	var map_pixel_size = ProjectSettings.get("2048/layout/map_pixel_size")
	var map_size = ProjectSettings.get("2048/layout/map_size")
	
	return Vector2(margin + (map_pixel_size - (2*margin)) / map_size * board_position.x,
				 ((window_height - map_pixel_size) / 2) + margin + (map_pixel_size - (2*margin)) / map_size * board_position.y)
