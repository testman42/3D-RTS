extends CharacterBody3D

var direction_vector

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move(delta)

func move(_delta):
	var hit = move_and_collide(direction_vector)
	if hit:
		var collider = hit.get_collider()
		if collider.is_in_group("opponents"):
			collider.take_damage(10)
		queue_free()
