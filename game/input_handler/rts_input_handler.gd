extends Node

# TODO: terminology - is it "building" or "construction"?
# TODO: split the deterministic RTS logic into it's own "engine"
# NOPE: implement "selection boxes", so that unit selection won't rely on workarounds
# TODO: most of the state logic here is horribly messed up, figure out cleaner implementaiton

var enabled = false
var camera
var camera_anchor
var rts_logic
var rts_hud

var camera_fast_move = false
var rotating_camera = false
var placing_building = false
var drawing_selection_rectangle = false
var left_click_position
var right_click_position

var temp_hovered_object


#enum {nothing_selected, placing_construction, units_selected, construction_selected}
#var current_state = 0

func _ready():
	# TODO: figure out how to elegantly de-hardcode this
	camera_anchor = get_tree().get_first_node_in_group("rts_camera")
	camera = $"../../world/cameras/rts_camera/camera"
	rts_logic = $"../../game_logic/rts"
	rts_hud = $"../../interface/rts_hud"
	var build_menu = $"../../interface/rts_hud/build_menu"
	build_menu.button_pressed.connect(self._button_pressed)

# TODO: figure out how set_process_input() should be used instead
func enable():
	enabled = true

func disable():
	enabled = false

#func _input(event):
func _unhandled_input(event):
	if enabled:
		if event.is_action_pressed("camera_fast_move"):
			camera_fast_move = true
			camera_anchor.start_moving()
		
		if event.is_action_released("camera_fast_move"):
			camera_fast_move = false
			camera_anchor.stop_moving()
		
		if event.is_action_pressed("rotate_camera"):
			rotating_camera = true
			
		if event.is_action_released("rotate_camera"):
			rotating_camera = false

		if event.is_action_pressed("left_mouse_click"):
			left_click_position = event.position
#			select_object_at_screen_position(event.position)
			if placing_building:
				var click = get_projected_coordinates(event.position)
				rts_logic.confirm_building_placement(click)
				stop_placing_building()
		
		if event.is_action_released("left_mouse_click"):
			left_click_position = null
			if drawing_selection_rectangle:
				rts_hud.stop_drawing_selection_rectangle()
				drawing_selection_rectangle = false
			else:
#				if rts_logic.selected_units and not placing_building:
				if not placing_building:
					var test = rts_logic.attempt_getting_unit(camera_anchor.get_ray_collider())
					if test.is_in_group("units"):
						match rts_logic.get_action(1, test):
							"select":
								rts_logic.clear_unit_selection()
								rts_logic.add_to_selected_units(test)
							"attack":
								rts_logic.selected_units_attack(test)
					else:
						rts_logic.move_selected_units_to_location(get_projected_coordinates(event.position))

		if event is InputEventMouseMotion:
#			if click_position and event.position.distance_to(click_position) > 0.1:
			camera_anchor.set_hover_ray_direction(event.position)
			if left_click_position:
				if event.position.distance_to(left_click_position) > 10:
					rts_hud.start_drawing_selection_rectangle(left_click_position)
					drawing_selection_rectangle = true
			if rotating_camera:
				camera_anchor.rotate_camera(event.relative.x*0.005)
			if camera_fast_move:
				camera_anchor.change_movement_vector(event.relative.x, event.relative.y)
			if placing_building:
				rts_logic.move_preview_mesh(get_projected_coordinates(event.position))
			if drawing_selection_rectangle:
				rts_hud.update_rectangle_end_location(event.position)
			
			# TODO change cursor to attack only if some units are already selected
			var test1 = rts_logic.attempt_getting_unit(camera_anchor.get_ray_collider())
			if is_instance_valid(test1) and not placing_building and not drawing_selection_rectangle:
				if test1.is_in_group("units"):
					rts_hud.show_object_healthbar(test1)
					if temp_hovered_object != test1:
						rts_hud.hide_object_healthbar(temp_hovered_object)
						temp_hovered_object = test1
					if rts_logic.selected_units.size() > 0:
						rts_hud.change_cursor(rts_logic.get_action(1, test1))
				else:
					if not temp_hovered_object in rts_logic.selected_units:
						rts_hud.hide_object_healthbar(temp_hovered_object)
		
		if event.is_action_pressed("right_mouse_click"):
			right_click_position = event.position
		
		if event.is_action_released("right_mouse_click"):
			if event.position.distance_to(right_click_position) < 5:
				rts_logic.clear_unit_selection()
		
		if event.is_action_pressed("test"):
			rts_logic.fire_test()

# translate mouseclick to worldspace coordinates
func get_projected_coordinates(position_on_camera):
	var camera_ray_origin = camera.project_ray_origin(position_on_camera)
	var camera_far_projection = camera_ray_origin + camera.project_ray_normal(position_on_camera)*100
	var map = NavigationServer3D.get_maps()[0]
	var point = NavigationServer3D.map_get_closest_point_to_segment(map, camera_ray_origin, camera_far_projection)
	return point

func start_placing_building(value):
	rts_logic.clear_unit_selection()
	if 	rts_logic.attemt_building_production(1, value):
		placing_building = true

func stop_placing_building():
	placing_building = false

#func select_object_at_screen_position(position):
#	var object = camera_anchor.get_object_at_ray(position)
	
func _button_pressed(type, value):
	match type:
		1:
			start_placing_building(value)
		2:
			rts_logic.start_producing_unit(value)
