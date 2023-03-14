extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	test_switch_to_rts()
	pass


func test_switch_to_rts():
	$"../../world/cameras/rts_camera".set_primary()
	$"../../input_handler/fps".disable()
	$"../../input_handler/rts".enable()
	$"../../interface/fps_hud".hide()
	$"../../interface/rts_hud".show()

func test_switch_to_fps():
	$"../../input_handler/rts".disable()
	$"../../input_handler/fps".enable()
	$"../../interface/rts_hud".hide()
	$"../../interface/fps_hud".show()
