extends Spatial

var health = 0
var speed = 5.0

var begin = Vector3()
var end = Vector3()
var path = []

var debug = 0

var line_timer = Timer.new()

var im = ImmediateGeometry.new()

var material = SpatialMaterial.new()
var color = SpatialMaterial.new()
var gray_mat = SpatialMaterial.new()

# TODO: implement unit manager that handles movement logic for multiple units
onready var navigation = get_node("../../../environment/map/navigation")

func _ready():
	
# lol this was not good
# destination lines should be part of 2D hud, not a 3D line through the terrain
	#sets destination line color and size
#	material.set_line_width(2)
#	material.set_point_size(2)
#	material.set_fixed_flag(SpatialMaterial.FLAG_USE_POINT_SIZE, true)
#	material.set_parameter(SpatialMaterial.PARAM_DIFFUSE, Color(0.2, 0.8, 0.2))
#	material.set_flag(SpatialMaterial.FLAG_UNSHADED, true)
	
#	add_child(line_timer)
#	get_node("/root/game/game_world").add_child(im)
	#print(navigation)
	pass
	
func _process(delta):
	#code stolen from Godot navmesh demo, I have no idea how this actually works
	if (path.size() > 1):
		var to_walk = delta*speed
		var to_watch = Vector3(0, 1, 0)
		while(to_walk > 0 and path.size() >= 2):
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			to_watch = (pto - pfrom).normalized()
			var d = pfrom.distance_to(pto)
			if (d <= to_walk):
				path.remove(path.size() - 1)
				to_walk -= d
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
				to_walk = 0
		
		var atpos = path[path.size() - 1]
		var atdir = to_watch
		atdir.y = 0
		
		var t = Transform()
		t.origin = atpos
		t=t.looking_at(atpos + atdir, Vector3(0, 1, 0))
		set_transform(t)
		
		#draw line to destination
#		if line_timer.get_time_left() > 0 and "selected" in get_groups():
#			redraw_destination_line()
#		else:
#			im.clear()
		
		if (path.size() < 2):
			path = []
			set_process(false)
	else:
		set_process(false)


func update_path():
	if debug: print("trying to move")
	var p = navigation.get_simple_path(begin, end, true)
	path = Array(p) # Vector3array too complex to use, convert to regular array
	path.invert()
	set_process(true)

func set_destination(point):
	#begin = Vector3(0,0,0) 
	begin = navigation.get_closest_point(get_translation())
	end = point
	if begin.distance_to(end) > 0.1:
		update_path()

func change_health(value):
	health += value
	if health <= 0:
		blow_up()
	
func blow_up():
	pass
	
func show_destination_line(seconds):
	pass
#	line_timer.set_one_shot(true)
#	line_timer.set_wait_time(seconds)
#	line_timer.set_active(true)
#	line_timer.start()

func redraw_destination_line():
	var start_point = get_translation()
	var end_point = Vector3(end.x,end.y+0.2,end.z)
	start_point.y = 0.2
	im.clear()
	im.set_material_override(material)
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	im.add_vertex(start_point)
	im.add_vertex(end_point)
	im.end()

func find_closest_instance_of(object_type):
	var best_object = 0
	var shortest_path = 9001
	# I really hope someone doesn't make too big map
	for object in get_tree().get_nodes_in_group("resources"):
		var path = navigation.get_simple_path(get_translation(), object.get_translation() , true)
		var sum = 0
		for vector in path:
			sum += vector.length()
		if sum < shortest_path:
			shortest_path = sum
			best_object = object
	return best_object

func select():
	if debug: print("just got selected")
	add_to_group("selected")
	get_node("mesh/turret").set_material_override(gray_mat)

func deselect():
	remove_from_group("selected")
	get_node("mesh/turret").set_material_override(null)
	