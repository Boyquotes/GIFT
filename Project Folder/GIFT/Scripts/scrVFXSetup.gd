extends BackBufferCopy

export var crt_fx = false

func _ready():
	var window_x = get_viewport_rect().size.x / 2
	var window_y = get_viewport_rect().size.y / 2
	position = Vector2(window_x, window_y)
	scale = Vector2(window_x / 10, window_y / 10)
	
	if crt_fx:
		visible = true
		$fxCRT.material.set_shader_param("res", OS.window_size)
