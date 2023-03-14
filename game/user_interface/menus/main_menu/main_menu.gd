extends Control

@export var autostart = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if autostart:
		_on_start_button_pressed()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
