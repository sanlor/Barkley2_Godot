extends B2_UtilityPanel
## Play the breeding animation.
# Check oCinemaFusion, obj_breedanm_parentpanels, CinemaFusion

## Me trying to make this animation: https://www.youtube.com/watch?v=dXjcvIPSBr4

## NOTE This is very interesting. its not a giant "gif" with all animation frames. its kinda made on the fly, with timers and all kinds of random shit.
# My version uses small segments using Animation player.

@onready var animation_player: 			AnimationPlayer = $AnimationPlayer
@onready var s_cinema_switch_plate: 	Sprite2D = $Control/SCinemaSwitchPlate
@onready var hoopz_screen: 				AnimatedSprite2D = $Control/hoopz_screen

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	hoopz_screen.hide()
	
	B2_Music.stop(0.0)
	B2_Music.play("mus_gunfuse_track") ## TODO seems out of sync.
	B2_Sound.play("sn_mnu_switchRoomEnter01")
	
	## Play the switch part of the animation
	s_cinema_switch_plate.show()
	animation_player.play("toggle_switches")
	await animation_player.animation_finished
	s_cinema_switch_plate.hide()
	
	## Play the level pull part of the animation
	hoopz_screen.show()
	animation_player.play("lever_pull")
	await animation_player.animation_finished
	hoopz_screen.hide()

func sfx_flick_switch() -> void:
	B2_Sound.play("sn_mnu_switchFlick01")

func sfx_pull_lever() -> void:
	B2_Sound.play("sn_mnu_bigSwitch01")
