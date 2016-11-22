extends Spatial

onready var selected = 0
var gray_mat = FixedMaterial.new()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_body_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if (event.is_action_pressed("select")):
		if (not selected):
			get_node("robot_base/body/hat").set_material_override(gray_mat)
			add_to_group("selected")
		else:
			get_node("robot_base/body/hat").set_material_override(null)
			remove_from_group("selected")
		selected = not selected
