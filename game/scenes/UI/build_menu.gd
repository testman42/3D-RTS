extends Node2D

func _ready():
	pass



func _on_rr_pressed():
	get_node("/root/game").start_placing_building("res://game/scenes/actors/constructions/rectangular_reactor.tscn")