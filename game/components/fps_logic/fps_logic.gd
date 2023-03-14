extends Node

var player_character
var fps_hud

func _ready():
	player_character = get_tree().get_first_node_in_group("player_character")
	fps_hud = $"../../interface/fps_hud"

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_ammo_count():
	fps_hud.get_node("ammo_counter").update_state(player_character.get_ammo_count())
