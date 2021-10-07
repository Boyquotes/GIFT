extends Control

var data_path = "user://" 

func _ready():
	match(TranslationServer.get_locale()):
		"en":
			$obLanguages.select(0)
		"pt":
			$obLanguages.select(1)
		"pt_BR":
			$obLanguages.select(1)
		"es":
			$obLanguages.select(2)
		"de":
			$obLanguages.select(3)
		"fr":
			$obLanguages.select(4)
		"pl":
			$obLanguages.select(5)
	
	Pause.can_pause = false
func _process(delta):
	if Input.is_action_just_pressed("player_interact"):
		_on_btnConfirm_released()

func _on_obLanguages_item_selected(index):
	match(index):
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("pt_BR")
		2:
			TranslationServer.set_locale("es")
		3:
			TranslationServer.set_locale("de")
		4:
			TranslationServer.set_locale("fr")
		5:
			TranslationServer.set_locale("pl")

func _on_btnConfirm_released():
	get_tree().change_scene("res://Scenes/scnBoot.tscn")
