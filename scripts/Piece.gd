extends Node


class_name Piece

var board_position = Vector2(0, 0)
var next_board_position = Vector2(0, 0)
var value = 0
var has_merged = false
var check_direction = Vector2(0, 0)

func _init(new_board_position, new_value):
	board_position = new_board_position

func _ready():
	pass # Replace with function body.

func init_move(direction):
	next_board_position = board_position
	check_direction = get_check_array(direction)

func next_tile_is_free(direction):
	check_direction = get_check_array(direction)
	return true # map.is_free(next_board_position + check_direction)

func move_to_next_tile(direction):
	check_direction = get_check_array(direction)
	next_board_position += check_direction

func next_piece_is_mergable(direction):
	check_direction = get_check_array(direction)
	return true # map.is_mergeable(next_board_position + check_direction, value)

func increment_value():
	change_value(value * 2)
	
func change_value(new_value):
	value = new_value

func merge(direction):
	move_to_next_tile(direction)
	increment_value()
	has_merged = true

func get_check_array(direction):
	if direction == Enums.Direction.UP:
		check_direction = Vector2(0, -1)
	
	elif direction == Enums.Direction.DOWN:
		check_direction = Vector2(0, 1)	

	elif direction == Enums.Direction.LEFT:
		check_direction = Vector2(-1, 0)

	elif direction == Enums.Direction.RIGHT:
		check_direction = Vector2(1, 0)
