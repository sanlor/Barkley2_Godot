extends Node2D

## NOTE This room loads the oTitle object.
# This also forces the resolution to 384 x 240.
# This scene tries to recreate the room r_title, with the object oTitle.

## Godot Specific:
# Load necessary Images
#region Images

@onready var bg = $bg

#endregion

func _ready():
	for n in bg.get_children():
		if n is AnimatedSprite2D:
			n.play("default")
	
func _create_bg_sprites():
	pass
