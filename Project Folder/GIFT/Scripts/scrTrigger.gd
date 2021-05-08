extends Area

enum types {
	ACTIVATE_BUS_EFFECTS,
	PRINT_TEXT,
	CHANGE_FOOTSTEP,
	SHOW_DIALOGUE,
	CHANGE_SCENE,
	PLAY_SOUND,
	ACTIVATE_NODE,
	DESTROY_NODE,
	KILL_PLAYER,
	LOCK_PLAYER,
	TOGLE_SOUND,
	OUT_OF_BOUNDS,
	PLAY_ANIMATION,
	MAKE_PLAYER_LOOK_AT,
	LOCK_PLAYER_MOVMENT,
	ON_STAIR}

export (bool) var once
export (bool) var checking = true
export (types) var type
export var info = {
	"bus_name": "",
	"print_text": "",
	"footstep_sound": preload("res://Sounds/SFX/sfxFootstep1.ogg"),
	"dialogue_text": ["Lorem ipsum dolor sit amet, consectetur adipiscing elie", "&"],
	"scene_to_change": "Scene path here",
	"sound_to_play": "sound node here",
	"node_to_activate": "Node to activate path here",
	"node_to_destroy": "Node to destroy here",
	"when_died" : "Scene path here",
	"animation_player" : "Animatio Player node path here",
	"animation_name" : "Animation name here",
	"where_to_look_degrees": 1,
	"player_rot_detect" : "front",
	"cam_rot_amount" : 20}

onready var col = $triggerCol

var bus_index :int
var bus_effects_index :int
var currect_rotation :int
var is_on_stairs :bool
var player
var player_direction = null
var prev_player_direction = null

func _process(delta):
	$triggerCol.disabled =! checking

	if type == types.ON_STAIR:
		on_stairs(delta)

func on_stairs(_delta):
	# Wow.... this feature is a whole mess.
	if is_on_stairs:
		var head = player.get_node("playerHead")
		
		# Check player direction. WARNING: Looks like shit, idk how to make it work better.
		if info.player_rot_detect == "front": 
			if player.rotation_degrees.y <= 40 and player.rotation_degrees.y >= -40: # front
				player_direction = "front"
			elif player.rotation_degrees.y <= 140 and player.rotation_degrees.y >= 40: # left
				player_direction = "middle"
			elif player.rotation_degrees.y <= -40 and player.rotation_degrees.y >= -140: # right
				player_direction = "middle"
			else: # back
				player_direction = "back"
		elif info.player_rot_detect == "back": 
			if player.rotation_degrees.y <= 40 and player.rotation_degrees.y >= -40: # front
				player_direction = "back"
			elif player.rotation_degrees.y <= 140 and player.rotation_degrees.y >= 40: # left
				player_direction = "middle"
			elif player.rotation_degrees.y <= -40 and player.rotation_degrees.y >= -140: # right
				player_direction = "middle"
			else: # back
				player_direction = "front"
		elif info.player_rot_detect == "left": 
			if player.rotation_degrees.y <= 40 and player.rotation_degrees.y >= -40: # front
				player_direction = "middle"
			elif player.rotation_degrees.y <= 140 and player.rotation_degrees.y >= 40: # left
				player_direction = "front"
			elif player.rotation_degrees.y <= -40 and player.rotation_degrees.y >= -140: # right
				player_direction = "back"
			else: # back
				player_direction = "middle"
		elif info.player_rot_detect == "right": 
			if player.rotation_degrees.y <= 40 and player.rotation_degrees.y >= -40: # front
				player_direction = "middle"
			elif player.rotation_degrees.y <= 140 and player.rotation_degrees.y >= 40: # left
				player_direction = "back"
			elif player.rotation_degrees.y <= -40 and player.rotation_degrees.y >= -140: # right
				player_direction = "front"
			else: # back
				player_direction = "middle"
		
		# Check if changed
		# If did, will animate
		if not player_direction == prev_player_direction:
			_on_oTrigger_body_entered(player)
		prev_player_direction = player_direction

func _on_oTrigger_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		match(type):
			0: # Activate bus effects
				bus_index = AudioServer.get_bus_index(info.bus_name)
				bus_effects_index = AudioServer.get_bus_effect_count(bus_index)
				
				for effect in bus_effects_index:
					AudioServer.set_bus_effect_enabled(bus_index, effect, true)
			1: # Print text
				print(info.print_text)
			2: # Change Footstep
				body.change_footstep(info.footstep_sound)
			3: # Show dialogue
				GameManeger.nodes.UI.start_dialogue()
				GameManeger.nodes.UI.dialogue_text = info.dialogue_text
			4: # Change scene
				SceneManeger.change_scene(info.scene_to_change)
			5: # Play sound
				get_node(info.sound_to_play).playing =! get_node(info.sound_to_play).playing
			6: # Activate node
				if get_node(info.node_to_activate).is_in_group("Player"): 
					get_node(info.node_to_activate).use_light =! get_node(info.node_to_activate).use_light
				elif get_node(info.node_to_activate).is_in_group("Collision"):
					get_node(info.node_to_activate).visible =! get_node(info.node_to_activate).visible
					get_node(info.node_to_activate).use_collision =! get_node(info.node_to_activate).use_collision 
				elif get_node(info.node_to_activate).is_in_group("Trigger"):
					get_node(info.node_to_activate).checking =! get_node(info.node_to_activate).checking
				else:
					get_node(info.node_to_activate).visible =! get_node(info.node_to_activate).visible
			7: # Destroy node
				get_node(info.node_to_destroy).queue_free()
				self.queue_free()
			8: # Kill player
				body.die(info.when_died)
			9: # Lock player 
				body.player_locked = true
			10: # Togle sound
				get_node(info.sound_to_play).playing =! get_node(info.sound_to_play).playing
			11: # Out of bounds
				get_tree().change_scene("res://Scenes/Misc/scnOutOfBounds.tscn")
			12: # Play animation
				get_node(info.animation_player).play(info.animation_name)
			13: # Make player look at
				$triggerTween.interpolate_property(body, "rotation:y", body.rotation.y, deg2rad(info.where_to_look_degrees), 0.7, Tween.TRANS_SINE, Tween.EASE_OUT)
				$triggerTween.start()
			14: # Lock player Movement
				body.movement_locked = true
			15: # On stairs
				is_on_stairs = true
				var head = body.get_node("playerHead")
				
				if player_direction == "front":
					$triggerTween.interpolate_property(head, "rotation_degrees:x", 0, -info.cam_rot_amount, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
					$triggerTween.start()
				if player_direction == "middle":
					var head_rotation = body.get_node("playerHead").rotation_degrees.x
					
					$triggerTween.interpolate_property(head, "rotation_degrees:x", head_rotation, 0, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
					$triggerTween.start()
				if player_direction == "back":
					$triggerTween.interpolate_property(head, "rotation_degrees:x", 0, info.cam_rot_amount, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
					$triggerTween.start()
func _on_oTrigger_body_exited(body):
	if body.is_in_group("Player"):
		if once:
			checking = false
		match(type):
			0: # Activate bus effects
				if not once:
					for effect in bus_effects_index:
						AudioServer.set_bus_effect_enabled(bus_index, effect, false)
			3: # Show dialogue
				GameManeger.nodes.UI.can_interact = false
			5: # Play sound
				if not once:
					get_node(info.sound_to_play).stop()
			6: # Activate node
				if not once:
					if get_node(info.node_to_activate).is_in_group("Player"):
						get_node(info.node_to_activate).use_light =! get_node(info.node_to_activate).use_light
					elif get_node(info.node_to_activate).is_in_group("Collision"):
						get_node(info.node_to_activate).visible =! get_node(info.node_to_activate).visible
						get_node(info.node_to_activate).use_collision =! get_node(info.node_to_activate).use_collision 
					else:
						get_node(info.node_to_activate).visible =! get_node(info.node_to_activate).visible
			9: # Lock player 
				if not once:
					body.player_locked = false
			10: # Togle sound
				if not once:
					get_node(info.sound_to_play).playing =! get_node(info.sound_to_play).playing
			12: # Play animation
				get_node(info.animation_player).stop()
			14: # Lock player movement
				if not once:
					body.movement_locked = false
			15: # On stairs
				is_on_stairs = false
				
				player_direction = null
				prev_player_direction = null
				
				var head = body.get_node("playerHead")
				var head_rotation = body.get_node("playerHead").rotation_degrees.x
				
				$triggerTween.interpolate_property(head, "rotation_degrees:x", head_rotation, 0, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
				$triggerTween.start()
