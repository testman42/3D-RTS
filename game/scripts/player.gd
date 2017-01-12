extends Node

export var name = ""
export var colour = Color()
export var credits = 0
export var power = 0
export var handicap = 0
export var credits_multiplier = 0

func _ready():
	power = 0
	credits = 0
	credits_multiplier = 1