extends Area

export (String) var scene_to_go
export (bool) var locked = false
export (bool) var interactable = true

var checking : bool

func _ready():
	GameManeger.nodes.UI.connect("changing_scene", self, "_on_changing_scene")
	GameManeger.nodes.UI.connect("page_changed", self, "_on_page_opened")

func _on_oDoor_body_entered(body):
	if body.is_in_group("Player"):
		if interactable:
			if locked:
				checking = true
				GameManeger.nodes.UI.start_dialogue()
				GameManeger.nodes.UI.dialogue_text[0] = "&ui1"
				GameManeger.nodes.UI.dialogue_text[1] = "&"
			else:
				GameManeger.nodes.UI.at_door(scene_to_go)
func _on_oDoor_body_exited(body):
	if body.is_in_group("Player"):
		if interactable:
			checking = false
			GameManeger.nodes.UI.can_interact = false

func _on_changing_scene():
	$doorSFX.play()
func _on_page_opened():
	if checking:
		$doorSFXLocked.play()
