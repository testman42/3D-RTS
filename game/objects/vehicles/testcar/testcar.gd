extends VehicleBody3D

func move_to_location(vector):
	$character_guiding_logic.set_target_location(vector)
