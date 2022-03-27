extends Command


class_name MergeCommand

var _from_position: Vector2
var _to_position: Vector2
var _moving_piece: Piece
var _stationary_piece: Piece
var _parent: Node
var _map: PlayBoard
var _moveCommand: MoveCommand
var _deleteCommand: DeleteCommand
var _setValueCommand: SetValueCommand

func _init(from_position: Vector2,
	to_position: Vector2,
	moving_piece: Piece,
	stationary_piece: Piece,
	parent: Node,
	map: PlayBoard):

	_from_position = from_position
	_to_position = to_position
	_moving_piece = moving_piece
	_stationary_piece = stationary_piece
	_parent = parent
	_map = map
	
	_deleteCommand = DeleteCommand.new(_to_position, _stationary_piece, _parent, _map)
	_moveCommand = MoveCommand.new(_from_position, _to_position, _moving_piece, _map)
	_setValueCommand = SetValueCommand.new(_moving_piece, _moving_piece.value * 2)
	_moving_piece.has_merged = true

func execute():
	_deleteCommand.execute()
	_moveCommand.execute()
	_setValueCommand.execute()
	
func undo():
	_setValueCommand.undo()
	_moveCommand.undo()
	_deleteCommand.undo()
	_moving_piece.has_merged = false
