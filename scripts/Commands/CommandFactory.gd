extends Node

class_name CommandFactory

var command_type = Command.CommandTypes.ADD
var _position: Vector2
var _rng_gen: RngGen
var _value: int
var _piece: Node
var _map: PlayBoard
var _piece_factory: PieceFactory

func _init(rng_gen: RngGen, map: PlayBoard, factory: PieceFactory):
	_rng_gen = rng_gen
	_map = map
	_piece_factory = factory

func create_add_random_piece_command() -> AddPieceCommand:
	return AddPieceCommand.new(_rng_gen, _piece_factory, _map, _piece_factory, Vector2(), 0)

func create_add_piece_command(position: Vector2, value: int) -> AddPieceCommand:
	return AddPieceCommand.new(null, _piece_factory, _map, _piece_factory, position, value)

func create_move_command(board_position: Vector2,
		next_board_position: Vector2,
		piece: Piece) -> MoveCommand:
	return MoveCommand.new(board_position, next_board_position, piece, _map)

func create_merge_command(board_position: Vector2,
		next_board_position: Vector2,
		piece: Piece,
		turnCommand: TurnCommand) -> MergeCommand:
	return MergeCommand.new(board_position, 
		next_board_position, 
		piece, 
		_map.get_piece(next_board_position),
		_piece_factory,
		_map,
		turnCommand)

func create_check_game_over_command(game) -> CheckGameOverCommand:
	return CheckGameOverCommand.new(game)

func create_turn_command() -> TurnCommand:
	return TurnCommand.new()
