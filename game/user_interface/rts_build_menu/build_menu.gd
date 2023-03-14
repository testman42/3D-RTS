extends Control

signal button_pressed(type, value)

var current_structure
var button_scene

# TODO: having building scene encoded into button is bad. Set up more proper mapping.
func _ready():
	button_scene = preload("res://game/user_interface/rts_build_menu/button.tscn")

func get_category_node(category):
	match category:
		"buildings":
			return $menu/Buildings
		"units":
			return $menu/Units
		"stuff":
			return $menu/Stuff

func change_button_visibility_in_grid(category, grid_index, button_list):
	get_category_node(category).get_child(grid_index).change_button_visibility(button_list)

func change_button_visibility_in_all_grids(category, button_list):
	for grid in get_category_node(category).get_children():
		grid.change_button_visibility(button_list)

func add_new_grid_to_category(category):
	var newgrid_scene
	match category:
		"buildings":
			newgrid_scene = preload("res://game/user_interface/rts_build_menu/constructions_grid.tscn")
		"units":
			newgrid_scene = preload("res://game/user_interface/rts_build_menu/units_grid.tscn")
#		"vehicles":
#			passnew_structure[category].size()
	var newgrid = newgrid_scene.instantiate()
	var category_node = get_category_node(category)
	newgrid.name = str(category_node.get_child_count()+1)
	for button in newgrid.get_children():
		button.pressed.connect(_on_pressed.bind(button))
	category_node.add_child(newgrid)

func remove_grid_from_category(category, grid_index):
	get_category_node(category).get_child(grid_index).queue_free()

func remove_all_grids():
	for category_node in $menu.get_children():
		for grid in category_node.get_children():
			#grid.queue_free()
			grid.free()
			
func _on_pressed(button):
	button_pressed.emit(button.button_type, button.object_name)


















## TODO: name better
#func set_up_grid(gridname, list):
#	var grid = GridContainer.new()
#	grid.name = gridname
#	grid.set_columns(3)
#	for item in list:
#		var button = button_scene.instantiate()
#		button.text = item
#		button.building_scene = int(item)
#		grid.add_child(button)
#
#	for button in grid.get_children():
#		button.pressed.connect(_on_pressed.bind(button))
#	$menu/Buildings.add_child(grid)

# TODO: figure out a better way than using a massive dictionary
# but then again, going binary encoding UNIX permissions way is too complex
# current structure:
# structure = {
# buildings = [["rr","gg"], ["rr"]],
# }

#func update_options(structure):
#	for key in structure:
#		var grids = get_grids(key)
#		for i in range(structure[key].size()):
#			print(i, grids.size())
#			if i < grids.size():
#				grids[i].change_button_visibility(structure[key][i])
#			else:
#				set_up_new_grid(key, i+1, structure[key][i])
#	current_structure = structure

#func set_up_new_grid(category, gridname, list):
#	var newgrid_scene = preload("res://game/user_interface/rts_build_menu/constructions_grid.tscn")
#	var newgrid = newgrid_scene.instantiate()
#	newgrid.change_button_visibility(list)
#	newgrid.name = str(gridname)
#	for button in newgrid.get_children():
#		button.pressed.connect(_on_pressed.bind(button))
#	#gridtracker[category].append(newgrid.name)
#	match category:
#		"buildings":
#			$menu/Buildings.add_child(newgrid)
#		"vehicles":
#			$menu/Vehicles.add_child(newgrid)
#		"stuff":
#			$menu/Stuff.add_child(newgrid)

#func change_grid(category, index, names):
#	var grids = get_grids(category)
#	for grid in grids:
#		pass
#
#func get_grid_count(category):
#	pass
#
#func get_grids(category):
#	match category:
#		"buildings":
#			return $menu/Buildings.get_children()
#		"vehicles":
#			return $menu/Vehicles.get_children()
#		"stuff":
#			return $menu/Stuff.get_children()


