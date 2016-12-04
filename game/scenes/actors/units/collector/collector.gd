extends "res://game/scripts/unit.gd"

func _ready():
	health = 200
	speed = 3
	
	begin = get_global_transform()
	begin = begin.origin
	start_collecting()
	
func start_collecting():
	add_to_group("automatic_collector")
	var closest = find_closest_resource()
	set_destination(closest.get_translation())
	
func find_closest_resource():
	var best_resource = 0
	# I really hope someone doesn't make too big map
	var shortest_path = 9001
	for resource in get_tree().get_nodes_in_group("resources"):
		var path = navigation.get_simple_path(get_translation(), resource.get_translation() , true)
		var sum = 0
		for vector in path:
			sum += vector.length()
		if sum < shortest_path:
			shortest_path = sum
			best_resource = resource
	return best_resource