extends KinematicBody2D

const SPEED = 15000

var piece: Piece
var value_label
var next_position
var delete_after_move = false
var value
var has_merged = false
var is_moving = false


func init(board_position: Vector2, value: int):
	piece = Piece.new(board_position, value)
	value_label = get_child(1)
	set_value(value)
	position = board_position
	next_position = position
	
func set_merge_state(new_has_merged):
	has_merged = new_has_merged
	piece.has_merged = new_has_merged
	
func _process(delta):
	if is_moving:
		position = position.move_toward(next_position, delta * SPEED)
		if position.is_equal_approx(next_position):
			is_moving = false


func set_value(new_value):
	value = new_value
	piece.change_value(new_value)
	value_label.set_value(new_value)

func move():
	is_moving = true
	has_merged = false
	if delete_after_move:
		delete()

func delete():
	queue_free()
