extends Node

# TODO: fix this absolute mess

signal deposited
signal terminated

var character_speed = 10

var collect_timer = Timer.new()
# TODO: lol find more elegant solution to this
var resource_queue_free_buffer_timer = Timer.new()
var automated_collecting_behaviour = true
var current_target_resource
var current_collected_amount = 0
var storage_capacity = 2
var minimum_range_for_collecting = 3
var current_dump_point
var returning_to_dump_point = false
#var collect_even_without_dump_point = false

enum order {halted, automated_collecting, targeting_specific_resource}
enum collector_state {idle, moving_to_resource, collecting, moving_to_deposit, depositing}

func _ready():
	$character_guiding_logic.enable_guiding_control()
	$health_system.health_depleted.connect(terminate)
	$team_colour.add_mesh($CollisionShape3D2/MeshInstance3D)
	add_child(collect_timer)
	add_child(resource_queue_free_buffer_timer)
	resource_queue_free_buffer_timer.wait_time = 0.5
	collect_timer.wait_time = 3
	collect_timer.one_shot = true
	collect_timer.timeout.connect(collect_resource)
	resource_queue_free_buffer_timer.one_shot = true
	resource_queue_free_buffer_timer.timeout.connect(go_collect_next_resource)
	
	enable_automated_collecting_behaviour()

func _physics_process(_delta):
	if is_instance_valid(current_target_resource):
		# again new variable because otherwise too long line for PEP8
		var distance = self.position.distance_to(current_target_resource.position)
		if distance < minimum_range_for_collecting and collect_timer.is_stopped():
			if current_collected_amount < storage_capacity:
				$character_guiding_logic.stop()
				start_collecting(current_target_resource)
	if returning_to_dump_point and is_instance_valid(current_dump_point):
		var dump_distance = self.position.distance_to(current_dump_point.global_position)
		if dump_distance < 2:
			deposit_collected_resources()
			current_dump_point = null

func terminate():
	terminated.emit()
	queue_free()

#func handle_state(state):
#	match state:
#		collector_state.idle:
#			pass
#		collector_state.moving_to_resource:
#			pass
#		collector_state.collecting:
#			pass
#		collector_state.moving_to_deposit:
#			pass
#		collector_state.depositing:
#			pass
	

func find_closest_available_resource():
	var min_distance = 9001
	var closest_resource
	for resource in get_tree().get_nodes_in_group("resources"):
		var distance_to_resource = self.position.distance_to(resource.position)
		if distance_to_resource < min_distance and not resource.being_collected:
			min_distance = distance_to_resource
			closest_resource = resource
	return closest_resource

func go_collect_next_resource():
#	if collect_even_without_dump_point:
	if current_collected_amount < storage_capacity:
		var closest_resource = find_closest_available_resource()
		if closest_resource:
			set_target_resource(closest_resource)
		else:
			move_to_deposit_position()
	else:
		move_to_deposit_position()

func move_to_location(vector):
	$character_guiding_logic.set_target_location(vector)

func set_target_resource(resource):
	current_target_resource = resource
	resource.being_collected = true
	move_to_resource(resource)

func move_to_resource(resource):
	$character_guiding_logic.set_target_location(resource.position)

func start_collecting(resource):
	collect_timer.start()

func collect_resource():
	current_collected_amount += 1
	current_target_resource.get_collected()
	if automated_collecting_behaviour:
		resource_queue_free_buffer_timer.start()
	else:
		current_target_resource = null

func move_to_deposit_position():
	var dump_place = get_tree().get_first_node_in_group("deposit_positions")
	if dump_place:
		current_dump_point = dump_place
		move_to_location(dump_place.global_position)
		returning_to_dump_point = true

func deposit_collected_resources():
	deposited.emit(current_collected_amount)
	current_collected_amount = 0
	current_dump_point = null
	returning_to_dump_point = false
	go_collect_next_resource()

func enable_automated_collecting_behaviour():
	automated_collecting_behaviour = true
	go_collect_next_resource()

func disable_automated_collecting_behaviour():
	automated_collecting_behaviour = false

func abort_collecting():
	current_target_resource = null

func set_current_deposit_building_instance(object):
	pass

func set_colour(colour):
	$team_colour.set_colour(colour)
