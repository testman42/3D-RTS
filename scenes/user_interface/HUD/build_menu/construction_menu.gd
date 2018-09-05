extends Control

onready var buildings_grid_scene
onready var units_grid_scene
onready var build_info
onready var game_main_loop

func _ready():
	buildings_grid_scene = preload("res://scenes/user_interface/HUD/build_menu/buildings_grid.tscn")
	units_grid_scene = preload("res://scenes/user_interface/HUD/build_menu/units_grid.tscn")
	build_info = get_node("build_info")
	game_main_loop = get_node("/root/game/main_loop")
	update_build_options()

func update_build_options():
	var cone_count = 0
	var gear_count = 0
	# I couldn't think of a way to check current buildings and check for multiple-building requirements in one loop
	# therefore this list
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
		connect_signals(buildings_grid)

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
		connect_signals(units_grid)
	
		#units hierarchy
		if requirements[3] == "gg":
			units_grid.get_node("collector").show()
			units_grid.get_node("basic_tank").show()
		if requirements[4] == "oo":
			units_grid.get_node("serious_tank").show()
			#units_grid.get_node("gfm").show()
	
	var current_tabs = get_node("type_select").get_children()
	for child in current_tabs:
		get_node("type_select").remove_child(child)
	
	if requirements[0] == "cc":
		get_node("type_select").add_child(buildings_tab)
	if requirements[3] == "gg":
		get_node("type_select").add_child(units_tab)

#lol this needs better variable names
func connect_signals(node):
	for child in node.get_children():
		child.connect("pressed", self, "_on_"+child.get_name()+"_pressed")
		child.connect("mouse_entered", self, "_on_"+child.get_name()+"_mouse_enter")
		child.connect("mouse_exited", self, "_on_"+child.get_name()+"_mouse_exit")


# this need de-spaghettifying
func _on_rr_pressed():
	game_main_loop.start_placing_building("res://scenes/actors/constructions/rectangular_reactor/rectangular_reactor.tscn")
	
func _on_tt_pressed():
	game_main_loop.start_placing_building("res://scenes/actors/constructions/tetrahedron_of_transmutation/tetrahedron_of_transmutation.tscn")
	
func _on_gg_pressed():
	game_main_loop.start_placing_building("res://scenes/actors/constructions/gear_of_generating/gear_of_generating.tscn")

func _on_cc_pressed():
	game_main_loop.start_placing_building("res://scenes/actors/constructions/cone_of_construction/cone_of_construction.tscn")
	
func _on_oo_pressed():
	game_main_loop.start_placing_building("res://scenes/actors/constructions/orb_of_observation/orb_of_observation.tscn")
	
func _on_collector_pressed():
	game_main_loop.spawn_unit("res://game/scenes/actors/units/collector/collector.tscn")
	
func _on_basic_tank_pressed():
	game_main_loop.spawn_unit("res://scenes/actors/units/basic_tank/basic_tank.tscn")

# possible other fun names:
# behemoth tank
# giant tank
# colossus tank
# goliath tank
func _on_serious_tank_pressed():
	game_main_loop.spawn_unit("res://scenes/actors/units/serious_tank/serious_tank.tscn")
	
# giant mech could also be "cyclops"

# idea for naval unit: titanic
# autonomus battleship that when damaged to 30% health splits in two parts that act as big torpedoes
	

#HALP PLS: how do we make this more elegant instead of repeating the function for each button?
func _on_rr_mouse_enter():
	build_info.set_text("Rectangual Reactor")

func _on_tt_mouse_enter():
	build_info.set_text("Tetrahedron of transmutation")

func _on_gg_mouse_enter():
	build_info.set_text("Gear of generating")

func _on_cc_mouse_enter():
	build_info.set_text("Cone of construction")

func _on_oo_mouse_enter():
	build_info.set_text("Orb of observation")

func _on_collector_mouse_enter():
	build_info.set_text("Collector")
	
func _on_basic_tank_mouse_enter():
	build_info.set_text("Basic Tank")
	
func _on_serious_tank_mouse_enter():
	build_info.set_text("Serious Tank")


func _on_rr_mouse_exit():
	build_info.set_text("")

func _on_tt_mouse_exit():
	build_info.set_text("")

func _on_gg_mouse_exit():
	build_info.set_text("")

func _on_cc_mouse_exit():
	build_info.set_text("")

func _on_oo_mouse_exit():
	build_info.set_text("")

func _on_collector_mouse_exit():
	build_info.set_text("")
	
func _on_basic_tank_mouse_exit():
	build_info.set_text("")
	
func _on_serious_tank_mouse_exit():
	build_info.set_text("")
	

