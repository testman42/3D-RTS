extends Node

func _input(event):
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("test"):
		$"../../game_logic/general".test_switch_to_rts()
