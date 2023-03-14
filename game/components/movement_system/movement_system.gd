extends Node

# TODO: figure out how to split this into ECS
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var parent_node
var movement_vector = Vector2()

# TODO: figure out how to save cpu cycles by having movement code in an if block


func _ready():
	parent_node = get_parent()

func _physics_process(delta):
	
	#TODO: split gravity into it's own component
	# Add the gravity.
	if not parent_node.is_on_floor():
		parent_node.velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = (parent_node.transform.basis * Vector3(movement_vector.x, 0, movement_vector.y)).normalized()
	if direction:
		parent_node.velocity.x = direction.x * SPEED
		parent_node.velocity.z = direction.z * SPEED
	else:
		parent_node.velocity.x = move_toward(parent_node.velocity.x, 0, SPEED)
		parent_node.velocity.z = move_toward(parent_node.velocity.z, 0, SPEED)

	parent_node.move_and_slide()
