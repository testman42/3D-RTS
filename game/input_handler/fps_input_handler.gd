extends Node


# TODO: should set_process_input(false) be the solution for this?
var enabled = false
var player_character

# Called when the node enters the scene tree for the first time.
func _ready():
	player_character = get_tree().get_first_node_in_group("player_character")
	enable()
	
func _process(_delta):
	if enabled:
		var movement_vector = Input.get_vector("left", "right", "forward", "backwards")
		player_character.set_movement_vector(movement_vector)

func _input(event):
	if enabled:
		if event.is_action_pressed("action1"):
			player_character.shoot_hitscan()
		if event.is_action_pressed("action2"):
			player_character.shoot_projectile()
		# TODO: figure out how to untangle this mess
		$"../../game_logic/fps".update_ammo_count()


func enable():
	enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	player_character.enable_control()

func disable():
#	player_character.set_movement_vector(Vector2(0,0))
#	player_character.disable_control()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	enabled = false
