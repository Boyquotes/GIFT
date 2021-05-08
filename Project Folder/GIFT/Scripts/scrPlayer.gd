extends KinematicBody

var button_pressed = {
	"foward": false,
	"backwards": false,
	"left": false,
	"right": false,
	"look_left": false,
	"look_right": false}

# EXPORT #
export (bool) var use_light = true

# NODES #
onready var head = $playerHead
onready var cam = $playerHead/playerCam
onready var col = $playeCol
onready var gcheck = $playerGCheck
onready var footstep = $playerFoot/playerFootstep
onready var anm = $playerAnim
onready var air_sfx = $playerAir
onready var tween = $playerTween

# MOVEMENT #
var direction = Vector3()
var movement = Vector3()
var moving_on_wall = false
var is_moving = false
var currect_speed = 3
var h_acel = 6
var can_move = false
var can_flip = false

# LOOK #
var sensitivity = 40

# GRAVITY #
enum gravity_states {
	GROUNDED,
	MIDAIR,
	TOUCHDOWN}
export (float) var gravity = 7
var air_acel = 1
var normal_acel = 6
var fall_multiplier = 2.5
var gravity_vec = Vector3()
var full_contact = false
var gravity_state = gravity_states.GROUNDED

# DEATH #
var scene_to_go :String
var died = false

# MISC #
export(bool) var player_locked = false
export(bool) var movement_locked = false
export(NodePath) var clouds = null
enum process_types {
	PROCESSS,
	PHYSICS_PROCESS}
export(process_types) var run_movement_on = process_types.PHYSICS_PROCESS

func _init():
	GameManeger.nodes.player = self 
func _ready():
	fix_light_bightness()
func _physics_process(delta):
	can_move = GameManeger.info.player_movable
	
	$playerFoot/playerLight.visible = use_light
	
	if Input.is_action_just_pressed("player_move_backwards"):
		_on_btnMoveBackward_pressed()
	
	if can_move:
		if run_movement_on == process_types.PHYSICS_PROCESS:
			move(delta)
		look(delta)
	elif not can_move and not anm.current_animation == "anmDie":
		anm.stop()
	
	set_cloud_position()
func _process(delta):
		if can_move:
			if run_movement_on == process_types.PROCESSS:
				move(delta)

func move(_delta):
	#Reset direction
	direction = Vector3()
	
	#Movement
	if not player_locked:
		if not movement_locked:
			if button_pressed.foward or Input.is_action_pressed("player_move_foward"):
				direction -= transform.basis.z
			if button_pressed.backwards or Input.is_action_pressed("player_move_backwards"):
				direction += transform.basis.z
			if button_pressed.left or Input.is_action_pressed("player_move_left"):
				direction -= transform.basis.x
			if button_pressed.right or Input.is_action_pressed("player_move_right"):
				direction += transform.basis.x
	
	#Normalize
	direction = direction.normalized()
	
	#Movement check
	if direction.x + direction.z and is_on_floor():
		is_moving = true
	else:
		is_moving = false
	
	#Organization
	gravity(_delta)
	air_sound(_delta)
	headbob()
	
	direction.z += gravity_vec.z
	direction.x += gravity_vec.x
	direction.y = gravity_vec.y
	
	#Aply movemnt
	move_and_slide(direction * currect_speed, Vector3.UP, false)
func look(_delta):
	if not player_locked :
		if button_pressed.look_left or Input.is_action_pressed("player_turn_left"):
			rotate_y(deg2rad(sensitivity * _delta))
		if button_pressed.look_right or Input.is_action_pressed("player_turn_right"):
			rotate_y(deg2rad(-sensitivity *_delta))

func gravity(_delta):
	#Ground check
	if gcheck.is_colliding():
		full_contact  = true
	else:
		full_contact = false
	
	#Aply gravity
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * (fall_multiplier - 1) * _delta
		h_acel = air_acel
	elif is_on_floor() and full_contact: 
		gravity_vec = -get_floor_normal() * gravity
		h_acel = normal_acel
	else:
		gravity_vec = -get_floor_normal()
		h_acel = normal_acel
func air_sound(_delta):
	if gravity_state == gravity_states.GROUNDED:
		air_sfx.unit_db = lerp(air_sfx.unit_db, -80, 3 * _delta)
		if not is_on_floor():
			gravity_state = gravity_states.MIDAIR
	elif gravity_state == gravity_states.MIDAIR:
		air_sfx.unit_db = lerp(air_sfx.unit_db, 0, 3 * _delta)
		if is_on_floor():
			gravity_state = gravity_states.TOUCHDOWN
	elif gravity_state == gravity_states.TOUCHDOWN:
		$playerFoot/playerFootstep.play()
		gravity_state = gravity_states.GROUNDED
func headbob():
		if is_moving:
			anm.play("anmWalk")
		else:
			anm.play("anmIdle")

func flip():
	if not player_locked:
		if not movement_locked:
			if can_flip:
				tween.interpolate_property(self, "rotation:y", rotation.y, rotation.y + deg2rad(180), .5, Tween.TRANS_SINE, Tween.EASE_OUT)
				tween.start()
				yield(tween, "tween_completed")
				GameManeger.info.on_tutorial = false
			else:
				can_flip = true
				yield(get_tree().create_timer(.5), "timeout")
				can_flip = false
func _on_btnMoveBackward_pressed():
	if GameManeger.info.player_movable:
		flip()

func set_cloud_position():
	if not clouds == null:
		get_node_or_null(clouds).translation.x = translation.x
		get_node_or_null(clouds).translation.z = translation.z

func die(_scene_to_go :String = "scene path here"):
	if not died:
		scene_to_go = _scene_to_go
		anm.play("anmDie")
		GameManeger.info.player_movable = false
		died = true
	else :
		SceneManeger.change_scene(scene_to_go)

func _on_playerFootstep_finished():
	footstep.pitch_scale = rand_range(.8, 1.4)
func change_footstep(res :Resource):
	footstep.stream = res

func fix_light_bightness():
	if OS.get_video_driver_name(OS.get_current_video_driver()) == "GLES3": # The dithering shader makes the game bighter, so im lowering the light
		$playerFoot/playerLight.omni_range = 10
	else:
		$playerFoot/playerLight.omni_range = 17
