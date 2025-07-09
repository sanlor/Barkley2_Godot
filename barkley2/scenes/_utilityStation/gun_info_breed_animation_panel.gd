extends B2_UtilityPanel
## Play the breeding animation.
# Check oCinemaFusion, obj_breedanm_parentpanels, CinemaFusion

## Me trying to make this animation: https://www.youtube.com/watch?v=dXjcvIPSBr4

## NOTE This is very interesting. its not a giant "gif" with all animation frames. its kinda made on the fly, with timers and all kinds of random shit.
# My version uses small segments using Animation player.

@onready var animation_player: 				AnimationPlayer = $AnimationPlayer
@onready var s_cinema_switch_plate: 		Sprite2D = $Control/SCinemaSwitchPlate
@onready var hoopz_screen: 					AnimatedSprite2D = $Control/hoopz_screen
@onready var spr_breedanm: 					TextureRect = $Control/spr_breedanm
@onready var s_cinema_fusion_button: 		TextureRect = $Control/sCinemaFusionButton
@onready var s_cinema_button_transition: 	AnimatedSprite2D = $Control/sCinemaButtonTransition
@onready var s_cinema_dna: 					AnimatedSprite2D = $Control/sCinemaDNA

@onready var bred_gun_texture: TextureRect = $Control/sCinemaDNA/pump_box/box_bound/bred_gun_texture

@export var play_anim	:= true

var selected_gun_1 : B2_Weapon ## Top
var selected_gun_2 : B2_Weapon ## Bottom
var bred_gun : B2_Weapon

func _ready() -> void:
	begin_breeding_process()
	
func begin_breeding_process() -> void:
	selected_gun_1 = B2_Gun.generate_gun() ## DEBUG
	selected_gun_2 = B2_Gun.generate_gun() ## DEBUG
	bred_gun = B2_Gun.generate_gun() ## CRITICAL Add a method of generating guns based on genes
	bred_gun_texture.texture = bred_gun.get_weapon_hud_sprite()
	
	_start_animation()
	
func _start_animation() -> void:
	if Engine.is_editor_hint():
		return
		
	if not play_anim:
		return
		
	hoopz_screen.hide()
	spr_breedanm.hide()
	s_cinema_fusion_button.hide()
	s_cinema_button_transition.hide()
	s_cinema_dna.hide()
	
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
	
	## Pause node until its time.
	spr_breedanm.show()
	spr_breedanm.process_mode = Node.PROCESS_MODE_ALWAYS
	
	animation_player.play("dna_1_animation")
	await animation_player.animation_finished
	spr_breedanm.process_mode = Node.PROCESS_MODE_DISABLED
	spr_breedanm.hide()
	
	s_cinema_fusion_button.show()
	animation_player.play("punch_button")
	await animation_player.animation_finished
	s_cinema_fusion_button.hide()
	
	s_cinema_button_transition.show()
	s_cinema_button_transition.play()
	await s_cinema_button_transition.animation_finished
	s_cinema_button_transition.hide()
	
	s_cinema_dna.show()

func sfx_flick_switch() -> void:
	B2_Sound.play("sn_mnu_switchFlick01")

func sfx_pull_lever() -> void:
	B2_Sound.play("sn_mnu_bigSwitch01")
	
func sfx_dna_info() -> void:
	B2_Sound.play("sn_mnu_gunInfoScreen01")
	
func sfx_dna_gunsmap() -> void:
	B2_Sound.play("sn_mnu_gunsmapScene01")
	
func sfx_punch_love() -> void:
	B2_Sound.play("sn_mnu_loveButtonTransition01")
