extends B2_UtilityPanel
## Play the breeding animation.
# Check oCinemaFusion, obj_breedanm_parentpanels, CinemaFusion

## Me trying to make this animation: https://www.youtube.com/watch?v=dXjcvIPSBr4
## @tutorial: https://www.youtube.com/watch?v=uYOznnUePYA

## NOTE This is very interesting. its not a giant "gif" with all animation frames. its kinda made on the fly, with timers and all kinds of random shit.
# My version uses small segments using Animation player.

signal finished_breeding

@onready var animation_player: 				AnimationPlayer = $AnimationPlayer
@onready var s_cinema_switch_plate: 		Sprite2D = $Control/SCinemaSwitchPlate
@onready var hoopz_screen: 					AnimatedSprite2D = $Control/hoopz_screen

@onready var spr_breedanm: 					TextureRect = $Control/spr_breedanm
@onready var dna_left_part: 				Control = $Control/spr_breedanm/left_part
@onready var dna_right_part: 				Control = $Control/spr_breedanm/right_part
@onready var gun_map: 						Control = $Control/spr_breedanm/gun_map
@onready var new_gun_data: 					Control = $Control/sCinemaDNA/new_gun_data

@onready var s_cinema_fusion_button: 		TextureRect = $Control/sCinemaFusionButton
@onready var s_cinema_button_transition: 	AnimatedSprite2D = $Control/sCinemaButtonTransition
@onready var s_cinema_dna: 					AnimatedSprite2D = $Control/sCinemaDNA

@onready var gun_name_container: VBoxContainer = $Control/sCinemaDNA/gun_name_container

@onready var bred_gun_texture: TextureRect = $Control/sCinemaDNA/bred_gun_texture

@onready var bred_gun_lbl: Label = $Control/sCinemaDNA/bred_gun_lbl

@onready var gun_chunkler_1: Control = $Control/sCinemaDNA/sCinema_gridback/sCinemaPanelGun/gun_chunkler
@onready var gun_chunkler_2: Control = $Control/sCinemaDNA/sCinema_gridback2/sCinemaPanelGun/gun_chunkler

@export var play_anim	:= true

var selected_gun_1 : B2_Weapon ## Top
var selected_gun_2 : B2_Weapon ## Bottom
var bred_gun : B2_Weapon

var quoTxt := ["A baby gun arrives.", "A new gun enters the fray.", "A mysterious gun emerges from the woods.", "A darling gun saunters forth."]

var wait_for_input := false

func _ready() -> void:
	#begin_breeding_process()
	pass
	
func begin_breeding_process() -> void:
	#selected_gun_1 				= B2_Gun.generate_gun() ## DEBUG
	#selected_gun_2 				= B2_Gun.generate_gun() ## DEBUG
	assert( selected_gun_1, "No top gun selected???")
	assert( selected_gun_2, "No bottom gun selected???")
	assert( bred_gun, "No bred gun???")
	
	#bred_gun 					= B2_Gun.generate_gun() ## CRITICAL Add a method of generating guns based on genes
	bred_gun_texture.texture 	= bred_gun.get_weapon_hud_sprite()
	gun_name_container.setup( bred_gun )
	
	gun_map.populate_gunmap()
	
	gun_chunkler_1.gun_pos 		= Vector2( selected_gun_1.weapon_material, selected_gun_1.weapon_type)
	gun_chunkler_2.gun_pos 		= Vector2( selected_gun_2.weapon_material, selected_gun_2.weapon_type)
	gun_chunkler_1.gen_chunks()
	gun_chunkler_2.gen_chunks()
	
	bred_gun_lbl.text = Text.pr( quoTxt.pick_random() )
	
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
	
	B2_Music.store_curr_music()
	B2_Music.stop(0.0)
	B2_Music.play("mus_gunfuse_track", 0.25, false) ## TODO seems out of sync.
	B2_Sound.play("sn_mnu_switchRoomEnter01")
	
	## Play the switch part of the animation WARNING out of sync. FIX THIS!
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
	spr_breedanm.process_mode = Node.PROCESS_MODE_INHERIT
	dna_left_part.setup()
	dna_right_part.setup()
	
	## Do the first DNA animations. it was a bitch to make this look good.
	animation_player.play("dna_1_animation")
	await animation_player.animation_finished
	spr_breedanm.process_mode = Node.PROCESS_MODE_DISABLED
	spr_breedanm.hide()
	
	## Fun button punch animation.
	s_cinema_fusion_button.show()
	animation_player.play("punch_button")
	await animation_player.animation_finished
	s_cinema_fusion_button.hide()
	
	## Little transition animation
	s_cinema_button_transition.show()
	s_cinema_button_transition.play()
	await s_cinema_button_transition.animation_finished
	s_cinema_button_transition.hide()
	
	## Seccond DNA animation. Took me 1 week of work to figure out how to make the gun splitting animation. -> https://www.reddit.com/r/godot/comments/1lwjdlw/some_help_trying_to_replicate_this_effect/
	s_cinema_dna.show()
	new_gun_data.setup()
	animation_player.play("dna_2_animation")
	await animation_player.animation_finished
	
	## Jobs done.
	wait_for_input = true
	print("Breed Animation finished, waiting for input.")

func _physics_process(_delta: float) -> void:
	if wait_for_input:
		if Input.is_action_just_pressed("Action") or Input.is_action_just_pressed("Holster"):
			_finish_breeding()
			wait_for_input = false

func _finish_breeding() -> void:
	finished_breeding.emit()

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

func sfx_punch_love_bg() -> void:
	B2_Sound.play("sn_mnu_buttonBackground01")
	
func sfx_dna_furnace_open() -> void:
	B2_Sound.play("sn_mnu_DNAOpen")
	
func sfx_dna_furnace_bg() -> void:
	B2_Sound.play("sn_mnu_dnaSpliceScene")
