extends Node

var parent
var shoot_range = 10
var damage = 20
var shoot_cooldown = 1
var cooldown_timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
#	cooldown_timer.set_wait_time(shoot_cooldown)
	shoot_range = parent.shoot_range
	damage = parent.damage
#	shoot_cooldown = parent.shoot_cooldown
	add_child(cooldown_timer)
	cooldown_timer.wait_time = shoot_cooldown
#	cooldown_timer.one_shot = true
	cooldown_timer.set_one_shot(true)

func shoot_at(object):
	if is_in_range(object) and can_shoot():
		parent.look_at(object.position)
		# TODO: is it ok to have take_damage() in here? Should it be at parent?
		object.take_damage(damage)
		cooldown_timer.start()

func can_shoot():
	return cooldown_timer.is_stopped()

func is_in_range(object):
	if is_instance_valid(object) and object.position.distance_to(parent.position) < shoot_range:
		return true

