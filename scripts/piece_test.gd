extends Node


onready var piece = preload("res://scenes/piece_generic.tscn")
var piece_inst

func _ready():
	piece_inst = piece.instance()
	piece_inst.init(20, Vector2(200, 200))
	add_child(piece_inst)
	
	print(piece_inst.get_path())
	get_node(piece_inst.get_path()).set_value(20)

func _process(delta):
	piece_inst.position = get_viewport().get_mouse_position()
