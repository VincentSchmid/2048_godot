extends KinematicBody2D


class_name Piece

const SPEED = 6000

var board_position: Vector2
var next_board_position: Vector2

var value_label
var _next_position
var delete_after_move = false
var value
var has_merged = false
var _is_moving = false

signal arrived()

func init(new_board_position: Vector2, value: int):
	value_label = get_child(1)
	set_value(value)
	board_position = new_board_position
	position = get_pixel_position(board_position)
	_next_position = position
	
func _process(delta):
	if _is_moving:
		position = position.move_toward(_next_position, delta * SPEED)
		if position.is_equal_approx(_next_position):
			board_position = next_board_position
			_is_moving = false
			emit_signal("arrived")

func set_value(new_value):
	value = new_value
	value_label.set_value(new_value)

func move():
	_next_position = get_pixel_position(next_board_position)
	_is_moving = true
	
static func get_pixel_position(board_position: Vector2) -> Vector2:
	var margin = ProjectSettings.get("2048/layout/margin")
	var window_height = ProjectSettings.get("2048/layout/window_height")
	var map_pixel_size = ProjectSettings.get("2048/layout/map_pixel_size")
	var map_size = ProjectSettings.get("2048/layout/map_size")
	
	return Vector2(margin + (map_pixel_size - (2*margin)) / map_size * board_position.x,
				 ((window_height - map_pixel_size) / 2) + margin + (map_pixel_size - (2*margin)) / map_size * board_position.y)
