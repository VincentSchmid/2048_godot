extends Node


class_name Game

var game_over: bool

var _add_piece_after_move: bool
var _map_size: int
var _map: PlayBoard
var _commandHandler: CommandHandler
var _commandFactory: CommandFactory

var _turnCommand: TurnCommand
var _piece_has_moved = false
var _check_direction: Vector2
var _processing_stack: Array

func _init(
	add_piece_after_move: bool,
	map_size: int,
	map: PlayBoard,
	commandHandler: CommandHandler,
	commandFactory: CommandFactory):

	_add_piece_after_move = add_piece_after_move
	_map = map
	_map_size = map_size
	_commandHandler = commandHandler
	_commandFactory = commandFactory
	game_over = false

func move_phase(direction):
	populate_processing_stack(direction)
	_turnCommand = _commandFactory.create_turn_command()

	for i in _processing_stack.size():
		var board_position = _processing_stack[i]["board_position"]
		var piece = _processing_stack[i]["piece"]
		var next_board_position = board_position
		
		_check_direction = get_check_array(direction)
		
		# MOVEMENT
		
		while _map.is_free(next_board_position + _check_direction):
			_piece_has_moved = true
			next_board_position += _check_direction
		
		if board_position != next_board_position:
			_turnCommand.add(_commandFactory.create_move_command(board_position, 
				next_board_position,
				piece))
		
		# MERGING
		
		board_position = next_board_position
		next_board_position = board_position + _check_direction
		
		if _map.is_mergeable(next_board_position, piece.value):
			_piece_has_moved = true
			
			_turnCommand.add(_commandFactory.create_merge_command(board_position, 
				next_board_position, 
				piece, 
				_turnCommand))

func post_turn_phase():
	for i in _processing_stack.size():
		var piece = _processing_stack[i]["piece"]
		if piece != null:
			piece.has_merged = false
	
	if _piece_has_moved and _add_piece_after_move:
		_piece_has_moved = false
		_turnCommand.add(_commandFactory.create_add_random_piece_command())
	
	if _turnCommand.has_commands:
		_turnCommand.add(_commandFactory.create_check_game_over_command(self))
		_commandHandler.add(_turnCommand)

func check_game_over():
	return _map.is_full() and not has_equal_value_neighbour()

func has_equal_value_neighbour():
	populate_processing_stack(Enums.Direction.UP)
	for i in _processing_stack.size():
		var piece = _processing_stack[i]["piece"]
		for direction in Enums.Direction.size():
			var neighboring_pos = piece.board_position + get_check_array(direction)
			if _map.is_on_map(neighboring_pos) and _map.get_value(neighboring_pos) == piece.value:
				print(piece.board_position, piece.value)
				print(neighboring_pos, _map.get_value(neighboring_pos))
				return true

	return false

func populate_processing_stack(direction):
	var check_columns = false
	var check_in_order = false
	_processing_stack = []

	match direction:
		Enums.Direction.LEFT:
			check_columns = true
			check_in_order = true

		Enums.Direction.RIGHT:
			check_columns = true
			check_in_order = false

		Enums.Direction.UP:
			check_columns = false
			check_in_order = true

		Enums.Direction.DOWN:
			check_columns = false
			check_in_order = false

	var check_order = range(_map_size) if check_in_order else range(_map_size-1, -1, -1)

	if check_columns:
		for x in check_order: # could run in parallel
			var col = _map.get_column(x)
			for y in range(col.size()):
				var piece = col[y]
				if piece != null:
					_processing_stack.append({
						"board_position": Vector2(x, y),
						"piece": piece})

	else:
		for y in check_order: # could run in parallel
			var row = _map.get_row(y)
			for x in range(row.size()):
				var piece = row[x]
				if piece != null:
					_processing_stack.append({
						"board_position": Vector2(x, y),
						"piece": piece})

func get_check_array(direction):
	if direction == Enums.SwipeDirection.SWIPE_UP:
		_check_direction = Vector2(0, -1)
	
	elif direction == Enums.SwipeDirection.SWIPE_DOWN:
		_check_direction = Vector2(0, 1)	

	elif direction == Enums.SwipeDirection.SWIPE_LEFT:
		_check_direction = Vector2(-1, 0)

	elif direction == Enums.SwipeDirection.SWIPE_RIGHT:
		_check_direction = Vector2(1, 0)
	
	return _check_direction
