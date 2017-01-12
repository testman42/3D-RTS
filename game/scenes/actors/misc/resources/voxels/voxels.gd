#TODO: refactor economy

extends "res://game/scripts/resource.gd"
var voxels

func _ready():
	credits_per_part = 200
	credits_left = 1000
	voxels = get_node("meshes").get_children()
	for voxel in voxels:
		var material = FixedMaterial.new()
		material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(randf(0.5,0.8), randf(0.5,0.8), randf(0.5,0.8)))
		voxel.set_material_override(material)
		voxel.set_translation(Vector3(randf(-0.3,0.3), 0, randf(-0.3,0.3))) #randf(-0.3,0.3)
		voxel.set_rotation(Vector3(randf(-1,1), randf(-1,1), randf(-1,1)))
	add_to_group("resources")

func pick_up():
	credits_left -= credits_per_part #should be divisible
	var voxels = get_node("meshes").get_children()
	for voxel in voxels:
		if voxel.is_visible():
			voxel.hide()
			break

func _on_area_body_enter( body ):
	if !being_collected and "collector" in body.get_parent().get_name():
		body.get_parent().start_collecting()
		being_collected = 1
