extends "res://game/scripts/construction.gd"


func _ready():
	health = 400
	build_radius = 6
	power = -10
	default_material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.238281,0.238281,0.238281))