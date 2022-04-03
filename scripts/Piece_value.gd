extends TextureRect


func set_value(value: int):
	var text_val = String(value)
	texture = load("res://images/numbers/" + str(value) + ".png")
