extends CharacterBody3D

@export var max_health = 100

func _ready():
	$shoot.set_aim_ray( $first_person_camera/aim_ray )
	$shoot.set_projectile_anchor( $first_person_camera/projectile_anchor )
	$shoot.set_projectile_scene( preload("res://game/objects/projectile/projectile.tscn") )

func set_movement_vector(vector):
	$movement_system.movement_vector = vector

func take_damage(amount):
	$health_system.reduce_health(amount)

func shoot_hitscan():
	if $inventory.ammo > 0:
		$shoot.shoot_hitscan()
		reduce_ammo()
	
func shoot_projectile():
	if $inventory.ammo > 0:
		$shoot.shoot_projectile()
		reduce_ammo()

func enable_control():
	$mouselook.enable()

func disable_control():
	$mouselook.disable()
	
func reduce_ammo(value = 1):
	$inventory.reduce_ammo(value)

func get_ammo_count():
	return $inventory.ammo

func _on_health_system_health_changed():
	pass
	#$first_person_camera/fps_hud/health_indicator/ProgressBar.value = $health_system.get_current_health()
