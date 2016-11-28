extends Position3D

var camera_speed = 0.003
var fast_move = 0
var rotating_camera = 0
var selecting_start = Vector2(0,0)
onready var camrot = 0.0
onready var camera_movement_triggers
onready var direction = Vector3()
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


func _input(event):
	if rotating_camera and event.type == InputEvent.MOUSE_MOTION:
		camrot += event.relative_x*0.005
		set_rotation(Vector3(0, camrot, 0))
		
	if fast_move and event.type == InputEvent.MOUSE_MOTION:
			direction.x += event.relative_x
			direction.z += event.relative_y
	

	if (event.is_action_pressed("select")) and !game.placing_building:
		selecting_start = event.pos
	if selecting_start.x > 0:
		game.get_node("UI").draw_rect(selecting_start, event.pos)
		if event.is_action_released("select"):
			var camera = game.get_node("world/camera/Camera")
			game.get_node("UI").hide_rect()
			for unit in game.get_node("world/actors/units").get_children():
				var loc_on_screen = camera.unproject_position(unit.get_translation())
				var x = loc_on_screen.x
				var y = loc_on_screen.y
				if selecting_start.distance_to(event.pos) < 3:
					if loc_on_screen.distance_to(event.pos) < 20:
						unit.select()
				elif ( (selecting_start.x > x and x > event.pos.x) or (selecting_start.x < x and x < event.pos.x )):
					#y check in new line for code readablity
					if ( ( selecting_start.y > y and y > event.pos.y) or (selecting_start.y < y and y < event.pos.y )):
						unit.select()
						game.just_selected = 1
			selecting_start = Vector2(0,0)
			
			
	if event.is_action_pressed("camera_rotate"):
		rotating_camera = 1
	if event.is_action_released("camera_rotate"):
		rotating_camera = 0
		
	if event.is_action_pressed("camera_fast_move"):
		fast_move = 1
		start_moving_camera()
	if event.is_action_released("camera_fast_move"):
		fast_move = 0
		stop_camera()
		


func start_moving_camera():
	set_process(true)

func move_camera():
	translate(direction*camera_speed)
	
func stop_camera():
	direction.x = 0
	direction.z = 0
	set_process(false)

func mouse_enter_top():
	if !fast_move and !rotating_camera:
		direction.z = -90
		start_moving_camera()

func mouse_enter_bottom():
	if !fast_move and !rotating_camera:
		direction.z = 90
		start_moving_camera()

func mouse_enter_left():
	if !fast_move and !rotating_camera:
		direction.x = -90
		start_moving_camera()

func mouse_enter_right():
	if !fast_move and !rotating_camera:
		direction.x = 90
		start_moving_camera()

func mouse_enter_top_right():
	if !fast_move and !rotating_camera:
		direction.x = 90
		direction.z = -90
		start_moving_camera()

func mouse_enter_top_left():
	if !fast_move and !rotating_camera:
		direction.x = -90
		direction.z = -90
		start_moving_camera()

func mouse_enter_bottom_right():
	if !fast_move and !rotating_camera:
		direction.x = 90
		direction.z = 90
		start_moving_camera()
	
func mouse_enter_bottom_left():
	if !fast_move and !rotating_camera:
		direction.x = -90
		direction.z = 90
		start_moving_camera()


func mouse_exit_top():
	if !fast_move and !rotating_camera:
		stop_camera()

func mouse_exit_bottom():
	if !fast_move and !rotating_camera:
		stop_camera()

func mouse_exit_left():
	if !fast_move and !rotating_camera:
		stop_camera()

func mouse_exit_right():
	if !fast_move and !rotating_camera:
		stop_camera()

func mouse_exit_top_right():
	if !fast_move and !rotating_camera:
		stop_camera()

func mouse_exit_top_left():
	if !fast_move and !rotating_camera:
		stop_camera()

func mouse_exit_bottom_right():
	if !fast_move and !rotating_camera:
		stop_camera()
	
func mouse_exit_bottom_left():
	if !fast_move and !rotating_camera:
		stop_camera()