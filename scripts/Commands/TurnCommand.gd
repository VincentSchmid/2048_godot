extends Command


class_name TurnCommand

var has_commands = false
var _command_stacks: Array
var _past_command_stacks: Array
var _completed_count: int

signal commands_completed()

func _init():
	for commandType in Command.CommandTypes:
		_command_stacks.append([])
		_past_command_stacks.append([])

func execute():
	var command
	var move_commands = _command_stacks[Command.CommandTypes.MOVE]
	var move_commands_stack_size = move_commands.size()
	has_commands = false
	_completed_count = 0
	
	while not move_commands.is_empty():
		command = move_commands.pop_front()
		command.execute()
		_wait_for_commands(command, move_commands_stack_size)
		_add_past_command(command)
		
	await commands_completed
	
	for command_stack in _command_stacks:
		while not command_stack.is_empty():
			command = command_stack.pop_front()
			command.execute()
			_add_past_command(command)
	
func undo():
	var command
	var past_add_commands = _past_command_stacks[Command.CommandTypes.ADD]
	var past_move_commands = _past_command_stacks[Command.CommandTypes.MOVE]

	while not past_add_commands.is_empty():
		command = past_add_commands.pop_front()
		command.undo()

	while not past_move_commands.is_empty():
		command = past_move_commands.pop_front()
		command.undo()
	
	for i in _past_command_stacks.size():
		while not _past_command_stacks[i].is_empty():
			command = _past_command_stacks[i].pop_front()
			command.undo()

func add(command: Command):
	has_commands = true
	_command_stacks[command.command_type].push_back(command)

func _add_past_command(command: Command):
	_past_command_stacks[command.command_type].push_front(command)

func _wait_for_commands(command: Command, count: int):
	await command.completed
	_completed_count += 1
	if _completed_count == count:
		emit_signal("commands_completed")
