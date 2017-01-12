extends "res://game/scripts/unit.gd"

var capacity = 2000
var carrying = 0
var collecting_timer = Timer.new()
var closest
export var at_resource = 0

func _ready():
	health = 200
	speed = 3
	collecting_timer.set_one_shot(true)
	collecting_timer.set_wait_time(2)
	collecting_timer.connect("timeout", self, "on_timer_end")
	go_get_resources()

func go_get_resources():
	add_to_group("automatic_collector")
	closest = find_closest_resource()
	set_destination(closest.get_translation())

func on_timer_end():
	print(collecting_timer.get_time_left())
	if collecting_timer.get_time_left() == 0:
		if closest.credits_left > 0:
			closest.pick_up()
			carrying += closest.credits_per_part
			collecting_timer.start()
			print("picked up part of resource")
		else:
			closest.free()
			go_get_resources()

func start_collecting():
	collecting_timer.start()

func find_closest_tt():
	return find_closest_instance_of("economy")

func find_closest_resource():
	return find_closest_instance_of("resources")