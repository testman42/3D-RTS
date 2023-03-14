extends Node

var parent
var controlled = false
@export var character_speed: float = 20.0
@onready var _nav_agent = NavigationAgent3D.new()

func _ready():
	parent = get_parent()
	parent.add_child.call_deferred(_nav_agent)
	if parent.get("character_speed"):
		character_speed = parent.get("character_speed")
#	_nav_agent.set_avoidance_enabled(true)
#	_nav_agent.neighbor_distance = 1000

#func _process(delta):
#	move_towards_destination(delta)

func enable_guiding_control():
	controlled = true
	parent.set_freeze_enabled(true)
	set_process(true)

func disable_guiding_control():
	controlled = false
	set_process(false)

func move_towards_destination(delta):
	if _nav_agent.is_navigation_finished():
		return
	var next_position = _nav_agent.get_next_path_position()
	var offset = next_position - parent.position
	parent.position = parent.position.move_toward(next_position, delta * character_speed)
	offset.y = 0
	parent.look_at(parent.position + offset, Vector3.UP)

func stop():
	_nav_agent.set_target_position(parent.position)

# lol most of code is stolen from here:
# https://github.com/godotengine/godot-demo-projects/tree/master/3d/navmesh
func set_target_location(target_location: Vector3):
	_nav_agent.set_target_position(target_location)

func _physics_process(delta):
	move_towards_destination(delta)
