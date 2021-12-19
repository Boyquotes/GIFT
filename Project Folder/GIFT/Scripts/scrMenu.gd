extends Control

var can_touch = false
var have_save = false
var new_game = false

func _ready():
	check_save_file()
	reset_icon()
	
	Pause.can_pause = false
func _process(delta):
	if Input.is_action_just_pressed("player_interact"):
		if can_touch:
			if not have_save:
				_on_btnPlay_released()
			else:
				_on_btnContinue_released()
		else:
			_on_btnSkip_released()
	
	if can_touch:
		$anmMain.playback_speed = 1

func activate_touch(activate :bool = true):
	can_touch = activate

func check_save_file():
	if not GameManeger.check_save_file():
		$Play/txtContinue.visible = false
		$Play/txtNewGame.visible = false
		$Play/txtPlay.visible = true
		
		have_save = false
	else:
		$Play/txtContinue.visible = true
		$Play/txtNewGame.visible = true
		$Play/txtPlay.visible = false
		
		have_save = true

func _on_btnPlay_released():
	if can_touch:
		$musAveMaria.stop()
		$sfxButton.play()
		
		new_game = true
		$anmMain.playback_speed = 1
		$anmMain.play_backwards("anmInit")
func _on_btnContinue_released():
	if can_touch:
		SceneManeger.change_scene(GameManeger.info.currect_scene)
		$sfxButton.play()
func _on_btnNewGame_released():
	if can_touch:
		_on_btnPlay_released()
		GameManeger.info.on_tutorial = true

func new_game():
	if new_game:
		SceneManeger.change_scene("res://Scenes/Cutscenes/scnIntro.tscn")

func _on_btnSkip_released():
	$anmMain.playback_speed = 3

func _on_btnTwitter_released():
	if can_touch:
		OS.shell_open("https://twitter.com/ahopness")
func _on_btnLegal_released():
	if can_touch:
		OS.shell_open("https://github.com/Ahopness/GIFT/blob/main/LICENSE")

func _on_btnExtras_released():
	if can_touch:
		SceneManeger.change_scene("res://Scenes/scnExtras.tscn -no-auto-save")

func InitJumpscare():
	if not have_save:
		if not GameManeger.globals.did_prank and not GameManeger.info.unlock_extras:
			GameManeger.globals.did_prank = true
			get_tree().change_scene("res://Scenes/Wireframe/scnWF1.tscn")
		
		$musAveMaria.stream = load("res://Sounds/MUS/musAveMaria2.ogg")
	else:
		$musAveMaria.stream = load("res://Sounds/MUS/musAveMaria.ogg")

func reset_icon():
	OS.set_icon(load("res://Data/Icons/iconMain.png")) 
