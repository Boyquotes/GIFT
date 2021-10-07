extends Control

signal changing_scene
signal scene_changed

onready var anm = $anmTransitions

func change_scene(scene :String):
	var scene_path :String
	var auto_save = true
	var direct = false
	
	if scene.ends_with(" -no-auto-save"):
		scene = scene.trim_suffix(" -no-auto-save")
		auto_save = false
	else:
		auto_save = true
	
	if scene.ends_with(" -direct"):
		scene_path = scene.trim_suffix(" -direct")
		direct = true
	else:
		scene_path = scene
		direct = false
	
	emit_signal("changing_scene")
	
	if direct:
		get_tree().change_scene(scene_path)
	else:
		GameManeger.info.player_movable = false
		anm.play_backwards("anmFade")
		yield(anm, "animation_finished")
		get_tree().change_scene(scene_path)
		yield(get_tree().create_timer(.3), "timeout")
		anm.play("anmFade")
		yield(anm, "animation_finished")
		GameManeger.info.player_movable = true
	
	emit_signal("scene_changed")
	
	if auto_save:
		GameManeger.info.currect_scene = scene
		GameManeger._save()
		$anmSav.play("anmSave")

func mute_audio(mute: bool):
	AudioServer.set_bus_mute(0, mute)
