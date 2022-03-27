extends Command


class_name TurnCommand

var _command_stack: Array
var _past_command_stack: Array
var _completed_count: int

signal commands_completed()

func _init():
	_command_stack = []
	_past_command_stack = []

func execute():
	var command
	while not _command_stack.empty():
		command = _command_stack.pop_front()
		command.execute()
		_add_past_command(command)
	
func undo():
	while not _past_command_stack.empty():
		var command = _command_stack.pop_front()
		command.undo()

func add(command: Command):
	_command_stack.push_back(command)
	
func _add_past_command(command: Command):
	_past_command_stack.push_front(command)
