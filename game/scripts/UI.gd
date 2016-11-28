extends Node2D

export var draw = 0
var corner1
var corner2
var corner3
var corner4

func _ready():
	pass

func _process(delta):
		update()

func _draw():
	if draw:
		draw_line( corner1, corner2, Color(1,1,1) )
		draw_line( corner2, corner3, Color(1,1,1) )
		draw_line( corner3, corner4, Color(1,1,1) )
		draw_line( corner4, corner1, Color(1,1,1) )
	
func draw_rect(start_corner,end_corner):
	corner1 = start_corner
	corner2 = Vector2(start_corner.x, end_corner.y)
	corner3 = end_corner
	corner4 = Vector2(end_corner.x, start_corner.y)
	draw = 1
	set_process(true)

func hide_rect():
	draw = 0
	pass