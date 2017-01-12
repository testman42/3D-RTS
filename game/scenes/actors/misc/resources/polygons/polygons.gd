#TODO: refactor economy

extends "res://game/scripts/resource.gd"
export var credits = 500
var polygons

func _ready():
	polygons = get_node("meshes").get_children()
	for polygon in polygons:
		polygon.set_translation(Vector3(randf(-0.3,0.3), 0, randf(-0.4,0.4)))
		polygon.set_rotation(Vector3(randf(-1,1), randf(-1,1), randf(-1,1)))
	add_to_group("resources")
	
func pick_up():
	credits -= 100
	var polygons = get_node("meshes").get_children()
	for polygon in polygons:
		if polygon.is_visible():
			polygon.hide()
			break
	