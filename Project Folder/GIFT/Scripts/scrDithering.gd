extends ColorRect

export (bool) var higher_color_depth = true

func _ready():
	var window_x = get_viewport_rect().size.x / 2
	var window_y = get_viewport_rect().size.y / 2
	get_parent().position = Vector2(window_x, window_y)
	get_parent().scale = Vector2(window_x / 10, window_y / 10)
	
	material.set_shader_param("dither_tex", load("res://Shaders/dithers/psxdither.png"))
	
	if higher_color_depth:
		material.set_shader_param("col_depth", 32)
	else:
		material.set_shader_param("col_depth", 7)
	
	material.set_shader_param("buf_size", OS.window_size)
	material.set_shader_param("dith_size", material.get_shader_param("dither_tex").get_size())
