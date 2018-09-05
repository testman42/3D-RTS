extends Position3D

export var camera_speed = 0.003
export var camera_rotation = 0.0
export var direction = Vector3()
export var fast_move = false
export var rotating_camera = false

onready var debug = get_node("../../settings").debug

func _ready():	
	set_process_input(true)
	direction.y = 0
	camera_rotation = get_rotation().y
	set_rotation(Vector3(0, camera_rotation, 0))
	for zone in $camera_navigation_zones.get_children():
		if debug: print("mouse_enter_"+zone.get_name())
		zone.connect("mouse_entered", self, "_mouse_enter_"+zone.get_name())
		zone.connect("mouse_exited", self, "_mouse_exit_"+zone.get_name())

func _process(delta):
	move_camera()

func start_moving_camera():
	set_process(true)

func stop_camera():
	direction.x = 0
	direction.z = 0
	set_process(false)

func move_camera():
	translate(direction*camera_speed)
	
func rotate_camera(degrees):
	camera_rotation += degrees
	set_rotation(Vector3(0, camera_rotation, 0))

func change_direction(x,z):
	direction.x += x
	direction.z += z

func focus_on(coordinates):
	set_translation(coordinates)

func _mouse_enter_top():
	if !fast_move and !rotating_camera:
		change_direction(0,-90)
		start_moving_camera()

func _mouse_enter_bottom():
	if !fast_move and !rotating_camera:
		change_direction(0,90)
		start_moving_camera()

func _mouse_enter_left():
	if !fast_move and !rotating_camera:
		change_direction(-90,0)
		start_moving_camera()

func _mouse_enter_right():
	if !fast_move and !rotating_camera:
		change_direction(90,0)
		start_moving_camera()

func _mouse_enter_top_right_corner():
	if !fast_move and !rotating_camera:
		change_direction(90,-90)
		start_moving_camera()

func _mouse_enter_top_left_corner():
	if !fast_move and !rotating_camera:
		change_direction(-90,-90)
		start_moving_camera()

func _mouse_enter_bottom_right_corner():
	if !fast_move and !rotating_camera:
		change_direction(90,90)
		start_moving_camera()
	
func _mouse_enter_bottom_left_corner():
	if !fast_move and !rotating_camera:
		change_direction(-90,90)
		start_moving_camera()

func _mouse_exit_top():
	if !fast_move and !rotating_camera:
		stop_camera()

func _mouse_exit_bottom():
	if !fast_move and !rotating_camera:
		stop_camera()

func _mouse_exit_left():
	if !fast_move and !rotating_camera:
		stop_camera()

func _mouse_exit_right():
	if !fast_move and !rotating_camera:
		stop_camera()

func _mouse_exit_top_right_corner():
	if !fast_move and !rotating_camera:
		stop_camera()

func _mouse_exit_top_left_corner():
	if !fast_move and !rotating_camera:
		stop_camera()

func _mouse_exit_bottom_right_corner():
	if !fast_move and !rotating_camera:
		stop_camera()
	
func _mouse_exit_bottom_left_corner():
	if !fast_move and !rotating_camera:
		stop_camera()