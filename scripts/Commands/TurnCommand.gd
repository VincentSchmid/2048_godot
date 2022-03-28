extends Command


class_name TurnCommand

var _priority_command_stack: Array
var _command_stack: Array
var _past_command_stack: Array
var _past_priority_command_stack: Array
var _completed_count: int

signal commands_completed()

func _init():
	_command_stack = []
	_past_command_stack = []

func execute():
	var command
	var prio_stack_size = _priority_command_stack.size()
	var past_prio_commmands = []
	_completed_count = 0
	
	while not _priority_command_stack.empty():
		command = _priority_command_stack.pop_front()
		command.execute()
		_wait_for_commands(command, prio_stack_size)
		_add_past_priority_command(command)
		
	yield(self, "commands_completed")
	
	while not _command_stack.empty():
		command = _command_stack.pop_front()
		command.execute()
		_add_past_command(command)
	
func undo():
	var command
	while not _past_priority_command_stack.empty():
		command = _past_priority_command_stack.pop_front()
		command.undo()
	
	while not _past_command_stack.empty():
		command = _past_command_stack.pop_front()
		command.undo()

func add_priority(command: Command):
	_priority_command_stack.push_back(command)

func add(command: Command):
	_command_stack.push_back(command)
	
func has_commands():
	return not _priority_command_stack.empty() or not _command_stack.empty()

func _add_past_priority_command(command: Command):
	_past_priority_command_stack.push_front(command)

func _add_past_command(command: Command):
	_past_command_stack.push_front(command)

func _wait_for_commands(command: Command, count: int):
	yield(command, "completed")
	_completed_count += 1
	if _completed_count == count:
		emit_signal("commands_completed")
