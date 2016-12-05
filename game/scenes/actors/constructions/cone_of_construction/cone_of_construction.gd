extends "res://game/scripts/construction.gd"


func _ready():
	health = 800
	build_radius = 8
	building_area = 1.5
	power = 0
	default_material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.226624,0.260188,0.617188))