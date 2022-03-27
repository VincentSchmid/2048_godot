extends Node


var _from_board_postion
var _to_board_position
var _piece

func _init(from_board_postion: Vector2, to_board_position: Vector2, piece: Piece):
	_from_board_postion = from_board_postion
	_to_board_position= to_board_position
	_piece = piece

func execute():
	piece.next_position = Controller._to_position
	
func undo():
	pass
