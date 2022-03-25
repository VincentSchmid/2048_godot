extends KinematicBody2D

var piece: Piece
var value_label
var next_position
var delete_after_move = false

func init(board_position: Vector2, value: int):
	piece = Piece.new(board_position, value)
	value_label = get_child(1)
	set_value(value)
	position = board_position
	next_position = position
	
	
func set_value(value):
	piece.change_value(value)
	value_label.set_value(value)

func move():
	position = next_position
	if delete_after_move:
		delete()

func delete():
	queue_free()
