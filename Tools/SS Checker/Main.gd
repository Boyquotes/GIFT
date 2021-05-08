extends Node

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _on_btnTogleScene_released():
	$"2D Test".visible =! $"2D Test".visible
	$"3D Test".visible =! $"3D Test".visible
func _on_btnTogleShader_released():
	$Ui/fxShader.visible =! $Ui/fxShader.visible
