extends Node

var building_being_placed # variable that tracks the index of building
var building_preview_scene # scene that shows preview
var constructed_player_buildings = {}

# Called when the node enters the scene tree for the first time.
#func _ready():
#	print("yo")

func initialise_player_construction_trackers(number_of_players, construction_list):
	for i in range(0,number_of_players):
		var player_buildings = {}
		for item in construction_list:
			player_buildings[item] = 0
		constructed_player_buildings[i] = player_buildings

func return_player_buildings(player):
	return constructed_player_buildings[player]

func add_constructed_building(player, building):
	constructed_player_buildings[player][building] += 1

func remove_constructed_building(player, building):
	constructed_player_buildings[player][building] -= 1

# TODO: implement logic for rectangular shapes as well as circular
func check_if_location_is_valid(coordinates, construction_size):
	pass

func check_proximity_to_other_buildings(coordinates, radius):
	pass
