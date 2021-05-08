extends Spatial

enum cutscenes {
	INTRO,
	INTERLUDE,
	OUTRO}
export(cutscenes) var currect_cutscene

func change_scene():
	if currect_cutscene == cutscenes.INTRO:
		SceneManeger.change_scene("res://Scenes/Begin/scnBegin1.tscn")
	elif currect_cutscene == cutscenes.INTERLUDE:
		SceneManeger.change_scene("res://Scenes/Outside/scnOutPath.tscn")
	elif currect_cutscene == cutscenes.OUTRO:
		SceneManeger.change_scene("res://Scenes/Misc/scnCredits.tscn -no-auto-save")

# INTRO
export(NodePath) var anm
export(NodePath) var mdl_gift
export(NodePath) var btn_gift
func rotate_gift(_delta):
	get_node(mdl_gift).rotate_y(1 * _delta)
func _on_btnGift_released():
	get_node(anm).play("anmPart2")

# OUTRO
export(Dictionary) var nodes = {
	"Venus": NodePath(""),
	"David": NodePath(""),
	"Dodeca": NodePath(""),
	"World": NodePath(""),
	"Grid": NodePath("")}
export(bool) var rotate_gift = false
func can_go_fullscreen(able :bool):
	GameManeger.globals.can_go_fullscreen = able
func ok_pressed():
	if currect_cutscene == cutscenes.OUTRO:
		get_node(anm).play("anmPart3")

func _process(delta):
	if currect_cutscene == cutscenes.INTRO:
		rotate_gift(delta)
	
	if currect_cutscene == cutscenes.OUTRO:
		get_node(nodes.Venus).rotation_degrees.z += delta * 60
		
		get_node(nodes.David).rotation_degrees.z += delta * 150
		
		get_node(nodes.Dodeca).rotation_degrees.x += delta * 70
		get_node(nodes.Dodeca).rotation_degrees.z += delta * 70
		
		get_node(nodes.Grid).rotation_degrees.x += delta * 30
		get_node(nodes.Grid).rotation_degrees.y += delta * 30
		
		if rotate_gift:
			rotate_gift(delta)
	
	if currect_cutscene == cutscenes.INTRO or currect_cutscene == cutscenes.OUTRO:
		if get_node(btn_gift).shape  != null && Input.is_action_just_pressed("player_interact"):
			_on_btnGift_released()
