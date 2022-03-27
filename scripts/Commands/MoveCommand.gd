extends Node


class_name MoveCommand

var _from_board_postion: Vector2
var _to_board_position: Vector2
var _piece: Piece
var _map: PlayBoard

func _init(from_board_postion: Vector2, to_board_position: Vector2, piece: Piece, map: PlayBoard):
	_from_board_postion = from_board_postion
	_to_board_position= to_board_position
	_piece = piece
	_map = map

	_map.move_piece(_from_board_postion, _to_board_position)

func execute():
	_piece.next_position = get_global_position(_to_board_position)
	_piece.is_moving = true
	
func undo():
	_map.move_piece(_to_board_position, _from_board_postion)
	_piece.next_position = get_global_position(_from_board_postion)
	_piece.is_moving = true

static func get_global_position(board_position) -> Vector2:
	
	var margin = ProjectSettings.get("2048/layout/margin")
	var window_height = ProjectSettings.get("2048/layout/window_height")
	var map_pixel_size = ProjectSettings.get("2048/layout/map_pixel_size")
	var map_size = ProjectSettings.get("2048/layout/map_size")
	
	return Vector2(margin + (map_pixel_size - (2*margin)) / map_size * board_position.x,
				 ((window_height - map_pixel_size) / 2) + margin + (map_pixel_size - (2*margin)) / map_size * board_position.y)
