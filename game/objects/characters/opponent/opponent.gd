extends CharacterBody3D

@export var max_health = 20

var movement_vector = Vector2(1,0)

func _ready():
	add_to_group("opponents")

#func _physics_process(delta):
#	$movement_system.movement_vector = movement_vector

func take_damage(amount):
	$health_system.reduce_health(amount)
	
func remove():
	queue_free()

func _on_health_system_health_depleted():
	remove()
