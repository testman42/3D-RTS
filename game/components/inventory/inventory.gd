extends Node

signal amount_changed
signal item_added
signal item_removed

var ammo = 100

# TODO: dictonary? some other structure?
var inventory = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item(item):
	pass

func remove_item(item):
	pass

func reduce_ammo(value):
	ammo -= value
