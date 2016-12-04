extends Spatial

export var health = 0
export var state = "" #can be "placing", "rotating" and "placed", maybe add "destroyed" to keep rubble
export var build_radius = 0
export var power = 0 #+int gives power, -int consumes power, 0 does not affect power

func _ready():
	pass
	
func start_placing():
	var UI = get_node("/root/game/UI")
	set_translation(Vector3(0,-9001,0))
	show()
	UI.placing_building = 1
	UI.building_node = self
	UI.get_node("HUD").hide_rect()
	

#function that determines if location is suitable for this construction to be placed
#TBH I have no good idea how to implement this, only bad ones
func check_location():
	pass
	
func place():
	add_to_group("buildings")

func show_build_area():
	pass
