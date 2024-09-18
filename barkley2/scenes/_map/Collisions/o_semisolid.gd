@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_semisolid16.png")
extends B2_RIGID_SEMISOLID
class_name B2_SEMISOLID

@export var setup_from_metadata := true ## Enable this if you converted the tilemap from GML

@export var basewidth 	:= 16.0
@export var baseheight 	:= 16.0
@export var width 	:= 0.0
@export var height 	:= 0.0

func _ready() -> void:
	if setup_from_metadata:
		width 	= basewidth * 	get_meta("scale").x
		height 	= baseheight * 	get_meta("scale").y
		
	if not Engine.is_editor_hint():
		# create collision stuff
		var col = CollisionShape2D.new()
		var ret = RectangleShape2D.new()
		ret.size = Vector2(width, height)
		col.shape = ret
		col.position += Vector2(width, height) / 2
		add_child( col )
		
func _draw() -> void:
	if Engine.is_editor_hint():
		z_index = 4000
		draw_rect( Rect2( Vector2.ZERO, Vector2(width, height) ), Color(Color.PINK,0.2), 		true ) 			## BG
		draw_rect( Rect2( Vector2.ZERO, Vector2(width, height) ), Color(Color.DEEP_PINK,0.8), 	false, 4.0 ) 	## Outline
		
