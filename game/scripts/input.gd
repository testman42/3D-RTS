extends Node

# input handling should be handled so that it firstly checks if input was meant for HUD.
# if not, then relay input to game.
export var placing_building = 0
export var just_selected = 0
export var fast_move = 0
export var rotating_camera = 0
var rotating_building = 0
var building_node
var building_location
var selecting_start = Vector2(0,0)
var current_state = ""
onready var game = get_node("/root/game")
onready var camera_base = get_node("/root/game/world/camera")

func _ready():
	set_process_input(true)
	
func _input(event):
	#construction placement 
	if placing_building:
		game.building_node.set_translation(mouse2coords(event))
		
	if placing_building and event.is_action_pressed("confirm_placement"):
		if !building_location:
			building_location = mouse2coords(event)
		placing_building = 0
		rotating_building = 1
		
	if rotating_building and event.type==InputEvent.MOUSE_MOTION:
		#causes irrelevant error bceuse of one pixel
		game.building_node.look_at(mouse2coords(event), Vector3(0,1,0))
		
	if rotating_building and event.is_action_released("confirm_placement"):
		game.building_node.add_to_group("buildings")
		game.get_node("UI/HUD/build_menu").update_build_options()
		if "tetrahedron_of_transmutation" in game.building_node.get_name():
			game.building_node.spawn_collector()
		placing_building = 0
		rotating_building = 0
		building_location = 0
		
	if placing_building and event.is_action("cancel_placement"):
		cancel_building_placement()
		
	#UI functionality
	if event.is_action("focus_home"):
		game.focus_on_home()
		
	if event.is_action_pressed("camera_rotate"):
		rotating_camera = 1
		camera_base.start_moving_camera()
	if event.is_action_released("camera_rotate"):
		rotating_camera = 0
		camera_base.stop_camera()
		
	if event.is_action_pressed("camera_fast_move"):
		fast_move = 1
		camera_base.start_moving_camera()
		
	if event.is_action_released("camera_fast_move"):
		fast_move = 0
		camera_base.stop_camera()
		
	if rotating_camera and event.type == InputEvent.MOUSE_MOTION:
		camera_base.rotate_camera(event.relative_x*0.005)
		
	if fast_move and event.type == InputEvent.MOUSE_MOTION:
		camera_base.change_direction(event.relative_x, event.relative_y)
	
	#unit selection handling
	var selected_group = get_tree().get_nodes_in_group("selected")
	if  selected_group.size() > 0 and event.is_action("order") and !just_selected:
		game.move_units_group_to(selected_group, mouse2coords(event))
	just_selected = 0
	
	if event.is_action("cancel_selection"):
		game.deselect_all_selected_units()
	
	if (event.is_action_pressed("select")) and !rotating_building:
		selecting_start = event.pos
	if selecting_start.x > 0:
		game.get_node("UI/HUD").draw_rect(selecting_start, event.pos)
		if event.is_action_released("select"):
			var camera = camera_base.get_node("Camera")
			game.get_node("UI/HUD").hide_rect()
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
						unit.show_destination_line(1)
						just_selected = 1
			selecting_start = Vector2(0,0)
		
func mouse2coords(event):
	var near = camera_base.get_node("Camera").project_ray_origin(event.pos)
	var far = near + camera_base.get_node("Camera").project_ray_normal(event.pos)*100
	var click = game.get_node("world/terrain/map/navigation").get_closest_point_to_segment(near, far)
	return click