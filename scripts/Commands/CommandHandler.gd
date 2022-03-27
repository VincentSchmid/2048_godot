extends Node


class_name CommandHandler

var _command_stack: Array
var _past_command_stack: Array
var _undo_count: int

func _init(undo_count: int):
	_undo_count = undo_count
	_command_stack = []
	_past_command_stack = []

func _add_past_command(command: Command):
	_past_command_stack.push_front(command)
	
	if _past_command_stack.size() > _undo_count:
		_past_command_stack.pop_back()

func add(command: Command):
	_command_stack.push_back(command)
	
func process_stack():
	while not _command_stack.empty():
		var command = _command_stack.pop_front()
		command.execute()
		_add_past_command(command)

func undo():
	var command = _past_command_stack.pop_front()
	if command != null:
		command.undo()
