extends "res://game/scripts/construction.gd"


func _ready():
	health = 200
	build_radius = 6
	power = 50
	default_material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.392908,0.295258,0.585938))