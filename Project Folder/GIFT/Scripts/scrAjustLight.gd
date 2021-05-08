extends Spatial

export(Dictionary) var light_nodes = {
	"light1" : NodePath(""),
	"light2" : NodePath(""),
	"light3" : NodePath("")}

func _ready():
	for light_node in light_nodes.values():
		var _node = get_node(light_node)
		if not _node == null:
			var light_energy = _node.light_energy
			if OS.get_video_driver_name(OS.get_current_video_driver()) == "GLES3":
				_node.light_energy = light_energy
			if OS.get_video_driver_name(OS.get_current_video_driver()) == "GLES2":
				_node.light_energy = light_energy + 4
