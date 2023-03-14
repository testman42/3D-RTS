extends Node

var enabled = true
var horisontal_roate_node
var vertical_roate_node

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	horisontal_roate_node = get_parent()
	vertical_roate_node = $"../first_person_camera"

func _input(event):
	if enabled and event is InputEventMouseMotion:
		horisontal_roate_node.rotate_y(event.relative.x*-0.003)
		vertical_roate_node.rotate_x(event.relative.y*-0.003)

func enable():
	enabled = true

func disable():
	enabled = false
