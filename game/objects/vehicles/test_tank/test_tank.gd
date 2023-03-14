extends VehicleBody3D

signal terminated

var shoot_range = 10
var damage = 20
var shoot_cooldown = 1
var current_target

func _ready():
	$character_guiding_logic.enable_guiding_control()
	$health_system.health_depleted.connect(terminate)
	$team_colour.add_mesh($CollisionShape3D2/MeshInstance3D)

#func _process(delta):
func _physics_process(_delta):
	if is_instance_valid(current_target):
		if $rts_shoot.is_in_range(current_target):
			if $rts_shoot.can_shoot():
				$character_guiding_logic.stop()
				$rts_shoot.shoot_at(current_target)
		else:
			attack_object(current_target)

func move_to_location(vector):
	$character_guiding_logic.set_target_location(vector)

func update_health(new_value):
	$health_system.set_health(new_value)

func take_damage(value):
	$health_system.reduce_health(value)

func attack_object(object):
	current_target = object
	$character_guiding_logic.set_target_location(object.position)
#	$rts_shoot.shoot_at(object)

func terminate():
	terminated.emit()
	queue_free()

func set_colour(colour):
	$team_colour.set_colour(colour)

