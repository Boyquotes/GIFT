extends Control

func _ready():
	if GameManeger.info.unlock_extras == true:
		$Blocked.free()
	if GameManeger.globals.os_type == "Mobile":
		$clMagrin.visible = false
func _on_btnBack_released():
	SceneManeger.change_scene("res://Scenes/scnMenu.tscn -no-auto-save")
func _on_btnUnlock_released():
	GameManeger.info.unlock_extras = true
	$Blocked.queue_free()

func _process(delta):
	if $scBTS.visible:
		if $scBTS.scroll_vertical <= 18:
			$clMagrin.modulate.a = lerp($clMagrin.modulate.a, 0, delta * 5)
		else:
			$clMagrin.modulate.a = lerp($clMagrin.modulate.a, 1, delta * 5)
	elif $scDevC.visible:
		if $scDevC.scroll_vertical <= 18:
			$clMagrin.modulate.a = lerp($clMagrin.modulate.a, 0, delta * 5)
		else:
			$clMagrin.modulate.a = lerp($clMagrin.modulate.a, 1, delta * 5)
	else:
		$clMagrin.modulate.a = lerp($clMagrin.modulate.a, 0, delta * 5)

func _on_btnBTS_released():
	$scBTS.visible = true
	$scDevC.visible = false
func _on_btnDevC_released():
	$scBTS.visible = false
	$scDevC.visible = true


