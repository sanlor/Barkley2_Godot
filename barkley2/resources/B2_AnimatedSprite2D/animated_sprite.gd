@tool
## Special version of AnimatedSprite2D, that can hold offsets for each animation, if needed.
# Added this function on 10/07/26. Should have done this from the begining...
extends AnimatedSprite2D
class_name B2_AnimatedSprite2D
@export var animation_data : Dictionary[String, Vector2i] = {}
@export_tool_button("Apply Animation data to AnimatedSprite2D") var apply : Callable = _apply_offset_data
@export_tool_button("Get Animation data from AnimatedSprite2D") var getdata : Callable = _get_data

func _init() -> void:
	animation_changed.connect( _apply_offset_data )

func _apply_offset_data() -> void:
	## Default settings
	centered = false
	sprite_frames.set_animation_loop( animation, false )
	
	if animation_data:
		if animation_data.has( animation ):
			offset = -animation_data[animation]
		else:
			push_warning("'animation_data' has no animation called %s. Check this." % animation)
	else:
		push_warning("'animation_data' not set. fix this.")
	
func _get_data() -> void:
	if animation_data:
		if animation_data.has(animation):
			## Update current offset
			animation_data[animation] = offset * -1.0
			print_rich("[color=green] updated animation offset to %s." % animation_data[animation])
		else:
			## Add new animation to the dictionary
			animation_data[animation] = offset * -1.0
			print_rich("[color=yellow] added animation offset to %s." % animation_data[animation])
		
	else:
		## Add the center offset on all animations
		animation_data = {}
		if sprite_frames:
			for anim in sprite_frames.get_animation_names():
				var _frame := sprite_frames.get_frame_texture(anim, 0)
				animation_data[anim] = Vector2i( _frame.get_size() / 2.0 ) # Get the center
