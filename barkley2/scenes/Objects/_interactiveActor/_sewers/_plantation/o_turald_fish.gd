extends AnimatedSprite2D
## One more from the series "Wow, this object fucking suck".
# For some reason, this object controls a lot of things, like spawning guns and lots of other things.
# Fuck

# Check https://youtu.be/SQKRnzWSW0M?t=8674

const gunDrop := [
	"turald free",
	"turald weak",
	"turald good",
	"turald best",
	"turald best",
]
const gunSplash := [
	"s_effect_splash_small",
	"s_effect_splash_small",
	"s_effect_splash_medium",
	"s_effect_splash_medium",
	"s_effect_splash_big",
]
const gunSprite := [
	"s_watershadow_small",
	"s_watershadow_small",
	"s_watershadow_medium",
	"s_watershadow_medium",
	"s_watershadow_large",
]

@onready var the_gun: Sprite2D = $the_gun

var gunDropIndex := 0

var all_siblings : Array
var o_turald01 : B2_InteractiveActor
var cinema_0 : B2_CinemaSpot
var cinema_1 : B2_CinemaSpot
var cinema_2 : B2_CinemaSpot
var cinema_3 : B2_CinemaSpot
var cinema_4 : B2_CinemaSpot
var cinema_5 : B2_CinemaSpot
var state := "shadow";

var t : Tween ## Movement tween

var my_gun : B2_Weapon

## Needed for event 13, list of offsets used for some animation
var gunXof := []
var gunYof := []

func _ready() -> void:
	all_siblings = get_parent().get_children()
	for c : Node in all_siblings:
		if is_instance_valid(c):
			if c.name == "o_cinema2":
				cinema_2 = c
			elif c.name == "o_turald01":
				o_turald01 = c
			elif c.name == "o_cinema0":
				cinema_0 = c
			elif c.name == "o_cinema1":
				cinema_1 = c
			elif c.name == "o_cinema3":
				cinema_3 = c
			elif c.name == "o_cinema4":
				cinema_4 = c
			elif c.name == "o_cinema5":
				cinema_5 = c
				
	# Terrible way to do this.
	if cinema_1:
		position = cinema_1.position
	if cinema_2:
		t = create_tween()
		t.tween_property(self, "position", cinema_2.position, 1.0)
		
	# Holy shit. check o_turald_fish create event line 29
	gunXof.resize(20)
	gunYof.resize(20)
	gunXof.fill(-999)
	gunYof.fill(0)
	var xof = o_turald01.position.x # TODO sprite_get_xoffset(s_turald_pull_fish);
	var yof = o_turald01.position.y # TODO sprite_get_yoffset(s_turald_pull_fish);
	
	gunXof[2] = 49 - xof;  gunYof[2] = 44 - yof;
	gunXof[3] = 47 - xof;  gunYof[3] = 34 - yof;
	gunXof[4] = 46 - xof;  gunYof[4] = 29 - yof;
	gunXof[5] = 48 - xof;  gunYof[5] = 43 - yof;
	gunXof[6] = 41 - xof;  gunYof[6] = 46 - yof;
	gunXof[7] = 44 - xof;  gunYof[7] = 43 - yof;
	gunXof[8] = 47 - xof;  gunYof[8] = 39 - yof;
	gunXof[9] = 51 - xof;  gunYof[9] = 37 - yof;
	gunXof[10] = 45 - xof; gunYof[10] = 35 - yof;
	gunXof[11] = 48 - xof; gunYof[11] = 32 - yof;
	gunXof[12] = 47 - xof; gunYof[12] = 30 - yof;
	
	the_gun.hide()
	
# gunDropIndex = 0;
func execute_event_user_0() -> void:
	## TODO WTF this does???????
	gunDropIndex = B2_Playerdata.Quest("fishgutQuest")
	animation = str( gunSprite[gunDropIndex] )
	if gunDropIndex == 4:
		if t: t.kill()
		t = create_tween()
		t.tween_property(self, "position", cinema_2.position + Vector2(14,0), 1.0)

# Make this a chum object
func execute_event_user_5() -> void:
	## TODO ???????
	# Maybe hoopz throws some chum?
	state = "chum";
	position = B2_CManager.o_cts_hoopz.position - Vector2(0,16)
	if t: t.kill()
	t = create_tween()
	t.tween_property(self, "position", cinema_4.position, 1.0)

# SPLASH
func execute_event_user_6() -> void:
	B2_Sound.play("splash_in")
	animation = gunSplash[gunDropIndex]
	sprite_frames.set_animation_loop( gunSplash[gunDropIndex], false )
	play( gunSplash[gunDropIndex] )
	await animation_finished
	play( gunSprite[gunDropIndex] )
	
# RUN
func execute_event_user_7() -> void:
	## TODO ??????????
	state = "run";
	if t: t.kill()
	t = create_tween()
	t.tween_property(self, "position", cinema_5.position, 1.0)
	
# Make gun drop
func execute_event_user_10() -> void:
	my_gun = B2_Gun.get_gun_from_db(gunDrop[gunDropIndex])
	the_gun.texture = my_gun.get_weapon_hud_sprite()
	
# Move turald
func execute_event_user_12() -> void:
	## TODO WHY??????
	o_turald01.position -= Vector2(4,4)
	
# state = caught
func execute_event_user_13() -> void:
	B2_CManager.o_cts_hoopz.position = cinema_0.position
	o_turald01.position += Vector2(4,4)
	
	state = "caught";
	#position = o_turald01.position + Vector2( gunXof[12], gunYof[12] )
	
	const GUN_PICKUP = preload("uid://dw2s64ww53llb")
	var gun := GUN_PICKUP.instantiate()
	gun.setup_from_gun( my_gun )
	gun.dst_position = cinema_3.global_position
	gun.force_multi = 1.0
	gun.disapear_after_some_time = false
	add_sibling( gun, true )
	gun.position = the_gun.global_position
	
	queue_free()
	
# state = linefreeze
func execute_event_user_14() -> void:
	state = "linefreeze";
	z_index = 0
	
# state = line
func execute_event_user_15() -> void:
	state = "line";
	z_index = 0
	
	the_gun.show()
	
	self_modulate.a = 0.75
	B2_Sound.play("splash_in")
	animation = gunSplash[gunDropIndex]
	sprite_frames.set_animation_loop( gunSplash[gunDropIndex], false )
	play( gunSplash[gunDropIndex] )
	await animation_finished
	self_modulate = Color.TRANSPARENT

func _physics_process(_delta: float) -> void:
	if the_gun:
		if the_gun.visible:
			if randf() < 0.075: the_gun.modulate = Color.WHITE * 1.35
			elif randf() < 0.20: the_gun.modulate = Color.WHITE * 1.15
			else: the_gun.modulate = Color.WHITE
		
	if o_turald01:
		if state == "line" or state == "linefreeze":
			var frm := 0
			#if o_turald01.ActorAnim.animation == "catch":
			if state == "linefreeze":
				frm = 12
			else:
				frm = o_turald01.ActorAnim.frame
				#print(frm)
			var sub = floor(frm)
			var scl = 1.0
			var xof = floor( (49.0 / 2.0) * scl) + 24.0
			var yof = floor( (24.0 / 2.0) * scl) + 37.0
			# HUD("gun draw", spr, syb, o_turald01.x + gunXof[sub] - xof, o_turald01.y + gunYof[sub] - yof, scl, scl, c_white, 1);
			the_gun.position.x = o_turald01.position.x + gunXof[sub] - xof
			the_gun.position.y = o_turald01.position.y + gunYof[sub] - yof
