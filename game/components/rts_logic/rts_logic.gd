extends Node

# TODO: long term big goal: split RTS logic into deterministic core layer
# and presentation layer
# TODO: many things in this project are insane level of bad
# do put some work into re-working these systems into something more decent

# TODO: Terminoligy, is it "buidling" or "construction"
# TODO: rewrite logic in a way that can handle more than one player
# TODO: set up enumerations for constructions and units

var construction_scenes = {}
var construction_previews = {}
var unit_scenes = {}
var building_being_placed # variable that tracks the index of building
var building_being_placed_shortname
var building_preview_scene # scene that shows preview
var rts_camera
var rts_hud
var starting_positions
var construction_cost = {}


var starting_resources = 100
var current_player_id = 1

# TODO: implement proper logic for this
var temp_unit_spawn_locations = []

var selected_units = []

var player_colours = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rts_hud = $"../../interface/rts_hud"
	rts_camera = $"../../world/cameras/rts_camera"
	starting_positions = $"../../world/environment/starting_positions".get_children()
	populate_construction_options()
	define_construction_cost()
	$construction_logic.initialise_player_construction_trackers(2,construction_scenes.keys())
	update_current_constructions_list()
	call_deferred("setup_navserver")
	# just because of PEP8 lines
	var r = $"../../interface/rts_hud/selection_rectangle"
	r.finished_selecting.connect(select_units_within_rectangle)
	
	start_match(null) # match_properties argument is placeholder for now


func _process(delta):
#	for unit in selected_units:
	for unit in get_tree().get_nodes_in_group("units"):
		var onscreen_coordinates = rts_camera.return_object_onscreen_coordinates(unit)
		rts_hud.update_object_onscreen_coordinates(unit, onscreen_coordinates)

# code stolen from https://godotengine.org/asset-library/asset/124 lol
# TODO: move all of this to a more appropriate place
func setup_navserver():
	var map = NavigationServer3D.get_maps()[0]
	NavigationServer3D.map_set_up(map, Vector3.UP)
	NavigationServer3D.map_set_active(map, true)
	var region = NavigationServer3D.region_create()
	NavigationServer3D.region_set_transform(region, $"../../world/environment/navmesh".transform)
	NavigationServer3D.region_set_map(region, map)
	var navigation_mesh = NavigationMesh.new()
	navigation_mesh = $"../../world/environment/navmesh/region".navigation_mesh
	NavigationServer3D.region_set_navigation_mesh(region, navigation_mesh)

# TODO: Implement filter for when index is invalid
# TODO: fix bug where building shows up at 0,0,0 before mousemove
func start_building_placement(shortname):
	building_being_placed = construction_scenes[shortname]
	building_being_placed_shortname = shortname
	spawn_preview_mesh(construction_previews[shortname])

# cancel building placement process
func stop_building_placement():
	building_preview_scene.queue_free()
	building_preview_scene = null

func confirm_building_placement(coordinates):
	var construction = place_construction(building_being_placed, coordinates)
	stop_building_placement()
	$construction_logic.add_constructed_building(0, building_being_placed_shortname)
	update_current_constructions_list()
	if building_being_placed_shortname == "tt":
		construction.new_dump_point_available.connect(register_new_dump_point)
		spawn_unit(unit_scenes["collector"], current_player_id, construction.position)


func spawn_preview_mesh(scene):
	building_preview_scene = scene.instantiate()
	$"../../world".add_child(building_preview_scene)

func move_preview_mesh(coordinates):
	building_preview_scene.position = coordinates
	
func rotate_preview_mesh(rotation):
	building_preview_scene.rotation = rotation

func place_construction(scene, coordinates):
	var construction = scene.instantiate()
	if construction.name == "gear_of_generating":
		temp_unit_spawn_locations.append(coordinates)
	construction.position = coordinates
	$"../../world".add_child(construction)
	return construction

func populate_construction_options():
	var building1 = preload("res://game/objects/constructions/building1/building1.tscn")
	var building3 = preload("res://game/objects/constructions/building3/building3.tscn")
	var cc = preload("res://game/objects/constructions/cone_of_construction/cone_of_construction.tscn")
	var gg = preload("res://game/objects/constructions/gear_of_generating/gear_of_generating.tscn")
	var oo = preload("res://game/objects/constructions/orb_of_observation/orb_of_observation.tscn")
	var rr = preload("res://game/objects/constructions/rectangular_reactor/rectangular_reactor.tscn")
	var tt = preload("res://game/objects/constructions/tetrahedron_of_transmutation/tetrahedron_of_transmutation.tscn")
	var pp = preload("res://game/objects/constructions/prism_of_protection/prism_of_protection.tscn")
#	buildings.append(building1)
#	buildings.append(building3)
	construction_scenes["1"] = building1
	construction_scenes["3"] = building3
	construction_scenes["cc"] = cc
	construction_scenes["gg"] = gg
	construction_scenes["oo"] = oo
	construction_scenes["rr"] = rr
	construction_scenes["tt"] = tt
	construction_scenes["pp"] = pp
	
	var building1_preview = preload("res://game/objects/construction_previews/building1_preview/building1_preview.tscn")
	var building2_preview = preload("res://game/objects/construction_previews/building2_preview/building2_preview.tscn")
	var building3_preview = preload("res://game/objects/construction_previews/building3_preview/building3_preview.tscn")
	var cc_preview = preload("res://game/objects/construction_previews/coc_preview/c.tscn")
	var gg_preview = preload("res://game/objects/construction_previews/gog_preview/g.tscn")
	var oo_preview = preload("res://game/objects/construction_previews/ooo_preview/o.tscn")
	var rr_preview = preload("res://game/objects/construction_previews/rr_preview/r.tscn")
	var tt_preview = preload("res://game/objects/construction_previews/tot_preview/t.tscn")
	var pp_preview = preload("res://game/objects/construction_previews/pp_preview/p.tscn")
	construction_previews["1"] = building1_preview
	construction_previews["3"] = building3_preview
	construction_previews["cc"] = cc_preview
	construction_previews["gg"] = gg_preview
	construction_previews["oo"] = oo_preview
	construction_previews["rr"] = rr_preview
	construction_previews["tt"] = tt_preview
	construction_previews["pp"] = pp_preview
	
	var collector = preload("res://game/objects/vehicles/collector/collector.tscn")
	var testcar = preload("res://game/objects/vehicles/testcar/testcar.tscn")
	var testtank = preload("res://game/objects/vehicles/test_tank/test_tank.tscn")
	unit_scenes["collector"] = collector
	unit_scenes["testcar"] = testcar
	unit_scenes["testtank"] = testtank
	
	
func update_current_constructions_list():
	var current_constructions = $construction_logic.return_player_buildings(0)
	var filtered_list = []
	for key in current_constructions:
		if current_constructions[key] > 0:
			filtered_list.append(key)
	var option_list = $tech_tree.get_options(filtered_list)
#	var menu_structure = {}
#	menu_structure["buildings"] = [option_list]
#	rts_hud.update_build_options(menu_structure)
	rts_hud.update_build_options(option_list)

func move_camera_to_last_event():
	pass

func move_units_to_location(list_of_units, location):
	for unit in list_of_units:
		unit.move_to_location(location)

func move_selected_units_to_location(location):
	move_units_to_location(get_selected_units(), location)

func add_to_selected_units(unit):
	selected_units.append(unit)
#	unit.add_to_group("selected")
	rts_hud.show_object_healthbar(unit)

# TODO: is it better to keep an array or to just add_to_group("selected_units") ?
func get_selected_units():
	return selected_units
#	return get_tree().get_nodes_in_group("selected")

func clear_unit_selection():
	for unit in selected_units:
		rts_hud.hide_object_healthbar(unit)
	selected_units.clear()

func start_producing_unit(unit_name):
	var location = temp_unit_spawn_locations[0]
	spawn_unit(unit_scenes[unit_name], current_player_id, location+Vector3(0,1,0))

func spawn_unit(unit_scene, player, location):
	var unit = unit_scene.instantiate()
	unit.position = location
	unit.add_to_group("units")
	$player_management.add_object_to_category(player, "units", unit)
	rts_hud.register_new_object(unit)
	rts_hud.hide_object_healthbar(unit)
	$"../../world/actors".add_child(unit)
	unit.terminated.connect(handle_unit_termination.bind(unit))
	if unit.has_signal("deposited"):
		unit.deposited.connect(handle_collector_deposit)
		$player_management.add_object_to_category(player, "collectors", unit)
	if unit.has_method("set_colour"):
#		print($player_management.get_category(player, "colour"))
		unit.call_deferred("set_colour", $player_management.get_category(player, "colour"))
	
	
	
func select_units_within_rectangle(rectangle_start, rectangle_end):
	clear_unit_selection()
	var all = get_units_within_rectangle(rectangle_start, rectangle_end)
	var filter = filter_player_units(current_player_id, all)
	for unit in filter:
		add_to_selected_units(unit)


func get_units_within_rectangle(rectangle_start, rectangle_end):
	var all_units = get_tree().get_nodes_in_group("units")
	return rts_camera.get_units_within_rectangle(all_units, rectangle_start, rectangle_end)

func filter_player_units(player, unit_list):
	var player_units = []
	for unit in unit_list:
		if object_belongs_to_player(player, unit):
			player_units.append(unit)
	return player_units

func object_belongs_to_player(player, object):
	for category in ["constructions", "units"]:
		if object in $player_management.get_category(player, category):
			return true
	
# see if hover ray got a child of a unit
# TODO: figure out less funky way of dealing with this
func attempt_getting_unit(object):
	if object:
		var attempts = 3
		var parent = object
		while attempts > 0:
			if parent.is_in_group("units"):
				return parent
			parent = parent.get_parent()
			attempts -= 1
		return object

# return the appropriate interaction
func get_action(player, object):
	if object.is_in_group("units"):
		if object_belongs_to_player(player, object):
			return "select"
		else:
			return "attack"

func selected_units_attack(object):
	for unit in selected_units:
		if unit.has_method("attack_object"):
			unit.attack_object(object)

func fire_test():
	var all_units = get_tree().get_nodes_in_group("units")
	all_units[0].set_colour(Color(0.2,0.2,1))
	if all_units.size() > 1:
		all_units[0].attack_object(all_units[1])

#func get_object_at_position(position, limit_radius):
#	pass

func remove_From_selected_units(unit):
	if unit in selected_units:
		selected_units.erase(unit)

func handle_unit_termination(unit):
	remove_From_selected_units(unit)
	rts_hud.delete_object_healthbar(unit)
	
func handle_collector_deposit(amount):
	add_resources_to_player(current_player_id, amount)
	rts_hud.set_resource_count_value(get_player_resource_count(current_player_id))

func get_player_resource_count(player):
	return $player_management.get_category(player, "resources")
	
func add_resources_to_player(player, amount):
	$player_management.players[player]["resources"] += amount
	rts_hud.set_resource_count_value(get_player_resource_count(current_player_id))

func remove_resources_from_player(player, amount):
	$player_management.players[player]["resources"] -= amount
	rts_hud.set_resource_count_value(get_player_resource_count(current_player_id))

func define_construction_cost():
	construction_cost["cc"] = 0
	construction_cost["gg"] = 5
	construction_cost["oo"] = 4
	construction_cost["rr"] = 4
	construction_cost["tt"] = 5
	construction_cost["pp"] = 3
	construction_cost["collector"] = 3
	construction_cost["testcar"] = 2
	construction_cost["testtank"] = 4

func attemt_building_production(player, building_shortname):
	if get_player_resource_count(player) > construction_cost[building_shortname]:
		remove_resources_from_player(player, construction_cost[building_shortname])
		start_building_placement(building_shortname)
		return true

func start_match(match_properties):
	# match start stuff
	$player_management.set_number_of_players(3)
	handle_collector_deposit(starting_resources)
	initialise_player_construction_trackers(
		
	)
	for player_id in $player_management.players.size():
		var player_cc = construction_scenes["cc"]
		place_construction(player_cc, starting_positions[player_id].position)
		$construction_logic.add_constructed_building(player_id,"cc")
	
	$player_management.players[1]["colour"] = (Color(0.2, 0.2, 0.9))
	$player_management.players[2]["colour"] = (Color(0.9, 0.2, 0.2))
	
	var height = 0.5
	spawn_unit(unit_scenes["testtank"], current_player_id, Vector3(3,height,3))
	spawn_unit(unit_scenes["testtank"], current_player_id, Vector3(3,height,8))
	spawn_unit(unit_scenes["testtank"], 2, Vector3(2,height,-10))
	spawn_unit(unit_scenes["testtank"], 2, Vector3(5,height,-10))
#	spawn_unit(unit_scenes["collector"], current_player_id, Vector3(8,height,-5))

func register_new_dump_point(point, player):
	pass

func spawn_player(position):
	pass
