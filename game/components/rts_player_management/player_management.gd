extends Node

# TODO: Player is basically a class. So implement it as a class.

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_number_of_players(value):
	for i in range(1,value+1):
		add_player(i)

func add_player(player_id):
#	var player_id = players.size()+1
	var player_properties = {}
	players[player_id] = player_properties
	var player_constructions = []
	var player_units = []
	var player_resources = 0
	var player_stats = []
	var player_colour = Color()
	var player_collectors = []
	players[player_id]["constructions"] = player_constructions
	players[player_id]["units"] = player_units
	players[player_id]["stats"] = player_stats
	players[player_id]["resources"] = player_resources
	players[player_id]["collectors"] = player_collectors
	players[player_id]["colour"] = player_colour

func get_players():
	return players

func add_new_player():
	add_player(players.size()+1)

func add_object_to_category(player_id, category, object):
	players[player_id][category].append(object)

func get_category(player_id, category):
	return players[player_id][category]
