@icon("res://barkley2/assets/b2_original/images/merged/sHoopzFace.png")
extends B2_PlayerCombatActor
class_name B2_Player


# I THINK o_hoopz is the main player object. there is also o_cts_hoopz, but I think its only meant for cutscenes. 
# Not being able to debug the original game makes this harder.

# check scr_player_init()
# check scr_player_step_executePipeline()
# check scr_player_step_processInput() #  NOTE Handle player input
# check scr_player_step_preProcessing() # NOTE Handle player damage and combat?
# check scr_player_calculateWeight() # NOTE Oh fuck you
# check BodySwap() # INFO IMPORTANT Has important setup for each body. What a mess.
# check scr_player_stance_diaper() # NOTE Finally, stuff related to the audio and steps.
# i hate this

## NOTE
# Missing footsteps o_hoopz_footstep
# Missing "Wading wave" (No idea what it is)

## Combat
# Check scr_player_stance_drawing()
# Check scr_player_stance_gunmode()
# Check scr_player_draw_walking_gunmode()

@export_category("Player Permission")
@export var can_roll 		:= true
@export var can_draw_weapon := true
@export var can_shoot		:= true

@export_category("Combat Sprites")
@export var combat_upper_sprite 	: AnimatedSprite2D
@export var combat_lower_sprite 	: AnimatedSprite2D
@export var combat_arm_back 		: AnimatedSprite2D
@export var combat_arm_front 		: AnimatedSprite2D
@export var combat_weapon 			: AnimatedSprite2D
@export var combat_weapon_parts 	: AnimatedSprite2D
@export var combat_weapon_spots 	: AnimatedSprite2D
@export var gun_muzzle				: Marker2D

@onready var aim_origin: Marker2D = $aim_origin

const COMBAT_SHUFFLE 		:= "aim_shuffle"
const COMBAT_STAND 			:= "aim_stand"
const COMBAT_STAND_E 		:= 0
const COMBAT_STAND_NE 		:= 1
const COMBAT_STAND_N		:= 2
const COMBAT_STAND_NW		:= 3
const COMBAT_STAND_W		:= 4
const COMBAT_STAND_SW		:= 5
const COMBAT_STAND_S		:= 6
const COMBAT_STAND_SE		:= 7

const COMBAT_WALK_E 		:= "walk_E"
const COMBAT_WALK_NE 		:= "walk_NE"
const COMBAT_WALK_N			:= "walk_N"
const COMBAT_WALK_NW		:= "walk_NW"
const COMBAT_WALK_W			:= "walk_W"
const COMBAT_WALK_SW		:= "walk_SW"
const COMBAT_WALK_S			:= "walk_S"
const COMBAT_WALK_SE		:= "walk_SE"

enum STATE{NORMAL,ROLL,AIM}
var curr_STATE := STATE.NORMAL :
	set(s) : 
		curr_STATE = s
		_change_sprites()

# Combat Animations
var aim_dir := Vector2.ZERO
var waddle	:= false # If hoopz legs should waddle torward the aiming direction

var combat_last_direction 	:= Vector2.ZERO
var combat_last_input 		:= Vector2.ZERO

var prev_gun : B2_Weapon ## Used to update animations

# Movement
var external_velocity 	:= Vector2.ZERO ## DEBUG - applyied by the door.
var velocity			:= Vector2.ZERO

var walk_speed			:= 5000000
var roll_impulse		:= 1000000
var walk_damp			:= 10.0
var roll_damp			:= 2.5

## Debug
var debug_line : Vector2
var debug_walk_dir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	B2_CManager.o_hoopz = self
	B2_Input.player_follow_mouse.connect( func(state): follow_mouse = state )
	B2_Playerdata.gun_changed.connect( _update_held_gun )
	linear_damp = walk_damp
	_change_sprites()
	
	if get_parent() is B2_ROOMS:
		get_parent().permission_changed.connect( get_room_permissions )
	
	get_room_permissions()
	
func toggle_collision() -> void:
	var hoopz_collision: CollisionShape2D = $hoopz_collision
	hoopz_collision.disabled = not hoopz_collision.disabled
	print_rich("[color=red][b]Hoopz collision has been changed to %s. This should not happen outside of DEBUG situations.[/b][/color]" % not hoopz_collision.disabled)
		
func get_room_permissions():
	if get_parent() is B2_ROOMS:
		can_roll 			= get_parent().room_player_can_roll
		#can_shoot 			= not get_parent().room_pacify ## DEBUG disabled
		can_draw_weapon 	= not get_parent().room_pacify
	else:
		print("B2_PLAYER: Not inside a room. do whatever is set on exports")
	
## TODO remove this section with old code.
#func _update_held_gun() -> void:
	#var gun := B2_Gun.get_current_gun()
	#set_gun( gun.get_held_sprite(), gun.weapon_type )
	#
	### Change color.
	#print(gun.get_gun_color1())
	#combat_weapon.modulate 				= gun.get_gun_color1()
	#combat_weapon_parts.modulate 		= gun.get_gun_color2()
	#combat_weapon_parts.modulate.a 		= gun.get_gun_alpha()
	#combat_weapon_spots.modulate 		= gun.get_gun_color3()
## update the current gun sprite, adding details if needed (spots, parts).

func _update_held_gun() -> void:
	var gun := B2_Gun.get_current_gun()
	if gun:
		if gun != prev_gun:
			set_gun( gun.get_held_sprite(), gun.weapon_type )
			
			## Change color.
			var colors := gun.get_gun_colors()
			combat_weapon.modulate 					= colors[0]
			
			if colors[1]:
				combat_weapon_parts.show()
				combat_weapon_parts.modulate 		= colors[1]
			else:
				combat_weapon_parts.hide()
				
			if colors[2]:
				combat_weapon_spots.show()
				combat_weapon_spots.modulate 		= colors[2]
			else:
				combat_weapon_spots.hide()
			prev_gun = gun
## Change the held weapon sprite. Also can change hoopz torso.
## NOTE Check combat_gunwield_drawGun_player_frontHand() and combat_gunwield_drawGun_player_backHand().
## WARNING Missing "Dual" type. TODO
func set_gun( gun_name : String, gun_type : B2_Gun.TYPE ) -> void:
	if combat_weapon.sprite_frames.has_animation( gun_name ):
		combat_weapon.show()
		combat_weapon.animation = gun_name
	else:
		push_warning("Invalid main gun sprite")
		combat_weapon.hide()
		
	if combat_weapon_parts.sprite_frames.has_animation( gun_name ):
		combat_weapon_parts.show()
		combat_weapon_parts.animation = gun_name
	else: combat_weapon_parts.hide()
		
	if combat_weapon_spots.sprite_frames.has_animation( gun_name ):
		combat_weapon_spots.show()
		combat_weapon_spots.animation = gun_name
	else: combat_weapon_spots.hide()
	
	if [B2_Gun.TYPE.GUN_TYPE_REVOLVER,
		B2_Gun.TYPE.GUN_TYPE_PISTOL,
		B2_Gun.TYPE.GUN_TYPE_FLINTLOCK,
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN,
		B2_Gun.TYPE.GUN_TYPE_MAGNUM,
		B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN,
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL ].has( gun_type ): 
			combat_arm_back.animation 	= "s_HoopzTorso_Handgun"
			combat_arm_front.animation 	= "s_HoopzTorso_Handgun"
	elif [
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN,
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,
		B2_Gun.TYPE.GUN_TYPE_RIFLE,
		B2_Gun.TYPE.GUN_TYPE_MUSKET,
		B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,
		B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN,
		B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN,
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN,
		B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN,
		B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER,
		B2_Gun.TYPE.GUN_TYPE_CROSSBOW,
		B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE].has( gun_type ):
			combat_arm_back.animation 	= "s_HoopzTorso_Rifle"
			combat_arm_front.animation 	= "s_HoopzTorso_Rifle"
	elif [
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN,
		B2_Gun.TYPE.GUN_TYPE_MINIGUN,
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE,
		B2_Gun.TYPE.GUN_TYPE_BFG,].has( gun_type ):
			combat_arm_back.animation 	= "s_HoopzTorso_Heavy"
			combat_arm_front.animation 	= "s_HoopzTorso_Heavy"
	elif gun_type == B2_Gun.TYPE.GUN_TYPE_ROCKET:
			combat_arm_back.animation 	= "s_HoopzTorso_Rocket"
			combat_arm_front.animation 	= "s_HoopzTorso_Rocket"
	else:
		## Unknown type.
		breakpoint
	
func shoot_gun() -> void:
	var gun := B2_Gun.get_current_gun()
	if gun:
		gun.shoot_gun( get_parent(), combat_weapon.global_position, gun_muzzle.global_position, position.direction_to( -aim_origin.position + get_global_mouse_position() ) )
	
func _change_sprites():
	match curr_STATE:
		STATE.NORMAL, STATE.ROLL:
			hoopz_normal_body.show()
			
			combat_lower_sprite.hide()
			combat_upper_sprite.hide()
			combat_arm_back.hide()
			combat_arm_front.hide()
			combat_weapon.hide()
			combat_weapon_parts.hide()
			combat_weapon_spots.hide()
		STATE.AIM:
			hoopz_normal_body.hide()
			
			combat_lower_sprite.show()
			combat_upper_sprite.show()
			combat_arm_back.show()
			combat_arm_front.show()
			combat_weapon.show()
			combat_weapon_parts.show()
			combat_weapon_spots.show()

## Very similar to normal animation control, but with some more details related to the diffferent body parts.
func combat_walk_animation(delta : float):
	var input 			:= Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if combat_last_input != input:
			add_smoke()
			
			match input:
				Vector2.UP + Vector2.LEFT:			combat_lower_sprite.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:			combat_lower_sprite.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:		combat_lower_sprite.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:		combat_lower_sprite.play(WALK_SE)
					
				Vector2.UP:			combat_lower_sprite.play(WALK_N)
				Vector2.LEFT:		combat_lower_sprite.play(WALK_W)
				Vector2.DOWN:		combat_lower_sprite.play(WALK_S)
				Vector2.RIGHT:		combat_lower_sprite.play(WALK_E)
				_: # Catch All
					combat_lower_sprite.play(WALK_S)
					print("Catch all, ", input)
					
	else:
		# player is not moving the character anymore
		combat_lower_sprite.stop()
		
		var curr_direction : Vector2 = ( position - Vector2( 0, 16 ) ).direction_to( get_global_mouse_position() ).round()
		
		if curr_direction != combat_last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			combat_lower_sprite.animation = COMBAT_SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle. 
				## WARNING Original game doesnt do this.
				#B2_Sound.play_pick("hoopz_footstep")
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			combat_lower_sprite.animation = COMBAT_STAND
			is_turning = false
		
		# change the animation itself.
		match combat_last_direction:
			Vector2.UP + Vector2.LEFT:		combat_lower_sprite.frame = COMBAT_STAND_NW
			Vector2.UP + Vector2.RIGHT:		combat_lower_sprite.frame = COMBAT_STAND_NE
			Vector2.DOWN + Vector2.LEFT:	combat_lower_sprite.frame = COMBAT_STAND_SW
			Vector2.DOWN + Vector2.RIGHT:	combat_lower_sprite.frame = COMBAT_STAND_SE
				
			Vector2.UP:		combat_lower_sprite.frame = COMBAT_STAND_N
			Vector2.LEFT:	combat_lower_sprite.frame = COMBAT_STAND_W
			Vector2.DOWN:	combat_lower_sprite.frame = COMBAT_STAND_S
			Vector2.RIGHT:	combat_lower_sprite.frame = COMBAT_STAND_E
				
			_: # Catch All
				combat_lower_sprite.frame = STAND_S
				print("Catch all, ", input)
				
		# Update var
		combat_last_direction = curr_direction
	# Update var
	combat_last_input = input
	debug_walk_dir = input
	
## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_aim_animation():
	var mouse_input 	:= ( position + Vector2( 0, -16 ) ).direction_to( get_global_mouse_position() ).snapped( Vector2(0.33,0.33) )
	var dir_frame = combat_upper_sprite.frame
	
	## Remember, 0.9999999999999 != 1.0
	match mouse_input:
			# Normal stuff
			Vector2(0,	-0.99):
				dir_frame = 		4
			Vector2(-0.99,	0):
				dir_frame = 		8
			Vector2(0,	0.99):
				dir_frame = 		12
			Vector2(0.99,	0):	
				dir_frame = 		0
				
			# Diagonal stuff
			Vector2(0.66,	0.66): # Low Right
				dir_frame = 		14
			Vector2(-0.66,	0.66): # Low Left
				dir_frame = 		10
			Vector2(0.66,	-0.66): # High Right
				dir_frame = 		2
			Vector2(-0.66,	-0.66):	# High Left
				dir_frame = 		6
			
			# Madness
			#Down
			Vector2(0.33,	0.99): # Rightish
				dir_frame = 		13
			Vector2(-0.33,	0.99): # Leftish
				dir_frame = 		11
			#Up
			Vector2(0.33,	-0.99): # Rightish
				dir_frame = 		3
			Vector2(-0.33,	-0.99): # Leftish
				dir_frame = 		5
			#Left
			Vector2(-0.99,	0.33): # Upish
				dir_frame = 		9
			Vector2(-0.99,	-0.33): # Downish
				dir_frame = 	7

			#Right
			Vector2(0.99,	0.33): # Upish
				dir_frame = 	15

			Vector2(0.99,	-0.33): # Downish
				dir_frame = 	1
	
	# only change if there is a change in dir
	if dir_frame != combat_upper_sprite.frame:
		combat_upper_sprite.frame = 	dir_frame
		combat_arm_back.frame = 		dir_frame
		combat_arm_front.frame = 		dir_frame

## Aiming is a bitch, it has a total of 16 positions for smooth movement.
## TODO remove this ection later
#func combat_weapon_animation():
	## That Vector is an offset to make the calculation origin to be Hoopz torso
	#var mouse_input 	:= ( position + Vector2( 0, -16 ) ).direction_to( get_global_mouse_position() ).snapped( Vector2(0.33,0.33) )
	#var gun_pos 		:= Vector2(18, 0)
	#
	### Many Manual touch ups.
	#var s_frame 		:= combat_weapon.frame
	#var angle 			:= 0.0
	#var height_offset	:= Vector2(0, 4)
	#var _z_index		:= 0
	#
	#match mouse_input:
			## Normal stuff
			#Vector2(0,	-0.99): # Up
				#s_frame = 	4
				#angle = 270
				#_z_index = -1
			#Vector2(-0.99,	0): # Left
				#s_frame = 	8
				#angle = 180
				#height_offset = Vector2.ZERO
			#Vector2(0,	0.99): # Down
				#s_frame = 	12
				#angle = 90
				#height_offset *= -1
			#Vector2(0.99,	0):	 # Right
				#s_frame = 	0
				#angle = 0
				#height_offset = Vector2.ZERO
				#
			## Diagonal stuff
			#Vector2(0.66,	0.66): # Low Right
				#s_frame = 	14
				#angle = 45
				#height_offset *= -1
			#Vector2(-0.66,	0.66): # Low Left
				#s_frame = 	10
				#angle = 135
				#height_offset *= -1
			#Vector2(0.66,	-0.66): # High Right
				#s_frame = 	2
				#angle = 315
			#Vector2(-0.66,	-0.66):	# High Left
				#s_frame = 	6
				#angle = 225
			#
			## Madness
			##Down
			#Vector2(0.33,	0.99): # Rightish
				#s_frame = 	13
				#angle = 60
				#height_offset *= -1
			#Vector2(-0.33,	0.99): # Leftish
				#s_frame = 	11
				#angle = 120
				#height_offset *= -1
			##Up
			#Vector2(0.33,	-0.99): # Rightish
				#s_frame = 	3
				#angle = 300
			#Vector2(-0.33,	-0.99): # Leftish
				#s_frame = 	5
				#angle = 240
			##Left
			#Vector2(-0.99,	0.33): # Downish
				#s_frame = 	9
				#angle = 150
				#height_offset *= -1
			#Vector2(-0.99,	-0.33): # Upish
				#s_frame = 	7
				#angle = 210
				##height_offset *= -1
			##Right
			#Vector2(0.99,	0.33): # Downish
				#s_frame = 	15
				#angle = 30
				#height_offset *= -1
			#Vector2(0.99,	-0.33): # Upish
				#s_frame = 	1
				#angle = 330
			#_:
				##print(mouse_input)
				#pass
				#
	#if combat_weapon.frame != s_frame:
		#combat_weapon.frame 	= s_frame
		#combat_weapon.offset 	= gun_pos.rotated( deg_to_rad(angle) ) + height_offset
		#combat_weapon.z_index	= _z_index
		#
		#combat_weapon_parts.frame 	= combat_weapon.frame
		#combat_weapon_parts.offset 	= combat_weapon.offset
		#combat_weapon_parts.z_index	= combat_weapon.z_index
		#
		#combat_weapon_spots.frame 	= combat_weapon.frame
		#combat_weapon_spots.offset 	= combat_weapon.offset
		#combat_weapon_spots.z_index	= combat_weapon.z_index
		#
		#aim_dir = mouse_input

func combat_weapon_animation() -> void:
	## TODO backport this to o_hoopz.
	# That Vector is an offset to make the calculation origin to be Hoopz torso
	var target_dir 		:= global_position.direction_to( 		-aim_origin.position + get_global_mouse_position() )
	var target_angle	:= global_position.angle_to_point( 		-aim_origin.position + get_global_mouse_position() )
	var mouse_input 	:= target_dir.snapped( Vector2(0.33,0.33) )
	
	## Many Manual touch ups.
	var s_frame 		:= combat_weapon.frame
	var angle 			:= 0.0
	var height_offset	:= Vector2(0, 0) ## DEPRECATED
	var _z_index		:= 0
	
	match mouse_input:
			# Normal stuff
			Vector2(0,	-0.99): # Up
				s_frame = 	4
				angle = 270
				_z_index = -1
			Vector2(-0.99,	0): # Left
				s_frame = 	8
				angle = 180
				_z_index = -1
				
			Vector2(0,	0.99): # Down
				s_frame = 	12
				angle = 90
				#height_offset *= -1
			Vector2(0.99,	0):	 # Right
				s_frame = 	0
				angle = 0
				#height_offset = Vector2.ZERO
				
			# Diagonal stuff
			Vector2(0.66,	0.66): # Low Right
				s_frame = 	14
				angle = 45
				#height_offset *= -1
			Vector2(-0.66,	0.66): # Low Left
				s_frame = 	10
				angle = 135
				#_z_index = -1
				#height_offset *= -1
			Vector2(0.66,	-0.66): # High Right
				s_frame = 	2
				angle = 315
				_z_index = -1
			Vector2(-0.66,	-0.66):	# High Left
				s_frame = 	6
				angle = 225
				_z_index = -1
			
			# Madness
			#Down
			Vector2(0.33,	0.99): # Rightish
				s_frame = 	13
				angle = 60
				height_offset *= -1
			Vector2(-0.33,	0.99): # Leftish
				s_frame = 	11
				angle = 120
				#height_offset *= -1
			#Up
			Vector2(0.33,	-0.99): # Rightish
				s_frame = 	3
				angle = 300
			Vector2(-0.33,	-0.99): # Leftish
				s_frame = 	5
				angle = 240
			#Left
			Vector2(-0.99,	0.33): # Downish
				s_frame = 	9
				angle = 150
				#height_offset *= -1
			Vector2(-0.99,	-0.33): # Upish
				s_frame = 	7
				angle = 210
				#height_offset *= -1
			#Right
			Vector2(0.99,	0.33): # Downish
				s_frame = 	15
				angle = 30
				#height_offset *= -1
			Vector2(0.99,	-0.33): # Upish
				s_frame = 	1
				angle = 330
			_:
				#print(mouse_input)
				pass
				
	## My own slop.
	## Decide where the gun should be placed in relation to the player sprite.
	## Handguns usually are placed on the center, but rifles and heavy weapons are held by the right of the PC.
	
	var new_gun_pos := Vector2.ZERO
	
	# adjust the gun position on hoopz hands. This is more complicated than it sounds, since each gun type has a different position and offset.
	# took 3 days finetuning this. 11/03/25 
	new_gun_pos 	= target_dir * B2_Gun.get_gun_held_dist()
	
	new_gun_pos 	-= B2_Gun.get_gun_shifts().rotated( target_angle )
	new_gun_pos.y 	-= B2_Gun.get_gun_shifts().y * 0.75
	new_gun_pos.y 	*= 0.75
	new_gun_pos.y 	-= 18.0 # was 16.0
	new_gun_pos 	= new_gun_pos.round()
	
	## Decide where the muzzle is.
	gun_muzzle.position = new_gun_pos + Vector2( B2_Gun.get_muzzle_dist(), 0.0 ).rotated( target_angle )
	gun_muzzle.position.y -= 3.0
	
	if combat_weapon.frame != s_frame:
		combat_weapon.frame 			= s_frame
		combat_weapon.position 			= new_gun_pos
		combat_weapon.z_index			= _z_index
		
		combat_weapon_parts.frame 		= s_frame
		combat_weapon_parts.position 	= new_gun_pos
		combat_weapon_parts.z_index		= _z_index
		
		combat_weapon_spots.frame 		= s_frame
		combat_weapon_spots.position 	= new_gun_pos
		combat_weapon_spots.z_index		= _z_index

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if B2_Debug.can_disable_player_col:
			if Input.is_key_pressed(KEY_F4):
				toggle_collision()

func _physics_process(delta: float) -> void:
		
	match curr_STATE:
		STATE.ROLL:
			hoopz_normal_body.speed_scale = max( 1.0, linear_velocity.length() / 70.0 )
			
			if linear_velocity.length() < 10.0:
				# Roooolliiing eeeeennd.
				curr_STATE = STATE.NORMAL
				hoopz_normal_body.animation = "stand"
				hoopz_normal_body.speed_scale = 1.0
				linear_damp = walk_damp
				step_smoke.emitting = false
				hoopz_normal_body.offset.y -= 15
				
		STATE.NORMAL, STATE.AIM:
			if B2_Input.player_has_control:
				## Player has influence over this node
				
				## Play Animations
				if curr_STATE == STATE.NORMAL:
					normal_animation(delta)
				elif  curr_STATE == STATE.AIM:
					_update_held_gun()
					
					combat_walk_animation( delta ) # delta is for the turning animation
					combat_aim_animation()
					combat_weapon_animation()
				else:
					push_warning("Weird state: ", curr_STATE)
				
				## Aiming is complex. Original code takes inertia to move the character, aparently. check scr_player_stance_drawing() line 71
				if Input.is_action_just_pressed("Holster") and can_draw_weapon:
					# check scr_player_setGunHolstered( bool ). This script fucks with the save game data, probably to store some reference data.
					if curr_STATE == STATE.NORMAL and can_shoot:
						# change state, allowing the player to aim.
						B2_Screen.set_cursor_type( B2_Screen.TYPE.BULLS )
						curr_STATE = STATE.AIM
						B2_Sound.play_pick("hoopz_swapguns")
						
					elif curr_STATE == STATE.AIM:
						curr_STATE = STATE.NORMAL
						B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
						B2_Sound.play_pick("hoopz_swapguns")
						
					else:
						# maybe unneeded?
						B2_Sound.play( "sn_pacify" ) # found at scr_player_stance_standard() line 47
						B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
				
				# player shoots its weapon.
				elif Input.is_action_just_pressed("Action") and curr_STATE == STATE.AIM and can_shoot:
					#shuuut. Combat is nonfunctional, so pretend the gun is out of ammo
					# 18/03/25 kinda functional now. u can shoot at least.
					#B2_Sound.play_pick("hoopz_click")
					## CRITICAL other SFX related to guns are here: scr_soundbanks_init() line 850
					shoot_gun()
					
				# player has no permission to draw weapon
				elif Input.is_action_just_pressed("Holster") and not can_draw_weapon:
					B2_Sound.play( "sn_pacify" ) # found at scr_player_stance_standard() line 47
					# if a battle ends and the player still have its weapon drawn, this enables it to holster it.
					curr_STATE = STATE.NORMAL
					B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
				
				# Roll action
				if Input.is_action_just_pressed("Roll") and can_roll:
					# Roooolliiing staaaaart! ...here vvv
					curr_STATE = STATE.ROLL
					linear_damp = roll_damp
					hoopz_normal_body.play( ROLL )
					var roll_dir 	: Vector2
					#var input 		:= Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
					var input 		:= Input.get_vector("Left","Right","Up","Down")
					if input != Vector2.ZERO:
						roll_dir 	= input
					else:
						# Use the mouse to decide the roll direction. (Inverted)
						roll_dir 	= position.direction_to( get_global_mouse_position() ) * -1
					linear_velocity = Vector2.ZERO
					apply_central_force( roll_dir * roll_impulse )
					
					## Reset some vars
					combat_last_direction 	= Vector2.ZERO
					last_direction 			= Vector2.ZERO
					last_input 				= Vector2.ZERO
					combat_last_input 		= Vector2.ZERO
					
					## Fluff
					B2_Sound.play("sn_hoopz_roll")
					step_smoke.emitting = true
					hoopz_normal_body.offset.y += 15
					return
				
				# Take the input from the keyboard / Gamepag and apply directly.
				var move := Input.get_vector("Left","Right","Up","Down")
				velocity = ( walk_speed * delta ) * move
			else:
				velocity = Vector2.ZERO
				
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			apply_central_force( velocity / Engine.time_scale )
