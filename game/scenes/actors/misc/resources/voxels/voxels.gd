extends Spatial


func _ready():
	var voxels = get_node("meshes").get_children()
	for voxel in voxels:
		var material = FixedMaterial.new()
		material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(randf(0.5,0.8), randf(0.5,0.8), randf(0.5,0.8)))
		voxel.set_material_override(material)
		voxel.set_translation(Vector3(randf(-0.3,0.3), 0, randf(-0.3,0.3))) #randf(-0.3,0.3)
		voxel.set_rotation(Vector3(randf(-1,1), randf(-1,1), randf(-1,1)))
	add_to_group("resources")

func _on_area_body_enter( body ):
	pass
