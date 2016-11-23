extends Spatial

# Member variables
const SPEED = 4.0

var begin = Vector3()
var end = Vector3()
var m = FixedMaterial.new()

var path = []
var draw_path = false
var destination = Vector3()

onready var camera = get_node("/root/game/world/camera/Camera")
onready var navigation = get_node("/root/game/world/terrain/map/navigation")

onready var selected = 0
var gray_mat = FixedMaterial.new()

func _ready():
	set_process_input(true)
	m.set_line_width(3)
	m.set_point_size(3)
	m.set_fixed_flag(FixedMaterial.FLAG_USE_POINT_SIZE, true)
	m.set_flag(Material.FLAG_UNSHADED, true)

func _on_body_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if (event.is_action_pressed("select")):
		if (not selected):
			get_node("mesh").set_material_override(gray_mat)
			add_to_group("selected")
		else:
			get_node("mesh").set_material_override(null)
			remove_from_group("selected")
		selected = not selected

func deselect():
	remove_from_group("selected")
	get_node("mesh").set_material_override(null)
	

func move(point):
	if ("selected" in get_groups()):
		begin = navigation.get_closest_point(get_translation())
		end = point
		_update_path()

func _process(delta):
	if (path.size() > 1):
		var to_walk = delta*SPEED
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
		get_node(".").set_transform(t)
		
		if (path.size() < 2):
			path = []
			set_process(false)
	else:
		set_process(false)

func _update_path():
	var p = navigation.get_simple_path(begin, end, true)
	path = Array(p) # Vector3array too complex to use, convert to regular array
	path.invert()
	set_process(true)

	if (draw_path):
		var im = get_node("draw")
		im.set_material_override(m)
		im.clear()
		im.begin(Mesh.PRIMITIVE_POINTS, null)
		im.add_vertex(begin)
		im.add_vertex(end)
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		for x in p:
			im.add_vertex(x)
		im.end()
