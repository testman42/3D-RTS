extends Node

export var placing_building = 0
export var just_selected = 0
export var fast_move = 0
export var rotating_camera = 0
var destination_lines_enabled = 1
var rotating_building = 0
var building_node
var building_location
var selecting_start = Vector2(0,0)
onready var camera_base = get_node("/root/game/world/camera")

func _ready():
	set_process_input(true)

func start_placing_building(building_nodepath):
	get_node("UI").placing_building = 1
	var node = load(building_nodepath)
	building_node = node.instance()
	# could I just load(building_nodepath).instance() ?
	building_node.set_translation(Vector3(0,-9001,0))
	get_node("world/actors/constructions").add_child(building_node)
	get_node("UI/HUD").hide_rect()

func cancel_building_placement():
	get_node("world/actors/constructions").remove_child(building_node)
	placing_building = 0
	rotating_building = 0
	
func move_units_group_to(group, coordinates):
		for unit in group:
			unit.set_destination(coordinates)
			if destination_lines_enabled:
				unit.show_destination_line(1)

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
	
	
	