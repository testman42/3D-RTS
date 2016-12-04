extends "res://game/scripts/construction.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func place():
	add_to_group("buildings")
	spawn_collector()

func spawn_collector():
	var location = get_node("collector_spawn").get_global_transform()
	location = location.origin
	get_node("/root/game").spawn_unit("res://game/scenes/actors/units/collector/collector.tscn", location)
