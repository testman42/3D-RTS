extends Node

var affected_meshes = []

## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func add_mesh(mesh):
	affected_meshes.append(mesh)

func set_colour(colour):
	print("setting colour: ", colour)
	for mesh in affected_meshes:
#		print("setting colour: ", colour, " for ", mesh)
		set_colour_for_mesh(colour, mesh)

func set_colour_for_mesh(colour, mesh3d):
#	var main_mesh = $CharacterBody3D/CollisionShape3D/MeshInstance3D
	var main_mesh = mesh3d
	var new_material = StandardMaterial3D.new()
	var copy_of_mesh = main_mesh.mesh.duplicate()
	main_mesh.mesh = copy_of_mesh
	new_material.albedo_color = colour
	main_mesh.mesh.surface_set_material(0,new_material)
#	current_material.set("albedo_color", Color.BLACK)
