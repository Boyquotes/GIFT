extends Control

signal page_changed
signal page_closed
signal changing_scene

onready var player = GameManeger.nodes.player
onready var movement_nodes = {
	"foward" : $uiButtons/btnMoveFoward,
	"backwards" : $uiButtons/btnMoveBackward,
	"left" : $uiButtons/btnMoveLeft,
	"right" : $uiButtons/btnMoveRight,
	"turn_left" : $uiButtons/btnTurnLeft,
	"turn_right" : $uiButtons/btnTurnRight}
onready var alert_node = $uiButtons/btnAlert

var normal_buttom = preload("res://Sprites/UI/sprArrows.png")
var disabled_buttom = preload("res://Sprites/UI/sprArrowsDisabled.png")

var can_interact = false 
var can_close = false
var dialogue_page = 0
var dialogue_text = [
	"",
	"&"]

var scene_to_go = ""

enum interaction_types {
	DIALOGUE,
	DOOR}
var interaction_type = interaction_types.DIALOGUE

func _init():
	GameManeger.nodes.UI = self
func _ready():
	if GameManeger.globals.os_type == "Mobile":
		for node in movement_nodes:
			movement_nodes[node].visible = true
		
		$uiDialogue/txtDialogue.rect_position.y = 249
	elif GameManeger.globals.os_type == "PC":
		for node in movement_nodes:
			movement_nodes[node].visible = false
		
		$uiDialogue/txtDialogue.rect_position.y = 296
func _process(delta):
	update_input()
	update_controls(delta)
	
	tutorial()
	
	if Input.is_action_just_pressed("player_interact"):
		_on_btnAlert_released()

func start_dialogue():
	can_interact = true
	interaction_type = interaction_types.DIALOGUE
func open_page(text :String):
	$uiDialogue.visible = true
	$uiDialogue/txtDialogue.text = text
func close_page():
	$uiDialogue.visible = false
	can_interact = false
	dialogue_page = 0

func at_door(_scene_to_go :String):
	can_interact = true
	interaction_type = interaction_types.DOOR
	scene_to_go = _scene_to_go

func tutorial():
	$uiButtons/txtTutorial.visible = GameManeger.info.on_tutorial

func update_controls(_delta):
	var anm_vel = _delta * 10
	
	if GameManeger.info.player_movable:
		for node in movement_nodes:
			movement_nodes[node].shape_visible = true # Enable collisions
			movement_nodes[node].get_child(0).set_texture(normal_buttom) # Set sprite to normal one
	else:
		for node in movement_nodes:
			movement_nodes[node].shape_visible = false # Disabel collisions
			movement_nodes[node].get_child(0).set_texture(disabled_buttom) # set prite to disabled one
	
	if can_interact:
		if GameManeger.globals.os_type == "Mobile":
			$uiPC.visible = false
			
			$uiButtons/btnAlert.shape_visible = true
			$uiButtons/btnAlert/sprAlert.set_texture(normal_buttom)
		elif GameManeger.globals.os_type == "PC":
			$uiPC.visible = true
			
			$uiPC/barTop.rect_position = $uiPC/barTop.rect_position.linear_interpolate(Vector2(0, 0), anm_vel)
			$uiPC/barBottom.rect_position = $uiPC/barBottom.rect_position.linear_interpolate(Vector2(0, 632), anm_vel)
			$uiPC/barLeft.rect_position = $uiPC/barLeft.rect_position.linear_interpolate(Vector2(0, 0), anm_vel)
			$uiPC/barRight.rect_position = $uiPC/barRight.rect_position.linear_interpolate(Vector2(352, 0), anm_vel)
	else:
		if GameManeger.globals.os_type == "Mobile":
			$uiPC.visible = false
			
			$uiButtons/btnAlert.shape_visible = false
			$uiButtons/btnAlert/sprAlert.set_texture(disabled_buttom)
		elif GameManeger.globals.os_type == "PC":
			$uiPC.visible = true
			
			$uiButtons/btnAlert.shape_visible = false
			$uiButtons/btnAlert/sprAlert.set_texture(null)
			
			$uiPC/barTop.rect_position = $uiPC/barTop.rect_position.linear_interpolate(Vector2(0, -8), anm_vel)
			$uiPC/barBottom.rect_position = $uiPC/barBottom.rect_position.linear_interpolate(Vector2(0, 640), anm_vel)
			$uiPC/barLeft.rect_position = $uiPC/barLeft.rect_position.linear_interpolate(Vector2(-8, 0), anm_vel)
			$uiPC/barRight.rect_position = $uiPC/barRight.rect_position.linear_interpolate(Vector2(360, 0), anm_vel)
func update_input():
	player.button_pressed.foward =  get_node("uiButtons/btnMoveFoward").is_pressed()
	player.button_pressed.backwards =  get_node("uiButtons/btnMoveBackward").is_pressed()
	player.button_pressed.left =  get_node("uiButtons/btnMoveLeft").is_pressed()
	player.button_pressed.right =  get_node("uiButtons/btnMoveRight").is_pressed()
	player.button_pressed.look_left = get_node("uiButtons/btnTurnLeft").is_pressed()
	player.button_pressed.look_right = get_node("uiButtons/btnTurnRight").is_pressed()

func _on_btnAlert_released():
	if can_interact:
		if interaction_type == interaction_types.DIALOGUE:
			if dialogue_text[dialogue_page] == "&":
				emit_signal("page_closed")
				close_page()
				GameManeger.info.player_movable = true
			else:
				emit_signal("page_changed")
				open_page(tr(dialogue_text[dialogue_page]))
				can_interact = true
				dialogue_page += 1
				GameManeger.info.player_movable = false
		elif interaction_type == interaction_types.DOOR:
			emit_signal("changing_scene")
			
			SceneManeger.change_scene(scene_to_go)
func _on_btnMoveBackward_released():
	GameManeger.nodes.player._on_btnMoveBackward_pressed()
