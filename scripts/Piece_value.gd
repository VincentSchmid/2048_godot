extends TextureRect


func set_value(value: int):
	texture = load("res://images/numbers/" + str(value) + ".png")
