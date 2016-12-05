extends Spatial

export var health = 0
export var state = "" #can be "placing", "rotating" and "placed", maybe add "destroyed" to keep rubble
export var build_radius = 0
export var building_area = 0
export var power = 0 #+int gives power, -int consumes power, 0 does not affect power
var max_health = 0
var buildings = 0
var default_material = FixedMaterial.new()
var red = FixedMaterial.new()
var is_red = 0

func _ready():
	red.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(0.585938,0.169373,0.169373))
	pass
	
func start_placing():
	var UI = get_node("/root/game/UI")
	var m = FixedMaterial.new()
	set_translation(Vector3(0,-9001,0))
	get_node("mesh").set_material_override(m)
	show()
	UI.placing_building = 1
	UI.building_node = self
	UI.get_node("HUD").hide_rect()
	buildings = get_tree().get_nodes_in_group("available_build_area")

	

#function that determines if location is suitable for this construction to be placed
#TBH I have no good idea how to implement this, only bad ones
func check_if_suitable_terrain():
	pass

func check_build_area():
	var can_build = 0
	paint_red()
	var location = Vector2(get_translation().x, get_translation().z)
	for building in buildings:
		var building_location = Vector2(building.get_translation().x, building.get_translation().z)
		if location.distance_to(building_location) < building_area+building.building_area:
			can_build = 0
			paint_red()
			break
		if location.distance_to(building_location) < building.build_radius:
			can_build = 1
			get_node("mesh").set_material_override(default_material)
			is_red = 0
	return can_build
	
func place():
	add_to_group("buildings")
	add_to_group("available_build_area")
	get_node("mesh").set_material_override(default_material)
	

func show_build_area():
	pass

func paint_red():
	if !is_red:
		get_node("mesh").set_material_override(red)
		is_red = 1