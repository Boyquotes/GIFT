extends Control

func _process(delta):
	if not $btnSkip.shape == null:
		if Input.is_action_just_pressed("player_interact"):
			_on_vpBoot_finished()

func _on_vpBoot_finished():
	SceneManeger.change_scene("res://Scenes/scnMenu.tscn -no-auto-save")
func _on_btnSkip_released():
	_on_vpBoot_finished()
