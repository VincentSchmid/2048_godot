extends Node


class_name RngGen

var _undo_count: int
var _possible_numbers: Array
var _map: PlayBoard

var rng: RandomNumberGenerator
var rng_stack: Array
var pointer = 0

func _init(undo_count: int, possible_numbers: Array, map: PlayBoard):
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	_undo_count = undo_count
	_possible_numbers = possible_numbers
	_map = map
	rng_stack = []
	
func get_next_value() -> int:
	return _get_next()["value"]
	
func get_next_position() -> Vector2:
	pointer -= 1
	
	var pos = _get_next()["position"]
	
	if not _map.is_free(pos):
		print("collsion")
		pos = _reset_pos()
	return pos
	
func _reset_pos():
	var val = rng_stack[pointer]["value"]
	rng_stack[pointer] = _get_random_entry()
	rng_stack[pointer]["value"] = val
	
	return rng_stack[pointer]["position"]
	
func _get_next():
	if pointer < 0:
		pointer = 0
		rng_stack.push_front(_get_random_entry())
	
	if rng_stack.size() > _undo_count:
		rng_stack.pop_back()
	
	return rng_stack[pointer]
	
func revert():
	pointer += 1

func _get_random_entry() -> Dictionary:
	return {"value": _possible_numbers[rng.randi_range(0, _possible_numbers.size()-1)],
			"position": _map.get_random_free_position()}
