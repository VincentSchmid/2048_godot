extends Node


class_name PieceFactory

onready var piece = preload("res://scenes/piece_generic.tscn")
var piece_inst

func create_piece(position: Vector2, value: int):
	piece_inst = piece.instance()
	piece_inst.init(position, value)
	return piece_inst
	
func place_piece(piece_inst):
	add_child(piece_inst)
