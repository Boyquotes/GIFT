extends Area

export(bool) var wrap_x = true
export(bool) var wrap_y = true
export(bool) var wrap_z = true

func _process(delta):
	$wrapperCol.disabled = GameManeger.globals.is_wwraping

func _on_oTrigger_body_entered(body):
	if GameManeger.globals.is_wwraping == false:
		if body.is_in_group("Player"):
			GameManeger.globals.is_wwraping = true
			
			var newpos = body.translation
			
			if wrap_x:
				if newpos.x > 1 || newpos.x < 0:
					newpos.x = -newpos.x
			if wrap_y:
				if newpos.y > 1 || newpos.y < 0:
					newpos.y = -newpos.y
			if wrap_z:
				if newpos.z > 1 || newpos.z < 0:
					newpos.z = -newpos.z
			
			body.translation = newpos
func _on_oWrapper_body_exited(body):
	GameManeger.globals.is_wwraping = false
