extends Command


class_name MoveCommand

var command_type = Command.CommandTypes.MOVE
var _from_board_postion: Vector2
var _to_board_position: Vector2
var _piece: Piece
var _map: PlayBoard

signal completed()

func _init(from_board_postion: Vector2, to_board_position: Vector2, piece: Piece, map: PlayBoard):
	_from_board_postion = from_board_postion
	_to_board_position= to_board_position
	_piece = piece
	_map = map

	_map.move_piece(_from_board_postion, _to_board_position)

func execute():
	_piece.next_board_position = _to_board_position
	_piece.move()
	await _piece.arrived
	emit_signal("completed")
	
func undo():
	_map.move_piece(_to_board_position, _from_board_postion)
	_piece.next_board_position = _from_board_postion
	_piece.move()

