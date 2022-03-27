extends Node


class_name Game

var _map: PlayBoard
var _add_piece_after_move: bool
var _map_size: int
var _check_direction: Vector2
var _command_stack: Array
var _piece_parent: Node
var _piece_has_moved = false
var _possible_starting_pieces: Array

var processing_stack: Array

func _init(
	possible_starting_pieces: Array,
	add_piece_after_move: bool,
	map: PlayBoard,
	map_size: int,
	command_stack: Array,
	piece_parent: Node):

	_possible_starting_pieces = possible_starting_pieces
	_add_piece_after_move = add_piece_after_move
	_map = map
	_map_size = map_size
	_piece_parent = piece_parent
	_command_stack = command_stack

func move_phase(direction):
	populate_processing_stack(direction)

	for i in processing_stack.size():
		var board_position = processing_stack[i]["board_position"]
		var piece = processing_stack[i]["piece"]
		var next_board_position = board_position
		
		_check_direction = get_check_array(direction)
		
		# MOVEMENT
		
		while _map.is_free(next_board_position + _check_direction):
			_piece_has_moved = true
			next_board_position += _check_direction
		
		if board_position != next_board_position:
			_command_stack.push_back(MoveCommand.new(
				board_position,
				next_board_position,
				piece,
				_map))
		
		# MERGING
		
		board_position = next_board_position
		next_board_position = board_position + _check_direction
		
		if _map.is_mergeable(next_board_position, piece.value):
			_piece_has_moved = true
			
			_command_stack.push_back(MergeCommand.new(board_position, 
				next_board_position, 
				piece, 
				_map.get_piece(next_board_position),
				_piece_parent,
				_map))

func post_turn_phase():
	if _map.is_full():
		# check_possible_actions
		pass

	for i in processing_stack.size():
		var piece = processing_stack[i]["piece"]
		if piece != null:
			piece.has_merged = false
	
	if _piece_has_moved and _add_piece_after_move:
		_piece_has_moved = false
		_command_stack.push_back(AddPieceCommand.new(
			_map.get_random_free_position(),
			get_random_value(),
			_piece_parent,
			_map,
			_piece_parent))


func get_random_value():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return _possible_starting_pieces[rng.randi_range(0, _possible_starting_pieces.size()-1)]

func merge(board_position: Vector2, piece, direction):
	pass

func populate_processing_stack(direction):
	var check_columns = false
	var check_in_order = false
	processing_stack = []
	
	match direction:
		
		Enums.Direction.LEFT:
			check_columns = true
			check_in_order = true
			continue
			
		Enums.Direction.RIGHT:
			check_columns = true
			check_in_order = false
			continue
		
		Enums.Direction.UP:
			check_columns = false
			check_in_order = true
			continue
			
		Enums.Direction.DOWN:
			check_columns = false
			check_in_order = false
			continue
	
	var check_order = range(_map_size) if check_in_order else range(_map_size-1, -1, -1)
	
	if check_columns:
		for x in check_order: # could run in parallel
			var col = _map.get_column(x)
			for y in range(col.size()):
				var piece = col[y]
				if piece != null:
					processing_stack.append({
						"board_position": Vector2(x, y),
						"piece": piece})
	
	else:
		for y in check_order: # could run in parallel
			var row = _map.get_row(y)
			for x in range(row.size()):
				var piece = row[x]
				if piece != null:
					processing_stack.append({
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
