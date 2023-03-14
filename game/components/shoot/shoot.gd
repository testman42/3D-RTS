extends Node

signal target_hit

var parent_node
var aim_ray
var projectile_anchor
var projectile_scene

# used as a toggle for when all initial requirements are satisfied
var ready_to_shoot = false

func _ready():
	parent_node = get_parent()

func set_aim_ray(aim_ray_node):
	aim_ray = aim_ray_node
	check_ready_to_shoot()

func set_projectile_anchor(projectile_anchor_node):
	projectile_anchor = projectile_anchor_node
	check_ready_to_shoot()

func set_projectile_scene(new_scene):
	projectile_scene = new_scene
	check_ready_to_shoot()

func check_ready_to_shoot():
	#if aim_ray and projectile_anchor and projectile_scene:
	if aim_ray:
		ready_to_shoot = true

func shoot_hitscan():
	if ready_to_shoot:
		var target = aim_ray.get_collider()
		if target and target.is_in_group("opponents"):
			target.take_damage(10)
			emit_signal("target_hit")
			
func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	projectile.global_transform = projectile_anchor.global_transform
	projectile.direction_vector = -projectile_anchor.global_transform.basis.z
	get_node("../..").add_child(projectile)
