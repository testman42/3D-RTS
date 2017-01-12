#TODO: refactor economy

extends Spatial
export var credits_per_part = 0
export var credits_left = 0
var parts
var being_collected = 0

func _ready():
	add_to_group("resources")

func pick_up():
	credits_left -= credits_per_part #should be divisible
	var voxels = get_node("meshes").get_children()
	for voxel in voxels:
		if voxel.is_visible():
			voxel.hide()
			break

func _on_area_body_enter(body):
	if !being_collected and "collector" in body.get_parent().get_name():
		body.get_parent().start_collecting()
		being_collected = 1
