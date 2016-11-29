extends Position3D

var camera_speed = 0.003
var rotation_changed = 0
export var camrot = 0.0
export var direction = Vector3()
onready var camera_movement_triggers
onready var game = get_node("/root/game/")

func _ready():
	set_process_input(true)
	direction.y = 0
	camrot = get_rotation().y
	set_rotation(Vector3(0, camrot, 0))
	camera_movement_triggers = game.get_node("UI/HUD/camera_triggers").get_children()
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
	if rotation_changed:
		rotate_camera()
		rotation_changed = 0
	
func rotate_camera():
	set_rotation(Vector3(0, camrot, 0))


func mouse_enter_top():
	if !game.fast_move and !game.rotating_camera:
		direction.z = -90
		start_moving_camera()

func mouse_enter_bottom():
	if !game.fast_move and !game.rotating_camera:
		direction.z = 90
		start_moving_camera()

func mouse_enter_left():
	if !game.fast_move and !game.rotating_camera:
		direction.x = -90
		start_moving_camera()

func mouse_enter_right():
	if !game.fast_move and !game.rotating_camera:
		direction.x = 90
		start_moving_camera()

func mouse_enter_top_right():
	if !game.fast_move and !game.rotating_camera:
		direction.x = 90
		direction.z = -90
		start_moving_camera()

func mouse_enter_top_left():
	if !game.fast_move and !game.rotating_camera:
		direction.x = -90
		direction.z = -90
		start_moving_camera()

func mouse_enter_bottom_right():
	if !game.fast_move and !game.rotating_camera:
		direction.x = 90
		direction.z = 90
		start_moving_camera()
	
func mouse_enter_bottom_left():
	if !game.fast_move and !game.rotating_camera:
		direction.x = -90
		direction.z = 90
		start_moving_camera()


func mouse_exit_top():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()

func mouse_exit_bottom():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()

func mouse_exit_left():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()

func mouse_exit_right():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()

func mouse_exit_top_right():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()

func mouse_exit_top_left():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()

func mouse_exit_bottom_right():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()
	
func mouse_exit_bottom_left():
	if !game.fast_move and !game.rotating_camera:
		stop_camera()