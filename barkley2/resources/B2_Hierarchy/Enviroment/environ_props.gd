@tool
extends B2_Environ
class_name B2_EnvironProp

# Simple Props, nothing too fancy
# create collision manually

@export var change_frame_at_sudo_random := true
@export var limit_frame_range 	:= false
@export var limit_frame_start 	:= 0
@export var limit_frame_end 	:= 0

@export var cast_shadow 				:= false
@export var draw_base					:= false

@export_category("Collision")
@export var shape 			:= SHAPES.CIRCLE
@export var create_collision := false :
	set(b):
		lazy_bastard()

func _ready() -> void:
	seed( hash( position ) )
	animation = "default"
	if change_frame_at_sudo_random:
		if limit_frame_range:
			frame = randi_range( limit_frame_start, limit_frame_end )
		else:
			frame = randi_range( 0, sprite_frames.get_frame_count("default") )
	if cast_shadow:
		if sprite_frames.has_animation("shadow"):
			var shadow_node 			:= AnimatedSprite2D.new()
			shadow_node.sprite_frames 	= sprite_frames
			shadow_node.centered 		= centered
			shadow_node.offset 			= offset
			shadow_node.animation		= "shadow"
			shadow_node.name 			= name + "_shadow"
			shadow_node.z_index 		= 0
			add_child( shadow_node, true )
		else:
			push_warning("No animation %s on node %s." % ["shadow", name] )
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
		
func lazy_bastard():
	var body := StaticBody2D.new()
	var col := CollisionShape2D.new()
	if shape == SHAPES.CIRCLE:
		var _shape := CircleShape2D.new()
		_shape.radius = sprite_frames.get_frame_texture("default", 0).get_width() * 0.4
		col.shape = _shape
	elif shape == SHAPES.SQUARE:
		var _shape := RectangleShape2D.new()
		_shape.size = sprite_frames.get_frame_texture("default", 0).get_size() * 0.8
		col.shape = _shape
		
	body.add_child( col, true)
	add_child( body, true )
	col.owner = self
	body.owner = self
