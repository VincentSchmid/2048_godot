extends Node


onready var piece = preload("res://scenes/piece_generic.tscn")
var piece_inst

func create_piece(position: Vector2, value: int):
	piece_inst = piece.instance()
	piece_inst.init(position, value)
	add_child(piece_inst)
	return piece_inst
