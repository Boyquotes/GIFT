extends ColorRect

export (bool) var higher_color_depth = true

func _ready():
	if OS.get_video_driver_name(OS.get_current_video_driver()) == "GLES3":
		visible = true
		
		material.set_shader_param("dither_tex", load("res://Shaders/dithers/psxdither.png"))
		
		if higher_color_depth:
			material.set_shader_param("col_depth", 32)
		else:
			material.set_shader_param("col_depth", 7)
	elif OS.get_video_driver_name(OS.get_current_video_driver()) == "GLES2":
		visible = false
