extends Node

signal new_dump_point_available

# Called when the node enters the scene tree for the first time.
func _ready():
	$deposit_position.add_to_group("deposit_positions")
	new_dump_point_available.emit($deposit_position)

