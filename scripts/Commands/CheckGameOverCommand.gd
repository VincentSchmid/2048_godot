extends Command


class_name CheckGameOverCommand

var _game
var command_type = Command.CommandTypes.CHECK_GAME_OVER

func _init(game):
	_game = game
	
func execute():
	_game.game_over = _game.check_game_over()
	
func undo():
	_game.game_over = false
