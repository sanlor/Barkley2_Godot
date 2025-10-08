@icon("uid://h7o1mi0km2lu")
@tool
extends B2_Environ
class_name B2_EnvironProp

# Simple Props, nothing too fancy
# create collision manually

@export var EnvCol : StaticBody2D

@export var change_frame_at_sudo_random := true
@export var limit_frame_range 	:= false
@export var limit_frame_start 	:= 0
@export var limit_frame_end 	:= 0

@export var cast_shadow 				:= false
@export var draw_base					:= false
@export var flip_sprite					:= false

func _ready() -> void:
	add_to_group("navigation_polygon_source_geometry_group")
	
	seed( hash( position ) )
	animation = "default"
	if change_frame_at_sudo_random:
		if limit_frame_range:
			frame = randi_range( limit_frame_start, limit_frame_end )
		else:
			frame = randi_range( 0, sprite_frames.get_frame_count("default") )
	if draw_base:
		if sprite_frames.has_animation("base"):
			if frame == 0:
				return
			var base_node 				:= AnimatedSprite2D.new()
			base_node.sprite_frames 	= sprite_frames
			base_node.centered 			= centered
			base_node.offset 			= offset
			base_node.animation			= "base"
			base_node.frame				= min( base_node.sprite_frames.get_frame_count("base"), frame ) - 1
			base_node.name 				= name + "_base"
			base_node.z_index 			-= 1
			add_child( base_node, true )
		else:
			push_warning("No animation %s on node %s." % ["base", name] )
	if cast_shadow:
		if sprite_frames.has_animation("shadow"):
			var shadow_node 			:= AnimatedSprite2D.new()
			shadow_node.position		= Vector2( 28, 0 )
			shadow_node.modulate.a		= 0.5
			shadow_node.sprite_frames 	= sprite_frames
			shadow_node.centered 		= centered
			shadow_node.offset 			= offset
			shadow_node.animation		= "shadow"
			shadow_node.name 			= name + "_shadow"
			shadow_node.z_index 		= -1
			add_child( shadow_node, true )
		else:
			push_warning("No animation %s on node %s." % ["shadow", name] )
	flip_h = flip_sprite
