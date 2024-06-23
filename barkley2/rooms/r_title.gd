extends Control

## NOTE This room loads the oTitle object.
# This also forces the resolution to 384 x 240.
# This scene tries to recreate the room r_title, with the object oTitle.

## Godot Specific:
# Load necessary Images
#region Images

@onready var bg = $bg
const O_TITLE_STARPASS = preload("res://barkley2/scenes/sTitle/oTitleStarpass.tscn")

#endregion

func _ready():
	for n in bg.get_children():
		if n is AnimatedSprite2D:
			n.play("default")
	
	## Debug
	var w_scale := 2
	get_window().position /= w_scale
	get_window().size *= w_scale
	
	for i in 40:
		var star = O_TITLE_STARPASS.instantiate()
		star.position = Vector2( randf_range(0, get_viewport_rect().end.x), randf_range(0, get_viewport_rect().end.y) )
		star.name = "star" + str(i)
		add_child(star)	

func _input(event):
	if event is InputEventMouseMotion:
		pass

func _process(delta):
	#for n in bg.get_children():
		#if n.has_method("move_left"):
			#n.move_left( 80 * delta )
	pass
