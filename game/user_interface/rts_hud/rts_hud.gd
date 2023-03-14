extends Node2D

# TODO: Does it make more sense to have menus pre-built or to construct them by script?
#func _ready():
#	pass

var cursors = {}

func _ready():
	var select_cursor = load("res://game/resources/images/mouse_cursors/select.png")
	var attack_cursor = load("res://game/resources/images/mouse_cursors/attack.png")
	cursors["select"] = select_cursor
	cursors["attack"] = attack_cursor
#	for cursor in cursors:
#		cursors[cursor].size.x = 50
#		cursors[cursor].size.y = 50

func update_build_options(new_structure):
	# TODO: figure out a way to change build menu contents without nuking and paving each time
#	$build_menu.remove_all_grids()
	for category in new_structure:
#		for i in range(new_structure[category].size()):
		if $build_menu.get_category_node(category).get_child_count() == 0:
			$build_menu.add_new_grid_to_category(category)
		$build_menu.change_button_visibility_in_grid(category, 0, new_structure[category])

func start_drawing_selection_rectangle(coordinates):
	$selection_rectangle.set_origin(coordinates)
	$selection_rectangle.start_drawing()

func stop_drawing_selection_rectangle():
	$selection_rectangle.stop_drawing()

func update_rectangle_end_location(coordinates):
	$selection_rectangle.set_rectangle_end(coordinates)

func register_new_object(object):
	$unit_healthbars.add_object(object) 

func show_object_healthbar(object):
	$unit_healthbars.show_object_healthbar(object) 

func hide_object_healthbar(object):
	$unit_healthbars.hide_object_healthbar(object) 

func delete_object_healthbar(object):
	$unit_healthbars.remove_object_healthbar(object)

# TODO: Figure out how to make sure that position is in sync with unit on every frame
func update_object_onscreen_coordinates(object, coordinates):
	$unit_healthbars.update_object_coordinates(object, coordinates)

func set_resource_count_value(value):
	$resource_count.set_value(value)

# This would have gone into rts_hud, but Godot deals with this through Input
func change_cursor(mode):
	if mode in cursors.keys():
		Input.set_custom_mouse_cursor(cursors[mode],1,Vector2(25,25))
	else:
		Input.set_custom_mouse_cursor(null)
