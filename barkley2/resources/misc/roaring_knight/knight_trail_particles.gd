@tool
extends GPUParticles2D

@onready var parent_sprite : AnimatedSprite2D = get_parent()

func _ready() -> void:
	_change_texture()
	parent_sprite.animation_changed.connect( 	_change_texture )
	parent_sprite.animation_finished.connect( 	_change_texture )
	parent_sprite.frame_changed.connect( 		_change_texture )

func _change_texture() -> void:
	texture = parent_sprite.sprite_frames.get_frame_texture( parent_sprite.animation, parent_sprite.frame )
