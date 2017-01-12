extends "res://game/scripts/construction.gd"

func _ready():
	health = 200
	build_radius = 6
	building_area = 1.5
	power = -10
	price = 500
	default_material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.847656,0.736732,0.403961))

func place():
	add_to_group("buildings")
	add_to_group("available_build_area")
	add_to_group("economy")
	spawn_collector()

func spawn_collector():
	var location = get_node("collector_spawn").get_global_transform()
	location = location.origin
	get_node("/root/game").spawn_unit("res://game/scenes/actors/units/collector/collector.tscn", location)
