extends Node

class_name Game

const SIZE = 5

var map: PlayBoard = PlayBoard.new(SIZE)
var check_direction = [1, 1]
var SwipeDirection = Enums.SwipeDirection

func _ready():
	pass # Replace with function body.

func move(piece, direction):
	while piece.next_tile_is_free(direction):
		piece.move_to_next_tile(direction)

	if piece.next_piece_is_mergable(direction):
		piece.merge()
