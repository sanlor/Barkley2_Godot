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

var gunDropIndex := 0

var all_siblings : Array
var o_turald01 : B2_InteractiveActor
var cinema_0 : B2_CinemaSpot
var cinema_1 : B2_CinemaSpot
var cinema_2 : B2_CinemaSpot
var cinema_4 : B2_CinemaSpot
var cinema_5 : B2_CinemaSpot
var state := "shadow";

var t : Tween ## Movement tween

var my_gun

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
	
# Move turald
func execute_event_user_12() -> void:
	## TODO WHY??????
	o_turald01.position -= Vector2(4,4)
	
# state = caught
func execute_event_user_13() -> void:
	B2_CManager.o_cts_hoopz.position = cinema_0.position
	o_turald01.position += Vector2(4,4)
	
	state = "caught";
	
	push_warning("Event not set")
	
# state = linefreeze
func execute_event_user_14() -> void:
	state = "linefreeze";
	z_index = 0
	
# state = line
func execute_event_user_15() -> void:
	state = "line";
	z_index = 0
	
	B2_Sound.play("splash_in")
	animation = gunSplash[gunDropIndex]
	sprite_frames.set_animation_loop( gunSplash[gunDropIndex], false )
	play( gunSplash[gunDropIndex] )
	await animation_finished
	play( gunSprite[gunDropIndex] )
