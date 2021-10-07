extends Control

func _ready():
	$"2D".visible = true

func _process(delta):
	if Input.is_action_just_pressed("play"):
		$"2D/Footage".playing =! $"2D/Footage".playing
	if Input.is_action_just_pressed("reset"):
		$"2D/Footage".frame = 0
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if $"2D/Footage".playing:
		#print($"2D/Footage".frame)
		
		$Frame.visible = false
	else:
		$Frame.visible = true
		$Frame.text = String($"2D/Footage".frame)

func _on_Footage_animation_finished():
	$"2D/Footage".playing = false
