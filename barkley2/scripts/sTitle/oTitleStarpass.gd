extends Node2D

## NOTE code mostly copied from source oTitleStarpass

@export var double_speed := false

const s_title_starmove := [
preload("res://barkley2/assets/sTitle/sTitleStarmove_0.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_1.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_2.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_3.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_4.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_5.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_6.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_7.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_8.png"),
preload("res://barkley2/assets/sTitle/sTitleStarmove_9.png"),
]

var spd := 8.0 + randf_range(0,30)
var glowBase := 6 + randi_range(0,4)

## NOTE vvvv No idea what this should do 
#if(instance_exists(oTitle) and oTitle.tim>0.5)
#{
	#glowBase -= 8 * (oTitle.tim-0.5)*2;
#} 

var glowing := randi_range(0,120);
var glowspeed := 1 + randi_range(0,2);
var backLayer : bool = randi_range(0,1);

func _ready():
	_randomise()
	scale.x = 2

func _randomise():
	spd = 8.0 + randf_range(0,30.0)
	glowBase = 6 + randi_range(0,4)
	glowing = randi_range(0,120);
	glowspeed = 1 + randi_range(0,2);
	backLayer = randi_range(0,1);
	
	if backLayer:
		glowBase -= 1
		spd = spd * 0.75
		
		z_index = 0
	else:
		z_index = 10
		
	## NOTE Weirdly, some physics stuff is running half as fast.
	if double_speed:
		spd *= 4
		glowspeed *= 2
		
func _physics_process(delta):
	position.x -= spd * delta;
	
	if position.x < -16:
		#event_user(0);
		@warning_ignore("narrowing_conversion")
		position.y = randi_range(0, get_viewport_rect().end.y)
		@warning_ignore("narrowing_conversion")
		position.x = get_viewport_rect().end.x + randi_range(0,50)
		

	if glowing < 120:
		glowing += glowspeed
	else:
		glowing -= 120
		
	queue_redraw()
	
func _draw():
	var glowAmnt = glowBase;
	var shiftx = 0;
	
	## NOTE im not trying to improve anything, just copying if possible.
	if(glowing>100):
		glowAmnt -= 1
	elif(glowing>80):
		glowAmnt -=2
	elif(glowing>60):
		glowAmnt -=3
	elif(glowing>40):
		glowAmnt -=2
	elif(glowing>20):
		glowAmnt -=1

	while(shiftx < spd):
		if(glowAmnt>4):
			var glow = 10 - glowAmnt
			# draw_sprite_ext( sprite, 			subimg, 		x, 					y, 	xscale, 	yscale, 	rot, 	colour, 	alpha );
			# draw_sprite_ext( sTitleStarmove, 	9 - glowAmnt, 	x + shiftx * 2, 	y, 	2, 			1, 			0, 		c_white, 	1);
			#draw_texture( s_title_starmove[ 9 - glowAmnt ], 	Vector2(position.x + shiftx * 2, position.y), Color.WHITE )
			draw_texture( s_title_starmove[ glow ], 	Vector2(shiftx * 1, 0), Color.WHITE )
			#draw_string( ThemeDB.fallback_font, Vector2.ZERO, str(9 - glowAmnt))
			if (glow) < 0:
				print( glow )
				
		glowAmnt -= 1;
		shiftx += 1;
