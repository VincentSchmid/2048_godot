extends Label

var font_path = "res://font/firaCode_bold.tres"

var text_sizeByCount = {
	1: 100,
	2: 90,
	3: 75,
	4: 60,
	5: 50
}

func set_value(value: int):
	var text_val = String(value)
	text = text_val
	# get_font(font_path).size = 
	var my_font = get("custom_fonts/font")
	my_font.size = text_sizeByCount[text_val.length()]
