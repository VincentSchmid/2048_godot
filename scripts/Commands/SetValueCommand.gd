extends Command


class_name SetValueCommand

var _piece: Piece
var _value: int
var _prev_value: int

func _init(piece: Piece, value: int):
	_piece = piece
	_value = value
	_prev_value = _piece.value
	
	_piece.value = _value

func execute():
	_piece.set_value(_value)
	
func undo():
	_piece.set_value(_prev_value)
