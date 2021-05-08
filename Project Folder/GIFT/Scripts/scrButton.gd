extends Area

export (NodePath) var door

var done = false
var checking = false

func _ready():
	GameManeger.nodes.UI.connect("page_changed", self, "_on_page_opened")
func _process(delta):
	if done:
		$buttonMdlDesactivated.visible = false
		$buttonMdlActivated.visible = true
	else:
		$buttonMdlDesactivated.visible = true
		$buttonMdlActivated.visible = false

func _on_oButtom_body_entered(body):
	if body.is_in_group("Player"):
		if not done:
			checking = true
			GameManeger.nodes.UI.start_dialogue()
			GameManeger.nodes.UI.dialogue_text[0] = "&ui2"
			GameManeger.nodes.UI.dialogue_text[1] = "&"
func _on_oButtom_body_exited(body):
	if body.is_in_group("Player"):
		if not done:
			checking = false
			GameManeger.nodes.UI.can_interact = false

func _on_page_opened():
	if checking:
		done = true
		if get_node(door).is_in_group("Scene"):
			get_node(door).open_big_door()
		else:
			get_node(door).locked = false
		$buttonSound.play()
