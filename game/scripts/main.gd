extends Node

export var placing_building = 0
export var just_selected = 0
export var fast_move = 0
export var rotating_camera = 0
var rotating_building = 0
var building_node
var building_location
var selecting_start = Vector2(0,0)
onready var camera_base = get_node("/root/game/world/camera")

func _ready():
	set_process_input(true)

func _input(event):
	var selected_group = get_tree().get_nodes_in_group("selected")
	if  selected_group.size() > 0 and event.is_action("order") and !just_selected:
		move_units_group_to(selected_group, mouse2coords(event))
	just_selected = 0
			
	if placing_building:
		building_node.set_translation(mouse2coords(event))
		
	if placing_building and event.is_action_pressed("confirm_placement"):
		if !building_location:
			building_location = mouse2coords(event)
		placing_building = 0
		rotating_building = 1
		
	if rotating_building and event.type==InputEvent.MOUSE_MOTION:
		#causes irrelevant error bceuse one pixel
		building_node.look_at(mouse2coords(event), Vector3(0,1,0))
		
	if rotating_building and event.is_action_released("confirm_placement"):
		building_node.add_to_group("buildings")
		get_node("UI/HUD/build_menu").update_build_options()
		if "tetrahedron_of_transmutation" in building_node.get_name():
			building_node.spawn_collector()
		placing_building = 0
		rotating_building = 0
		building_location = 0
		
	if placing_building and event.is_action("cancel_placement"):
		cancel_building_placement()
		
	if event.is_action("cancel_selection"):
		deselect_all_selected_units()
		
	if event.is_action("focus_home"):
		focus_on_home()
		
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
		camera_base.camrot += event.relative_x*0.005
		camera_base.rotation_changed = 1
		
	if fast_move and event.type == InputEvent.MOUSE_MOTION:
			camera_base.direction.x += event.relative_x
			camera_base.direction.z += event.relative_y
			
	if (event.is_action_pressed("select")) and !rotating_building:
		selecting_start = event.pos
	if selecting_start.x > 0:
		get_node("UI").draw_rect(selecting_start, event.pos)
		if event.is_action_released("select"):
			var camera = camera_base.get_node("Camera")
			get_node("UI").hide_rect()
			for unit in get_node("world/actors/units").get_children():
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
						just_selected = 1
			selecting_start = Vector2(0,0)
		
func mouse2coords(event):
	var near = camera_base.get_node("Camera").project_ray_origin(event.pos)
	var far = near + camera_base.get_node("Camera").project_ray_normal(event.pos)*100
	var click = get_node("world/terrain/map/navigation").get_closest_point_to_segment(near, far)
	return click
	
func start_placing_building(building_nodepath):
	placing_building = 1
	var node = load(building_nodepath)
	building_node = node.instance()
	# could I just load(building_nodepath).instance() ?
	building_node.set_translation(Vector3(0,-9001,0))
	get_node("world/actors/constructions").add_child(building_node)
	get_node("UI").hide_rect()

func cancel_building_placement():
	get_node("world/actors/constructions").remove_child(building_node)
	placing_building = 0
	rotating_building = 0
	
func move_units_group_to(group, coordinates):
		for unit in group:
			unit.move(coordinates)

func deselect_all_selected_units():
	for unit in get_tree().get_nodes_in_group("selected"):
		unit.deselect()

func focus_on_home():
	#already placed Cone of Construction is our home for now
	var home_location = get_node("world/actors/constructions/cone_of_construction").get_translation()
	get_node("world/camera").set_translation(home_location)
	
func spawn_unit(nodepath, location = 0):
	var unit_scene = load(nodepath)
	var unit = unit_scene.instance()
	get_node("world/actors/units").add_child(unit)
	unit.add_to_group("units")
	if typeof(location) == TYPE_VECTOR3 :
		unit.set_translation(location)
	else:
		unit.set_translation(get_node("/root/game/world/actors/constructions/gear_of_generating").get_translation())
	