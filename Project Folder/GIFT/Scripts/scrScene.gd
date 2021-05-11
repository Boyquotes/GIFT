extends Spatial

enum scenes{
	BEG3,
	WF3,
	END,
	PLAYTEST_END,
	OUT2,
	CREDITS}
export (scenes) var currect_scene = scenes.BEG3

# BEG3
export (NodePath) var anm
func open_big_door():
	if currect_scene == scenes.BEG3:
		if not anm == null :
			get_node(anm).play("anmMain")

# WF3, OUT2 & CREDITS
export (Dictionary) var flickering_nodes 
export (int) var min_flickering_speed
export (int) var max_flickering_speed
func _process(delta):
	if currect_scene == scenes.WF3:
		for _node in flickering_nodes:
			get_node(flickering_nodes[_node]).visible = true
			yield(get_tree().create_timer(rand_range(min_flickering_speed, max_flickering_speed)), "timeout")
			get_node(flickering_nodes[_node]).visible = false
			yield(get_tree().create_timer(rand_range(min_flickering_speed, max_flickering_speed)), "timeout")
		
			if _node  == "one":
				get_node(flickering_nodes[_node]).rotate_y(deg2rad(rand_range(90, 0)))
	elif currect_scene == scenes.OUT2:
		var rand_z = rand_range(-37, -48)
		var rand_scale = rand_range(.7, 0.9)
		$nMap/nModels/mdlOut/nDodecas/anmDodeca/nPivot.translation.z = rand_z
		$nMap/nModels/mdlOut/nDodecas/anmDodeca/nPivot.scale = Vector3(rand_scale, rand_scale, rand_scale)
	elif currect_scene == scenes.CREDITS:
		if $anmMain.is_playing() == false:
			if $nCredits/nUI/scrollContainer.scroll_vertical >= 0:
				$nCredits/nUI/pivotExit/btnExit.shape_visible = true
			else:
				$nCredits/nUI/pivotExit/btnExit.shape_visible = false
		
		if on_point_and_click:
			screens()

# END
var going_to_outro = false
func _ready():
	if currect_scene == scenes.END:
		$oUI.connect("page_closed", self, "goto_outro")
		
		OS.set_icon(load("res://Data/Icons/iconMain2.png"))
func talk_to_god():
	if currect_scene == scenes.END:
		$nMap/nMisc/tweenMain.interpolate_property($oPlayer, "translation", $oPlayer.translation, Vector3(89.5,0,25), 0.1)
		$nMap/nMisc/tweenMain.start()
		
		$nMap/nModels/mdlEnd.visible = false
		
		yield(get_tree().create_timer(.7), "timeout")
		$nNPC/godPivot/God/sprGod.play("anmGod")
		$nNPC/godPivot/God2/sprGod2.play("anmGod")
		$nNPC/godPivot/God3/sprGod3.play("anmGod")
		$nNPC/godPivot/God4/sprGod4.play("anmGod")
		$nNPC/godPivot/God5/sprGod5.play("anmGod")
		$nNPC/godPivot/God6/sprGod6.play("anmGod")
func goto_outro():
	if currect_scene == scenes.END:
		if not going_to_outro:
			$nMap/nMisc/anmMain.play("anmGod2")
			going_to_outro = true
		else:
			SceneManeger.change_scene("res://Scenes/Cutscenes/scnOutro.tscn -no-auto-save")
func _physics_process(delta):
	if currect_scene == scenes.END:
		var bus_index = AudioServer.get_bus_index("Amem")
		if $nMap/nSounds/bgmAmem.playing:
			AudioServer.get_bus_effect(bus_index, 0).pre_gain += delta * 7
		else:
			AudioServer.get_bus_effect(bus_index, 0).pre_gain = 0

# PLAYTEST
func _on_end_playtesting_session():
	if currect_scene == scenes.PLAYTEST_END:
		GameManeger.delete_save_file()
		SceneManeger.change_scene("res://Scenes/scnMenu.tscn -direct -no-auto-save")

# CREDITS
var on_point_and_click := false

var screen := 0
var prev_screen := 0

var normal_buttom = preload("res://Sprites/UI/sprArrows.png")
var disabled_buttom = preload("res://Sprites/UI/sprArrowsDisabled.png")

var screen_1 = preload("res://Sprites/Credits/sprPnC1.png")
var screen_2 = preload("res://Sprites/Credits/sprPnC2.png")
var screen_3 = preload("res://Sprites/Credits/sprPnC3.png")

var can_press_foward := true
var can_press_back := false
var can_interact := false
func exit_credits():
	if $nCredits/nUI/pivotExit/btnExit.shape_visible == true:
		GameManeger.delete_save_file()
		SceneManeger.change_scene("res://Scenes/scnMenu.tscn -direct -no-auto-save")
		OS.alert(tr("&thankyou1"), "Fin")
func activate_screens():
	on_point_and_click = true
func _on_upButton_released():
	if can_press_foward:
		screen += 1
		$nSounds/sfxKeyUp.play()
func _on_DownButton_released():
	if can_press_back:
		screen -= 1
		$nSounds/sfxKeyDown.play()
func _on_interactButton_released():
	if can_interact:
		on_point_and_click = false
		
		can_press_foward = false
		can_press_back = false
		can_interact = false
		
		get_node(anm).play("anmPart2")
func screens():
	screen = clamp(screen, 0, 2)
	
	can_press_foward = $nTeaser/nTeaserUI/uiButtons/Up/upButton.shape_visible
	can_press_back = $nTeaser/nTeaserUI/uiButtons/Down/downButton.shape_visible
	can_interact = $nTeaser/nTeaserUI/uiButtons/Interact/interactButton.shape_visible
	
	if screen == 0:
		# Image
		$nTeaser/nTeaserUI/texMap.set_texture(screen_1)
		
		# Interact
		$nTeaser/nTeaserUI/uiButtons/Interact.set_texture(disabled_buttom)
		$nTeaser/nTeaserUI/uiButtons/Interact/interactButton.shape_visible = false
		
		# Up
		$nTeaser/nTeaserUI/uiButtons/Up.set_texture(normal_buttom)
		$nTeaser/nTeaserUI/uiButtons/Up/upButton.shape_visible = true
		
		# Down
		$nTeaser/nTeaserUI/uiButtons/Down.set_texture(disabled_buttom)
		$nTeaser/nTeaserUI/uiButtons/Down/downButton.shape_visible = false
	elif screen == 1:
		# Image
		$nTeaser/nTeaserUI/texMap.set_texture(screen_2)
		
		# Interact
		$nTeaser/nTeaserUI/uiButtons/Interact.set_texture(disabled_buttom)
		$nTeaser/nTeaserUI/uiButtons/Interact/interactButton.shape_visible = false
		
		# Up
		$nTeaser/nTeaserUI/uiButtons/Up.set_texture(normal_buttom)
		$nTeaser/nTeaserUI/uiButtons/Up/upButton.shape_visible = true
		
		# Down
		$nTeaser/nTeaserUI/uiButtons/Down.set_texture(normal_buttom)
		$nTeaser/nTeaserUI/uiButtons/Down/downButton.shape_visible = true
	elif screen == 2:
		# Image
		$nTeaser/nTeaserUI/texMap.set_texture(screen_3)
		
		# Interact
		$nTeaser/nTeaserUI/uiButtons/Interact.set_texture(normal_buttom)
		$nTeaser/nTeaserUI/uiButtons/Interact/interactButton.shape_visible = true
		
		# Up
		$nTeaser/nTeaserUI/uiButtons/Up.set_texture(disabled_buttom)
		$nTeaser/nTeaserUI/uiButtons/Up/upButton.shape_visible = false
		
		# Down
		$nTeaser/nTeaserUI/uiButtons/Down.set_texture(normal_buttom)
		$nTeaser/nTeaserUI/uiButtons/Down/downButton.shape_visible = true
	
	# Check if changed
	# If did, will animate
	if not screen == prev_screen:
		on_point_and_click = false
		get_node(anm).play("anmRefresh")
	prev_screen = screen
func play_next_part():
	get_node(anm).play("anmPart3")

func exit_oob(): # OUT OF BOUNDS
	SceneManeger.change_scene("res://Scenes/scnMenu.tscn -no-auto-save")
	
	var log_file = File.new()
	log_file.open( OS.get_executable_path().get_base_dir() + "/godot.log", File.WRITE)
	log_file.store_string("Godot Engine v3.2.4.official - https://godotengine.org \nOpenGL ES 3.0 Renderer: " + String(OS.get_video_driver_name(OS.get_current_video_driver())) + " \nOpenGL ES Batching: ON \n \n \nERROR: (Person was found out of bounds (in memory : " + String(GameManeger.info.currect_scene) + ")) \n   at: main/guardian.cpp:1248 \n note: Amelio is watching your everystep to make you safe. Still, be careful with walking around.")
	log_file.close()
func exit_3am(): # 3 AM EASTER EGG
	SceneManeger.change_scene("res://Scenes/Wireframe/scnWF1.tscn -direct -no-auto-save")






