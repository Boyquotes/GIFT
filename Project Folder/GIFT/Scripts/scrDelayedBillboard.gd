extends Spatial

export var delay : float = 0.5
export var lock_x : bool = true

func _process(delta):
	look_at(GameManeger.nodes.player.translation, Vector3.UP)
	
	if lock_x:
		rotation_degrees.x = 0
	
	set_process(false)
	yield(get_tree().create_timer(0.5), "timeout")
	set_process(true)
