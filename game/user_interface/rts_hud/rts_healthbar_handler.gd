extends Node

# TODO: should healthbar nodes be children of this node or should they be
# children of their respective parents?

var healthbar_scene
var object_healthbars = {}
var offset = Vector2(0,-30)

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar_scene = preload("res://game/user_interface/rts_health_bar/health_bar.tscn")

func add_object(object):
	if not object in object_healthbars:
		object_healthbars[object] = new_healthbar_instance()
		var h = object.get_node("health_system")
		h.health_changed.connect(change_healthbar_value.bind(object))

func new_healthbar_instance():
	# TODO figure out how to ready this without hardcoding it here
	healthbar_scene = preload("res://game/user_interface/rts_health_bar/health_bar.tscn")
	var new_instance = healthbar_scene.instantiate()
	new_instance.set_value(100)
	add_child(new_instance)
	return new_instance

func update_object_coordinates(object, coordinates):
	if is_instance_valid(object):
		object_healthbars[object].position = coordinates + offset

func show_object_healthbar(object):
	if is_instance_valid(object):
		if not object_healthbars[object].visible:
			object_healthbars[object].show()

func hide_object_healthbar(object):
	if is_instance_valid(object):
		object_healthbars[object].hide()

# this is absolute wizardry
# arguments have to be in order, (value, object), as value already comes with signal
# and object is added with .bind(object). Other way around messes it up
func change_healthbar_value(value, object):
	object_healthbars[object].set_value(value)

func remove_object_healthbar(object):
	object_healthbars[object].queue_free()
