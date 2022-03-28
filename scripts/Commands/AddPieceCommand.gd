extends Command


class_name AddPieceCommand

var _position: Vector2
var _rng_gen: RngGen
var _value: int
var _piece: Node
var _parent: Node
var _map: PlayBoard
var _factory: PieceFactory

func _init(rng_gen: RngGen, parent: Node, map: PlayBoard, factory: PieceFactory, position: Vector2, value: int):
	_position = position
	_rng_gen = rng_gen
	_value = value
	_parent = parent
	_map = map
	_factory = factory
	
	if rng_gen != null:
		_position = rng_gen.get_next_position()
		_value = rng_gen.get_next_value()
	
	_piece = _factory.create_piece(.get_global_position(_position), _value)
	_map.set_piece(_position, _piece)

func execute():
	_factory.place_piece(_piece)
	
func undo():
	_rng_gen.revert()
	_map.remove_piece_by_pos(_position)
	_piece.queue_free()
