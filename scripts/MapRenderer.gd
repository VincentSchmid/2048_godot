extends Node

class_name MapRenderer

var _size = 1000
var _margin = 50

func _init(size, margin):
	_size = size
	_margin = margin
	
func get_global_position(board_position):
	return Vector2(_size - (2*_margin) / 4 * (board_position.x + 1), _size - (2*_margin) / 4 * (board_position.y + 1))
	
func draw(map):
	for col in map:
		for piece in col:
			if piece != null:
				piece.position = get_global_position(piece.next_board_position)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
