extends CanvasLayer

var can_pause = false
var game_paused = false

func _ready():
	$oUI/Menu.visible = false
	
	$oUI/Menu/txtVolume/sldVolume.value = db2linear(AudioServer.get_bus_volume_db(0))
	
func _process(delta):
	if Input.is_action_just_pressed("player_quit"):
		_on_btnPause_released()
	
	$oUI/sprPause.visible = can_pause
	
	if can_pause:
		if game_paused:
			$oUI/Menu.visible = true
			
			if GameManeger.globals.os_type == "Mobile":
				$oUI/sprPause.visible = false
			elif GameManeger.globals.os_type == "PC":
				$oUI/sprPause.visible = false
				
			Engine.time_scale = 0
		else:
			$oUI/Menu.visible = false
			
			if GameManeger.globals.os_type == "Mobile":
				$oUI/sprPause.visible = true
			elif GameManeger.globals.os_type == "PC":
				$oUI/sprPause.visible = false
				
			Engine.time_scale = 1

func _on_btnPause_released():
	game_paused =! game_paused

func _on_btnResume_released():
	game_paused = false
func _on_btnExit_released():
	can_pause = false
	game_paused = false
	
	$oUI/Menu.visible = false
	$oUI/sprPause.visible = true
	Engine.time_scale = 1
	
	SceneManeger.change_scene("res://Scenes/scnMenu.tscn -no-auto-save")

func _on_sldVolume_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))
