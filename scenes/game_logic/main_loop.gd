# This script is intended to store core functions

extends Node

# this should be in settings
export var destination_lines_enabled = 1
export var debug = false

# used to temporarily store node when placing constructions
var building_node

onready var camera_anchor = get_node("/root/game/game_world/camera_anchor")

func _ready():
	set_process_input(true)
	focus_on_home()

func start_placing_building(building_nodepath):
	var node = load(building_nodepath)
	building_node = node.instance()
	# could I just load(building_nodepath).instance() ?
	get_node("/root/game/game_world/actors/constructions").add_child(building_node)
	building_node.hide() #to hide the split-second appearance at 0,0,0
	building_node.start_placing()
	
func move_units_group_to(group, coordinates):
	for unit in group:
		unit.set_destination(coordinates)
		if destination_lines_enabled:
			unit.show_destination_line(1)

func focus_on_home():
	#already placed Cone of Construction is our home for now
	var home_location = get_node("../game_world/actors/constructions/cone_of_construction").get_translation()
	if debug: print(home_location)
	camera_anchor.focus_on(home_location)
	
func spawn_unit(nodepath, location = 0):
	var unit_scene = load(nodepath)
	var unit = unit_scene.instance()
	get_node("/root/game/game_world/actors/units").add_child(unit)
	unit.add_to_group("units")
	#check if location is provided, otherwise spawn at Gear of Generating
	if typeof(location) == TYPE_VECTOR3 :
		unit.set_translation(location)
	else:
		unit.set_translation(get_node("/root/game/game_world/actors/constructions/gear_of_generating").get_translation())
	unit._ready()
	
	
	