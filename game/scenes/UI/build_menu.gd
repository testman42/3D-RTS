extends Node2D

onready var buildings_grid_scene
onready var units_grid_scene

func _ready():
	buildings_grid_scene = preload("res://game/scenes/UI/buildings_grid.tscn")
	units_grid_scene = preload("res://game/scenes/UI/units_grid.tscn")
	update_build_options()

func update_build_options():
	var cone_count = 0
	var gear_count = 0
	# I couldn't think of a way to check current buildings and check for multiple-building requirements in one loop
	# therefore this  list
	var requirements = ["","","","",""] # [cc, rr, tt, gg, oo]
	
	# current state check
	var current_buildings = get_tree().get_nodes_in_group("buildings")
	for building in current_buildings:
		var name = building.get_name()
		if "cone_of_construction" in name:
			requirements[0] = "cc"
			cone_count += 1
		if "rectangular_reactor" in name:
			requirements[1] = "rr"
		if "tetrahedron_of_transmutation" in name:
			requirements[2] = "tt"
		if "gear_of_generating" in name:
			requirements[3] = "gg"
			gear_count += 1
		if "orb_of_observation" in name:
			requirements[4] = "oo"


	var buildings_tab = TabContainer.new()
	buildings_tab.set_name("Buildings")
	for i in range(cone_count):
		var number_tab = GridContainer.new()
		number_tab.set_name(str(i+1))
		var buildings_grid = buildings_grid_scene.instance()
		number_tab.add_child(buildings_grid)
		buildings_tab.add_child(number_tab)
	
		for child in buildings_grid.get_children():
			child.connect("pressed", self, "on_"+child.get_name()+"_pressed")

		# building hierarchy
		if requirements[0] == "cc":
			buildings_grid.get_node("rr").show()
			if requirements[1] == "rr":
				buildings_grid.get_node("tt").show()
				buildings_grid.get_node("gg").show()
			if requirements[1] == "rr" and requirements[2] == "tt" and requirements[3] == "gg":
				buildings_grid.get_node("oo").show()
			if requirements[4] == "oo":
				buildings_grid.get_node("cc").show()
	
	
	var units_tab = TabContainer.new()
	units_tab.set_name("Units")
	for i in range(gear_count):
		var number_tab = GridContainer.new()
		number_tab.set_name(str(i+1))
		var units_grid = units_grid_scene.instance()
		number_tab.add_child(units_grid)
		units_tab.add_child(number_tab)
		
		for child in units_grid.get_children():
			child.connect("pressed", self, "on_"+child.get_name()+"_pressed")
	
		#units hierarchy
		if requirements[3] == "gg":
			units_grid.get_node("collector").show()
			units_grid.get_node("basic_tank").show()
		if requirements[4] == "oo":
			units_grid.get_node("big_tank").show()
			#units_grid.get_node("gfm").show()
	
	var current_tabs = get_node("type_select").get_children()
	for child in current_tabs:
		get_node("type_select").remove_child(child)
	
	if requirements[0] == "cc":
		get_node("type_select").add_child(buildings_tab)
	if requirements[3] == "gg":
		get_node("type_select").add_child(units_tab)
	


func on_rr_pressed():
	get_node("/root/game").start_placing_building("res://game/scenes/actors/constructions/rectangular_reactor.tscn")
	
func on_tt_pressed():
	get_node("/root/game").start_placing_building("res://game/scenes/actors/constructions/tetrahedron_of_transmutation.tscn")
	
func on_gg_pressed():
	get_node("/root/game").start_placing_building("res://game/scenes/actors/constructions/gear_of_generating.tscn")

func on_cc_pressed():
	get_node("/root/game").start_placing_building("res://game/scenes/actors/constructions/cone_of_construction.tscn")
	
func on_oo_pressed():
	get_node("/root/game").start_placing_building("res://game/scenes/actors/constructions/orb_of_observation.tscn")
	
func on_collector_pressed():
	get_node("/root/game").spawn_unit("res://game/scenes/actors/units/collector.tscn")
	
func on_basic_tank_pressed():
	get_node("/root/game").spawn_unit("res://game/scenes/actors/units/basic_tank.tscn")
	
func on_big_tank_pressed():
	get_node("/root/game").spawn_unit("res://game/scenes/actors/units/big_tank.tscn")