extends Node


class_name PieceFactory

onready var piece = preload("res://scenes/piece_generic.tscn")
var piece_inst
var _piece_scale: float

func set_piece_scale(scale: float):
	_piece_scale = scale

func create_piece(position: Vector2, value: int):
	piece_inst = piece.instance()
	piece_inst.init(position, value, _piece_scale)
	return piece_inst
	
func place_piece(piece_inst):
	add_child(piece_inst)
