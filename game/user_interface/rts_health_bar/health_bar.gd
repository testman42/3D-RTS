extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.value = 100
#	hide()

func set_value(value):
	$ProgressBar.value = value

func show_background():
	$background.show()

func hide_background():
	$background.hide()
