extends Panel

var offset 				:= 0.0
@export var aplitude 	:= 0.0
@export var speed 		:= 5.0
@export var freq 		:= 2.0
@export var sine_size	:= 1.0
var line_points 		:= []

func _physics_process(delta: float) -> void:
	offset += speed * delta
	queue_redraw()

func _draw() -> void:
	line_points.clear()
	var t = 0.0
	for i in 64:
		line_points.append( Vector2( i * freq, sin(t + offset) * aplitude ) + Vector2(0, size.y / 2) )
		t += 1.0
	draw_polyline( line_points, Color.WHITE, sine_size, false)
