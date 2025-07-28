@tool
extends B2_Environ
class_name B2_EnvironSolid

var EnvSolid				: StaticBody2D
var EnvCol					: CollisionShape2D

@export var create_col		:= true
@export var center_col		:= false
@export var shape 			:= SHAPES.CIRCLE
@export var fit_to_size		:= false
@export var fit_offset		:= Vector2.ZERO
@export var circle_radius 	:= 10
@export var square_size 	:= Vector2(10,10)
@export var collision_color	:= Color.LIME_GREEN
@export var collision_alpha	:= 0.15

func _enter_tree() -> void:
	if create_col:
		make_collision()
	
func make_collision():
	EnvCol = CollisionShape2D.new()
	EnvSolid = StaticBody2D.new()
	match shape:
		SHAPES.CIRCLE:
			var s := CircleShape2D.new()
			if fit_to_size:
				if sprite_frames.has_animation("default"):
					if sprite_frames.get_frame_count("default") > 0:
						s.radius = sprite_frames.get_frame_texture("default", 0).get_size().x
					else:
						push_error("B2_Environ %s has no animation frames." % name)
				else:
					push_error("B2_Environ %s has no default animation." % name)
				
			else:
				s.radius = circle_radius
			EnvCol.shape = s
		SHAPES.SQUARE:
			var s := RectangleShape2D.new()
			if fit_to_size:
				if sprite_frames.has_animation("default"):
					if sprite_frames.get_frame_count("default") > 0:
						s.size = sprite_frames.get_frame_texture("default", 0).get_size()
					else:
						push_error("B2_Environ %s has no animation frames." % name)
				else:
					push_error("B2_Environ %s has no default animation." % name)
					
			else:
				s.size = square_size
			EnvCol.shape = s
		_:
			breakpoint # ??? Weird shape
			
	EnvSolid.add_to_group("navigation_polygon_source_geometry_group")
	if center_col:
		if sprite_frames.has_animation("default"):
			if sprite_frames.get_frame_count("default") > 0:
					
				EnvSolid.position = sprite_frames.get_frame_texture("default", 0).get_size() / 2.0
			else:
				push_error("B2_Environ %s has no animation frames." % name)
		else:
			push_error("B2_Environ %s has no default animation." % name)
			
	add_child(EnvSolid, true)
	EnvSolid.add_child(EnvCol, true)
	EnvSolid.position += fit_offset
	EnvCol.debug_color = Color( collision_color, collision_alpha )
	
func disable( state : bool ):
	EnvCol.disabled = state
