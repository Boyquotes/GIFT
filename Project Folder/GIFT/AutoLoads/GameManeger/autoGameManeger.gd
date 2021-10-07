extends Node

var info = {
	player_movable = true,
	on_tutorial = true,
	currect_scene = "",
	unlock_extras = false}
var nodes = {
	player = null,
	UI = null}
var globals = {
	os_type = "Mobile",
	is_wwraping = false,
	did_prank = false,
	can_go_fullscreen = true}

var data_path = "user://" 

func _init():
	check_os()
	window_setup()
	
	if check_save_file():
		_load()
func _process(delta):
	if Input.is_action_just_pressed("player_fullscreen"):
		if globals.can_go_fullscreen:
			OS.window_fullscreen =! OS.window_fullscreen

func _save():
	var save_file = File.new()
	save_file.open( data_path + "gift.sav", File.WRITE)
	save_file.store_line(to_json(info))
	save_file.close()
func _load():
	var save_file = File.new()
	save_file.open(data_path + "gift.sav", File.READ)
	var json :String = save_file.get_as_text()
	var json_result = JSON.parse(json).result
	save_file.close()
	
	info.player_movable = json_result["player_movable"]
	info.on_tutorial = json_result["on_tutorial"]
	info.currect_scene = json_result["currect_scene"]
	if "unlock_extras" in json:
		info.unlock_extras = json_result["unlock_extras"]

func window_setup():
	if globals.os_type == "Mobile":
		ProjectSettings.set_setting("display/window/stretch/aspect", "keep_width")
	elif globals.os_type == "PC":
		ProjectSettings.set_setting("display/window/stretch/aspect", "keep")

func delete_save_file():
	var save_dir = Directory.new()
	save_dir.remove(data_path + "gift.sav")
func check_save_file():
	var options_file = File.new()
	return options_file.file_exists(data_path + "gift.sav")

func check_os():
	if OS.get_name() == "Android" or OS.get_name() == "IOS":
		globals.os_type = "Mobile"
	else :
		globals.os_type = "PC"
