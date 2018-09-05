# This script is meant to be used to interpret player input

extends Node

# input handling should be handled so that it firstly checks if input was meant for HUD.
# if not, then relay input to game.
var placing_building = 0
var just_selected = 0
var rotating_building = 0
var building_node

# temporary variable for building placement
var building_location
var can_build = 0
var fast_move_start = Vector2()
var selecting_start = Vector2(0,0)
export var fast_move = 0
export var rotating_camera = 0
#onready var game = get_node("/root/game")
onready var camera_anchor = get_node("/root/game/game_world/camera_anchor")

func _ready():
	set_process_input(true)
	
func _input(event):
	# UI functionality
	if event.is_action("focus_home"):
		focus_on_home()
		
	if event.is_action_pressed("camera_rotate"):
		rotating_camera = 1
		camera_anchor.start_moving_camera()
		
	if event.is_action_released("camera_rotate"):
		rotating_camera = 0
		camera_anchor.stop_camera()
		
	if event.is_action_pressed("camera_fast_move"):
		fast_move = 1
		fast_move_start = event.position
		camera_anchor.start_moving_camera()
		
	if event.is_action_released("camera_fast_move"):
		fast_move = 0
		camera_anchor.stop_camera()
		
	if rotating_camera and event is InputEventMouseMotion:
		camera_anchor.rotate_camera(event.relative.x*0.005)
		
	if fast_move and event is InputEventMouseMotion:
		camera_anchor.change_direction(event.relative.x, event.relative.y)
	
	# construction placement 
	if placing_building and event.is_action_pressed("confirm_placement"):
		if !building_location and can_build:
			building_location = mouse2coords(event)
			placing_building = 0
			rotating_building = 1
		
	if rotating_building and event is InputEventMouseMotion:
		#GODOT2: causes irrelevant error because of one pixel
		building_node.look_at(mouse2coords(event), Vector3(0,1,0))
		
	if rotating_building and event.is_action_released("confirm_placement"):
		#building_node.add_to_group("")
		building_node.add_to_group("buildings")
		get_node("/root/game/UI/HUD/construction_menu").update_build_options()
		building_node.place()
		placing_building = 0
		rotating_building = 0
		building_location = 0
		
	if placing_building and event.is_action("cancel_placement"):
		cancel_building_placement()
		placing_building = 0
		rotating_building = 0
	
	if placing_building and event is InputEventMouseMotion:
		building_node.set_translation(mouse2coords(event))
		can_build = building_node.check_build_area()
		
	# unit selection handling
	var selected_group = get_tree().get_nodes_in_group("selected")
	if  selected_group.size() > 0 and event.is_action("order") and !just_selected:
		get_node("../main_loop").move_units_group_to(selected_group, mouse2coords(event))
	just_selected = 0
	
	if event.is_action_released("cancel_selection"):
		# To check if right click was just in one place (well, 3 pixel tolerance),
		# so that we don't deselect units if player wanted to just move camera
		if fast_move_start.distance_to(event.position) < 3:
			deselect_all_selected_units()
#
	if (event.is_action_pressed("select")) and !rotating_building and !placing_building:
		selecting_start = event.position
		
	if selecting_start.x > 0:
		get_node("/root/game/UI/HUD").draw_rectangle(selecting_start, event.position)
		if event.is_action_released("select"):
			if selecting_start.distance_to(event.position) > 3:
				var camera = camera_anchor.get_node("camera")
				for unit in get_node("/root/game/game_world/actors/units").get_children():
					var loc_on_screen = camera.unproject_position(unit.get_translation())
					if loc_on_screen.distance_to(event.position) < 20:
						unit.select()
					if is_point_in_rectangle(loc_on_screen, selecting_start, event.position):
						unit.select()
						#unit.show_destination_line(1)
						just_selected = 1
			selecting_start = Vector2(0,0)
			get_node("/root/game/UI/HUD").hide_rectangle()
		
func mouse2coords(event):
	var near = camera_anchor.get_node("camera").project_ray_origin(event.position)
	var far = near + camera_anchor.get_node("camera").project_ray_normal(event.position)*100
	var point = get_node("/root/game/game_world/environment/map/navigation").get_closest_point_to_segment(near, far)
	return point
	
func is_point_in_rectangle(point, rect_start, rect_end):
	var x = point.x
	var y = point.y
	if ( (rect_start.x > x and x > rect_end.x) or (rect_start.x  < x and x < rect_end.x )):
		if ( ( rect_start.y > y and y > rect_end.y) or (rect_start.y < y and y < rect_end.y )):
			return true
	return false

func focus_on_home():
	#already placed Cone of Construction is our home for now
	#should have group named "home" that includes only one node and focus on that node
	var home_location = get_node("/root/game/game_world/actors/constructions/cone_of_construction").get_translation()
	get_node("../game_world/camera_anchor").set_translation(home_location)

func deselect_all_selected_units():
	for unit in get_tree().get_nodes_in_group("selected"):
		unit.deselect()
		
func cancel_building_placement():
	building_node.free()