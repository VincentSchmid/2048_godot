extends Node


onready var piece = preload("res://scenes/piece_generic.tscn")
var piece_inst

func create_piece(value: int, position: Vector2):
	piece_inst = piece.instance()
	piece_inst.init(value, position)
	add_child(piece_inst)
	return piece_inst
