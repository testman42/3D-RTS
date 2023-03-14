extends Node2D

signal finished_selecting(rectangle_start, rectangle_end)

var colour = Color(1,1,1)
var width = 1
var rectangle_start = Vector2()
var rectangle_end = Vector2()

func _ready():
	set_process(false)

func _process(delta):
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# TODO: use draw_polyline()
func _draw():
	draw_line(rectangle_start, Vector2(rectangle_start.x, rectangle_end.y), colour, width)
	draw_line(rectangle_start, Vector2(rectangle_end.x, rectangle_start.y), colour, width)
	draw_line(rectangle_end, Vector2(rectangle_start.x, rectangle_end.y), colour, width)
	draw_line(rectangle_end, Vector2(rectangle_end.x, rectangle_start.y), colour, width)

func start_drawing():
	set_visible(true)
	set_process(true)

func stop_drawing():
	finished_selecting.emit(rectangle_start, rectangle_end)
	set_visible(false)
	set_process(false)

func set_origin(coordinates):
	rectangle_start = coordinates

func set_rectangle_end(coordinates):
	rectangle_end = coordinates
