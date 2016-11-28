extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	
func spawn_collector():
	var location = get_node("/root/game/world/actors/constructions/"+get_name()+"/collector_spawn").get_global_transform()
	location = location.origin
	get_node("/root/game").spawn_unit("res://game/scenes/actors/units/collector/collector.tscn", location)
