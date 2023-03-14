extends Marker3D

var camera_height
# min_x, max_x, min_y, max_y ?
var constraints = [-10, 10,-10, 10]

# Use Vector3 instead of Vector2 so that translate() can use it without conversion
var movement_vector = Vector3()
var camera_acceleration = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	move()

func set_primary():
	$camera.current = true
	
func start_moving():
	set_process(true)
	
func stop_moving():
	movement_vector.x = 0
	movement_vector.z = 0
	set_process(false)

func move():
	translate(movement_vector*0.002)

func set_movement_vector(x, z):
	movement_vector = Vector3(x, 0, z)

func change_movement_vector(x, z):
	movement_vector.x += x*camera_acceleration
	movement_vector.z += z*camera_acceleration

func rotate_camera(angle):
	rotation.y += angle

func set_camera_rotation(angle):
	pass

func set_coordinate_constraints(arg1, arg2, arg3, arg4):
	pass

func move_to_coordinates(coordinates):
	pass

func set_hover_ray_direction(onscreen_coordinates):
	var to = $camera.project_local_ray_normal(onscreen_coordinates) * 1000
	$camera/hover_ray.target_position = to

func get_ray_collider():
	return $camera/hover_ray.get_collider()

func return_object_onscreen_coordinates(object):
	if is_instance_valid(object):
		return $camera.unproject_position(object.position)

func get_projected_position(onscreen_coordinates):
	pass

func get_units_within_rectangle(unit_list, rectangle_start, rectangle_end):
	var units_within_rectangle = []
	var max_x = max(rectangle_start.x, rectangle_end.x)
	var max_y = max(rectangle_start.y, rectangle_end.y)
	var min_x = min(rectangle_start.x, rectangle_end.x)
	var min_y = min(rectangle_start.y, rectangle_end.y)
	for unit in unit_list:
		var onscreen_coords = return_object_onscreen_coordinates(unit)
		if onscreen_coords.x <= max_x and onscreen_coords.x >= min_x:
			if onscreen_coords.y <= max_y and onscreen_coords.y >= min_y:
				units_within_rectangle.append(unit)
	return units_within_rectangle

# TODO: figure out this stuff
#func get_object_at_ray(position_on_screen):
#	var ray = RayCast3D.new()
#	add_child(ray)
#	ray.position = $camera.project_ray_origin(position_on_screen)
#	ray.target_position = $camera.project_local_ray_normal(position_on_screen) * 1000
#	print(ray.target_position)
#	return ray.get_collider()

