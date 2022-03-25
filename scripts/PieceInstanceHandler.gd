extends KinematicBody2D

var piece: Piece
var value_label
var next_position
var delete_after_move = false
var value
var has_merged = false

func init(board_position: Vector2, value: int):
	piece = Piece.new(board_position, value)
	value_label = get_child(1)
	set_value(value)
	position = board_position
	next_position = position
	
func set_merge_state(new_has_merged):
	has_merged = new_has_merged
	piece.has_merged = new_has_merged


func set_value(new_value):
	value = new_value
	piece.change_value(new_value)
	value_label.set_value(new_value)

func move():
	position = next_position
	if delete_after_move:
		delete()

func delete():
	queue_free()
