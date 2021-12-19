extends CanvasLayer

var can_pause = false
var game_paused = false

func _ready():
	$oUI/Menu.visible = false
	
	$oUI/Menu/txtVolume/sldVolume.value = db2linear(AudioServer.get_bus_volume_db(0))
	
	var window_x = OS.window_size.x / 2
	var window_y = OS.window_size.y / 2
	$oUI/Menu/backBufferCopy.position = Vector2(window_x, window_y)
	$oUI/Menu/backBufferCopy.scale = Vector2(window_x / 10, window_y / 10)
func _process(delta):
	if Input.is_action_just_pressed("player_quit"):
		_on_btnPause_released()
	
	$oUI/sprPause.visible = can_pause
	
	if can_pause:
		if game_paused:
			$oUI/Menu.visible = true
			if get_tree().current_scene.name.begins_with("scnWF"):
				$oUI/Menu/txtExit.text = tr("$pause4")
			else:
				$oUI/Menu/txtExit.text = tr("$pause2")
			
			if GameManeger.globals.os_type == "Mobile":
				$oUI/sprPause.visible = false
			elif GameManeger.globals.os_type == "PC":
				$oUI/sprPause.visible = false
				
			get_tree().paused = true
		else:
			$oUI/Menu.visible = false
			
			if GameManeger.globals.os_type == "Mobile":
				$oUI/sprPause.visible = true
			elif GameManeger.globals.os_type == "PC":
				$oUI/sprPause.visible = false
				
			get_tree().paused = false

func _on_btnPause_released():
	game_paused =! game_paused

func _on_btnResume_released():
	game_paused = false
func _on_btnExit_released():
	can_pause = false
	game_paused = false
	
	$oUI/Menu.visible = false
	$oUI/sprPause.visible = true
	get_tree().paused = false
	
	SceneManeger.change_scene("res://Scenes/scnMenu.tscn -no-auto-save")

func _on_sldVolume_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))
