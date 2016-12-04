extends Position3D

var camera_speed = 0.003
export var camrot = 0.0
export var direction = Vector3()
onready var camera_movement_triggers
onready var ui = get_node("/root/game/UI")

func _ready():
	set_process_input(true)
	direction.y = 0
	camrot = get_rotation().y
	set_rotation(Vector3(0, camrot, 0))
	camera_movement_triggers = ui.get_node("camera_triggers").get_children()
	for trigger in camera_movement_triggers:
		trigger.connect("mouse_enter", self, "mouse_enter_"+trigger.get_name())
		trigger.connect("mouse_exit", self, "mouse_exit_"+trigger.get_name())

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
	camrot += degrees
	set_rotation(Vector3(0, camrot, 0))

func change_direction(x,z):
	direction.x += x
	direction.z += z

func mouse_enter_top():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(0,-90)
		start_moving_camera()

func mouse_enter_bottom():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(0,90)
		start_moving_camera()

func mouse_enter_left():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(-90,0)
		start_moving_camera()

func mouse_enter_right():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(90,0)
		start_moving_camera()

func mouse_enter_top_right():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(90,-90)
		start_moving_camera()

func mouse_enter_top_left():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(-90,-90)
		start_moving_camera()

func mouse_enter_bottom_right():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(90,90)
		start_moving_camera()
	
func mouse_enter_bottom_left():
	if !ui.fast_move and !ui.rotating_camera:
		change_direction(-90,90)
		start_moving_camera()


func mouse_exit_top():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()

func mouse_exit_bottom():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()

func mouse_exit_left():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()

func mouse_exit_right():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()

func mouse_exit_top_right():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()

func mouse_exit_top_left():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()

func mouse_exit_bottom_right():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()
	
func mouse_exit_bottom_left():
	if !ui.fast_move and !ui.rotating_camera:
		stop_camera()