extends Spatial

export var health = 0
export var state = "" #can be "placing", "rotating" and "placed", maybe add "destroyed" to keep rubble
export var build_radius = 0
export var power = 0 #+int gives power, -int consumes power, 0 does not affect power

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func start_placing():
	pass

#function that determines if location is suitable for this construction to be placed
func check_location():
	pass
	
func place():
	pass
