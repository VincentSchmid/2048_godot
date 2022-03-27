extends Node


class_name DeleteCommand

var _position: Vector2
var _piece: Node
var _parent: Node
var _map: PlayBoard

func _init(position: Vector2, piece: Node, parent: Node, map: PlayBoard):
	_position = position
	_piece = piece
	_parent = parent
	_map = map
	
	_map.remove_piece_by_pos(_position)

func execute():
	_parent.remove_child(_piece)
	
func undo():
	_parent.add_child(_piece)
	_map.set_piece(_position, _piece)
