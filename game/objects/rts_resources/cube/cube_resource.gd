extends Node

signal got_collected

var being_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("resources")

func get_collected():
	got_collected.emit()
	queue_free()
