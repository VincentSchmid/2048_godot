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
	
func _get_new_stack():
	var stack = []
	for i in _undo_count:
		stack.push_front(_get_random_entry())
		
	return stack
	
func get_next_value() -> int:
	pointer -= 1
	return _get_next()["value"]
	
func get_next_position() -> Vector2:
	return _get_next()["position"]
	
func _get_next():
	if rng_stack.empty():
		rng_stack = _get_new_stack()
	
	if pointer < 0:
		pointer = 0
		rng_stack.pop_back()
		rng_stack.push_front(_get_random_entry())
		
	return rng_stack[pointer]
	
func revert():
	pointer += 1

func _get_random_entry() -> Dictionary:
	return {"value": _possible_numbers[rng.randi_range(0, _possible_numbers.size()-1)],
			"position": _map.get_random_free_position()}
