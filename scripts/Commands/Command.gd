extends Node


class_name Command

enum CommandTypes {
	MOVE,
	ADD,
	DELETE,
	MERGE,
	SET_VALUE,
}

func execute():
	pass
	
func undo():
	pass
