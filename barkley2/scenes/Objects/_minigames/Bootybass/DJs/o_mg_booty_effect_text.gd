extends Control
# LOL trying to just copy/paste code and see how it works.
# well fuck, it doesnt work. you know what? fuck it. tweens FTW!

@onready var label: Label = $Label

var my_text 		:= "FUCK SOMETHING IS WRONG!!!!!!"
var my_text_id 		:= 0

var my_rotation 	:= randf() * 360.0
var color 			:= Color.WHITE
var color2 			:= Color.WHITE
var my_alpha 		:= 1.0
var my_scale 		:= 2.0
var randomizer 		:= randi_range(0,60) + 40

@onready var view_xview		:= get_viewport_rect().size.x
@onready var view_yview		:= get_viewport_rect().size.y

func _ready() -> void:
	label.text = Text.pr( my_text )
	
	# Apearring style #
	if randf() > 0.5:
		#position.x = view_xview + 200;
		#position.y = view_yview - 150;
		position.x = -200 * [1,-1].pick_random()
		position.y = randf_range(0,240)
	else:
		#position.x = view_xview - randf() * 384.0;
		#position.y = view_yview - 280;
		position.x = randf_range(0,384)
		position.y = -50 * [1,-1].pick_random()
		
	# Color #
	if my_text_id > 5:
		color = Color.from_rgba8(50, 255, 20, 255);
		color2 = Color.from_rgba8(0, 150, 120, 255);
	elif my_text_id == 5:
		color = Color.from_rgba8(250, 20, 50, 255);
		color2 = Color.from_rgba8(250, 10, 200, 255);
	elif my_text_id < 5:
		color = Color.from_rgba8(90, 20, 255, 255);
		color2 = Color.from_rgba8(10, 200, 255, 255);
		
	label.material.set_shader_parameter("color_1", color)
	label.material.set_shader_parameter("color_2", color2)
	
	var tweener_my_beloved := create_tween()
	tweener_my_beloved.tween_property( self, "position", Vector2(view_xview + randf_range(-250,250), view_yview + randf_range(-150,150) ) / 2.0, randf() * 1.5 ).set_trans( randi_range(0,11) ) ## random transitions? cool!
	tweener_my_beloved.parallel().tween_property( label, "rotation", randf_range(-TAU,TAU), 2.0 ).set_trans( randi_range(0,11) )
	tweener_my_beloved.parallel().tween_property( label, "scale", Vector2(4,4), 2.0 ).set_trans( randi_range(0,11) )
	tweener_my_beloved.parallel().tween_property( self, "modulate", Color.TRANSPARENT, 2.0 ).set_trans( randi_range(0,11) )
	# everything be random now. random = cool.
	tweener_my_beloved.tween_callback( queue_free )
		
##  Bad try
#func _physics_process(delta: float) -> void:
	## Alpha #
	#if my_alpha > 0: my_alpha -= 0.008;
	#else: queue_free()
#
	## Rotate #
	#if rotation > 30 and rotation < 180: rotation -= 5 * delta;
	#elif rotation > 10 and rotation < 30: rotation -= 2 * delta;
	#elif rotation >= 180 and rotation < 340: rotation += 5 * delta;
	#else: rotation += 1 * delta;
#
	## Scale #
	#if my_scale < 4: my_scale += 0.02;
#
	## Move #
	#if position.x < view_xview + 140 - randomizer: 		position.x += 5 + randi_range(0,5);
	#elif position.x < view_xview + 150 - randomizer: 	position.x += 2;
	#elif position.x > view_xview + 210 + randomizer: 	position.x -= 10;
	#elif position.x > view_xview + 200 + randomizer: 	position.x -= 2;
#
	#if position.y < view_yview + 100 - randomizer: 			position.y += 5 + randi_range(0,5);
	#elif position.y < view_yview + 110 - randomizer: 		position.y += 2;
	#elif position.y > view_yview + 170 + randomizer * 0.5: 	position.y -= 10;
	#elif position.y > view_yview + 160 + randomizer * 0.5: 	position.y -= 2;
#
	#label.scale = Vector2(1,1) * my_scale
	#label.rotation = deg_to_rad( my_rotation )
	#modulate.a = my_alpha
