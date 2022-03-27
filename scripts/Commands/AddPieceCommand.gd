extends Node

class_name AddPieceCommand

var _position: Vector2
var _value: int
var _piece: Node
var _parent: Node
var _map: PlayBoard
var _factory: PieceFactory

func _init(position: Vector2, value: int, parent: Node, map: PlayBoard, factory: PieceFactory):
	_position = position
	_value = value
	_parent = parent
	_map = map
	_factory = factory
	
	_piece = _factory.create_piece(get_global_position(_position), _value)
	_map.set_piece(_position, _piece)

func execute():
	_factory.place_piece(_piece)
	
func undo():
	_map.remove_piece_by_pos(_position)
	_piece.queue_free()

static func get_global_position(board_position) -> Vector2:
	
	var margin = ProjectSettings.get("2048/layout/margin")
	var window_height = ProjectSettings.get("2048/layout/window_height")
	var map_pixel_size = ProjectSettings.get("2048/layout/map_pixel_size")
	var map_size = ProjectSettings.get("2048/layout/map_size")
	
	return Vector2(margin + (map_pixel_size - (2*margin)) / map_size * board_position.x,
				 ((window_height - map_pixel_size) / 2) + margin + (map_pixel_size - (2*margin)) / map_size * board_position.y)
