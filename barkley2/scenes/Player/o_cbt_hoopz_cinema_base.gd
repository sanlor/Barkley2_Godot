@icon("res://barkley2/assets/b2_original/images/merged/sHoopzFace.png")
extends  B2_CombatActor
class_name B2_HoopzCombatActor

## Class used by the player actor, during combat. Original system, so it probably wont work well.
## large part of the codebase were ported from B2_PlayerCombatActor, B2_Player
## Mostly, this has functions to control animations and such. Cinema controll will use another class.

signal aim_target_changed
signal move_target_changed

enum STATE{NORMAL,ROLL,AIM}
var curr_STATE := STATE.NORMAL :
	set(s) : 
		curr_STATE = s
		_update_held_gun()

# Sprite frame indexes - s_cts_hoopz_stand
const SHUFFLE 		:= "shuffle"
const STAND 		:= "stand"
const ROLL			:= "hoopz_gooroll"
const STAND_E 		:= 0
const STAND_NE 		:= 1
const STAND_N		:= 2
const STAND_NW		:= 3
const STAND_W		:= 4
const STAND_SW		:= 5
const STAND_S		:= 6
const STAND_SE		:= 7

const WALK_E 		:= "walk_E"
const WALK_NE 		:= "walk_NE"
const WALK_N		:= "walk_N"
const WALK_NW		:= "walk_NW"
const WALK_W		:= "walk_W"
const WALK_SW		:= "walk_SW"
const WALK_S		:= "walk_S"
const WALK_SE		:= "walk_SE"

# Combat Sprite frame indexes
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

@export_category("Normal Sprites")
@export var hoopz_normal_body: 	AnimatedSprite2D

@export_category("Combat Sprites")
@export var combat_upper_sprite 	: AnimatedSprite2D
@export var combat_lower_sprite 	: AnimatedSprite2D
@export var combat_arm_back 		: AnimatedSprite2D
@export var combat_arm_front 		: AnimatedSprite2D
@export var combat_weapon 			: AnimatedSprite2D
@export var combat_weapon_parts		: AnimatedSprite2D
@export var combat_weapon_spots		: AnimatedSprite2D
@export var gun_muzzle				: Marker2D

@export_category("Misc")
@export var step_smoke: 		GPUParticles2D
@onready var ready_label: RichTextLabel = $ready_label


@onready var aim_origin: Marker2D = $aim_origin

## General Animation
var last_direction 				:= Vector2.ZERO
var last_input 					:= Vector2.ZERO
var is_turning 					:= false # Shuffling when turning using the mouse. # check scr_player_stance_diaper() line 142
var turning_time 				:= 1.0
var step_anim_played			:= false
#var last_combat_weapon_frame 	:= 9999

## Combat Animations
#var aim_vector 		:= Vector2.ZERO
var waddle			:= false # If hoopz legs should waddle torward the aiming direction

var combat_last_direction 	:= Vector2.ZERO
var combat_last_input 		:= Vector2.ZERO

## Movement
var external_velocity 	:= Vector2.ZERO ## DEBUG - applyied by the door.
var velocity			:= Vector2.ZERO

var walk_speed			:= 5000000
var roll_impulse		:= 1000000
var walk_damp			:= 10.0
var roll_damp			:= 2.5

## Sound
var min_move_dist 	:= 1.0
var move_dist 		:= 0.0 # Avoid issues with SFX playing too much during movement. # its a bad sollution, but ist works.

## Control stuff
#var is_moving 		:= false
var move_target 	:= movement_vector ## Cinema stuff: Tells where the node should walk to.
var aim_target 		:= movement_vector ## Cinema stuff: Tells where the node should aim to. Can be used with "move_target" to move and aim at the same time.

func _ready() -> void:
	B2_CManager.o_cbt_hoopz = self
	B2_Playerdata.gun_changed.connect( _update_held_gun )
	
	## Fallback setup
	if not is_instance_valid( hoopz_normal_body ):
		hoopz_normal_body = get_node( "hoopz_normal_body" )
	if not is_instance_valid( combat_upper_sprite ):
		hoopz_normal_body = get_node( "combat_upper_sprite" )
	if not is_instance_valid( combat_lower_sprite ):
		hoopz_normal_body = get_node( "combat_lower_sprite" )
	if not is_instance_valid( combat_arm_back ):
		hoopz_normal_body = get_node( "combat_arm_back" )
	if not is_instance_valid( combat_arm_front ):
		hoopz_normal_body = get_node( "combat_arm_front" )
	if not is_instance_valid( combat_weapon ):
		hoopz_normal_body = get_node( "combat_weapon" )
	if not is_instance_valid( combat_weapon_parts ):
		hoopz_normal_body = get_node( "combat_weapon_parts" )
	if not is_instance_valid( combat_weapon_spots ):
		hoopz_normal_body = get_node( "combat_weapon_spots" )
	
	linear_damp = walk_damp
	_change_sprites()
	
	## Reset movement variables.
	move_target 	= Vector2.ZERO
	aim_target 		= Vector2.ZERO

## update the current gun sprite, adding details if needed (spots, parts).
func _update_held_gun() -> void:
	_change_sprites()
	combat_weapon_animation()
	
	if curr_STATE == STATE.AIM:
		var gun := B2_Gun.get_current_gun()
		if gun:
			set_gun( gun.get_held_sprite(), gun.weapon_type )
			
			## Change color.
			var colors := gun.get_gun_colors()
			combat_weapon.modulate = colors[0]
			
			if colors[1]:
				combat_weapon_parts.show()
				combat_weapon_parts.modulate = colors[1]
			else:
				combat_weapon_parts.hide()
				
			if colors[2]:
				combat_weapon_spots.show()
				combat_weapon_spots.modulate = colors[2]
			else:
				combat_weapon_spots.hide()
	
		
func _change_sprites():
	match curr_STATE:
		STATE.NORMAL, STATE.ROLL:
			hoopz_normal_body.show()
			
			## Hide combat related sprites
			combat_lower_sprite.hide()
			combat_upper_sprite.hide()
			combat_arm_back.hide()
			combat_arm_front.hide()
			combat_weapon.hide()
			combat_weapon_parts.hide()
			combat_weapon_spots.hide()
		STATE.AIM:
			hoopz_normal_body.hide()
			
			## Show combat related sprites
			combat_lower_sprite.show()
			combat_upper_sprite.show()
			combat_arm_back.show()
			combat_arm_front.show()
			combat_weapon.show()
			combat_weapon_parts.show()
			combat_weapon_spots.show()

func add_smoke( offset := Vector2.ZERO ) -> void: ## Add a small puff of smoke.
	step_smoke.emit_particle( Transform2D( 0, step_smoke.position + offset ), Vector2.ZERO, Color.WHITE, Color.WHITE, 2 )
	
# Not aiming, rolling and such.
func normal_animation( delta : float ) -> void:
	var input := movement_vector.round() #.snapped( Vector2(0.33,0.33) )
	
	if is_moving: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if last_input != input:
			add_smoke( Vector2( randf_range(-3,3), randf_range(-3,3) ) )
			
			match input:
				Vector2.UP + Vector2.LEFT:		hoopz_normal_body.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:		hoopz_normal_body.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:	hoopz_normal_body.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:	hoopz_normal_body.play(WALK_SE)
					
				Vector2.UP:		hoopz_normal_body.play(WALK_N)
				Vector2.LEFT:	hoopz_normal_body.play(WALK_W)
				Vector2.DOWN:	hoopz_normal_body.play(WALK_S)
				Vector2.RIGHT:	hoopz_normal_body.play(WALK_E)
					
				_: # Catch All
					hoopz_normal_body.play(WALK_S)
					print("Catch all for normal_animation (input), ", input)
				
	else:
		# player is not moving the character anymore
		hoopz_normal_body.stop()
		move_dist = min_move_dist
		
		var curr_direction : Vector2 = input
		
		if curr_direction != last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			hoopz_normal_body.animation = SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle.
				## WARNING Original game doesnt do this.
				B2_Sound.play_pick("hoopz_footstep")
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			hoopz_normal_body.animation = STAND
			is_turning = false
			
		# change the animation itself.
		match last_direction:
			Vector2.UP + Vector2.LEFT:		hoopz_normal_body.frame = STAND_NW
			Vector2.UP + Vector2.RIGHT:		hoopz_normal_body.frame = STAND_NE
			Vector2.DOWN + Vector2.LEFT:	hoopz_normal_body.frame = STAND_SW
			Vector2.DOWN + Vector2.RIGHT:	hoopz_normal_body.frame = STAND_SE
				
			Vector2.UP:		hoopz_normal_body.frame = STAND_N
			Vector2.LEFT:	hoopz_normal_body.frame = STAND_W
			Vector2.DOWN:	hoopz_normal_body.frame = STAND_S
			Vector2.RIGHT:	hoopz_normal_body.frame = STAND_E
				
			_: # Catch All
				hoopz_normal_body.frame = STAND_S
				# print("Catch all for normal_animation (last_dir), ", input)
				
		# Update var
		last_direction = curr_direction
	# Update var
	last_input = input

## Very similar to normal animation control, but with some more details related to the diffferent body parts.
func combat_walk_animation( delta : float) -> void:
	var input := movement_vector #.round()

	if input != Vector2.ZERO: # Player is moving the character while aiming
		if combat_last_input != input:
			# Emit a puff of smoke during the inicial direction change.
			add_smoke( Vector2( randf_range(-3,3), randf_range(-3,3) ) )
			
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
					print("Catch all combat_walk_animation (input), ", input)
		else:
			# player is not moving the character anymore
			combat_lower_sprite.stop()
	
	else: # Player is not moving wile aiming, but can change leg position based on the current aim position.
		var curr_direction : Vector2 = ( aim_target ).round()
		
		if curr_direction != combat_last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a little while.
		if turning_time > 0.0:
			combat_lower_sprite.animation = COMBAT_SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle. 
				## WARNING Original game doesnt do this.
				B2_Sound.play_pick("hoopz_footstep")
				add_smoke( Vector2.ONE.rotated( randf_range(0, TAU) ) * 16.0 ) ## Test
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			combat_lower_sprite.animation = COMBAT_STAND
			is_turning = false
		
		# change the animation frame for the "standing" animation.
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
				print("Catch all for %s combat_walk_animation (combat_last_direction), " % name, combat_last_direction)
				
		# Update var
		combat_last_direction = curr_direction # avoid needless updates
	# Update var
	combat_last_input = input # avoid needless updates
	movement_vector = Vector2.ZERO # avoid needless updates

## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_aim_animation(  ) -> void:
	var target_dir 		:= aim_target
	var mouse_input 	:= target_dir.snapped( Vector2(0.33,0.33) )
	var target_angle	:= snappedf( target_dir.angle(), TAU / 16.0 )
	
	var dir_frame 		= combat_upper_sprite.frame
	
	## Remember, 0.9999999999999 != 1.0
	## Chose what animation frame do use.
	# match mouse_input:
	match int( rad_to_deg(target_angle) ):
		# Normal stuff
		-90:		dir_frame = 		4			# Vector2(0,		-0.99)
		180, -180:	dir_frame = 		8			# Vector2(-0.99,	0)
		90:			dir_frame = 		12			# Vector2(0,		0.99)
		0:			dir_frame = 		0			# Vector2(0.99,		0)
			
		# Diagonal stuff
		45:		dir_frame = 	14 	# Low 		# Right		# Vector2(0.66,		0.66)
		135:	dir_frame = 	10 	# Low 		# Left		# Vector2(-0.66,	0.66)
		-45:	dir_frame = 	2 	# High 		# Right		# Vector2(0.66,		-0.66)
		-135:	dir_frame = 	6 	# High 		# Left		# Vector2(-0.66,	-0.66)
		
		# Madness...
		67:		dir_frame = 	13 	# Down 		# Rightish	# Vector2(0.33,		0.99)
		112:	dir_frame = 	11 	# Down 		# Leftish	# Vector2(-0.33,	0.99)
		-67:	dir_frame = 	3 	# Up 		# Rightish	# Vector2(0.33,		-0.99)
		-112:	dir_frame = 	5 	# Up 		# Leftish	# Vector2(-0.33,	-0.99)
		157:	dir_frame = 	9 	# Left 		# Upish		# Vector2(-0.99,	0.33)
		-157:	dir_frame = 	7 	# Left 		# Downish	# Vector2(-0.99,	-0.33)
		22:		dir_frame = 	15 	# Right 	# Upish		# Vector2(0.99,		0.33)
		-22:	dir_frame = 	1 	# Right 	# Downish	# Vector2(0.99,		-0.33)
		_:
			print( "Weird arms angle: ", int( rad_to_deg(target_angle) ) )
			
	# only change if there is a change in dir
	if dir_frame != combat_upper_sprite.frame:
		combat_upper_sprite.frame = 	dir_frame
		combat_arm_back.frame = 		dir_frame
		combat_arm_front.frame = 		dir_frame

## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_weapon_animation() -> void:
	## TODO backport this to o_hoopz.
	# That Vector is an offset to make the calculation origin to be Hoopz torso
	var target_dir 		:= aim_target # global_position.direction_to( aim_target )
	var mouse_input 	:= target_dir.snapped( Vector2(0.33,0.33) )
	var target_angle	:= snappedf( target_dir.angle(), TAU / 16.0 ) # global_position.angle_to_point( global_position + aim_target )
	
	## Many Manual touch ups.
	var s_frame 		:= combat_weapon.frame
	var _z_index		:= 0
	#print(target_angle)
	
	#match mouse_input: # the var name is a relic of an ancient time. 
	match int( rad_to_deg(target_angle) ):
		# Normal stuff
		-90: 		s_frame = 	4; _z_index = -1 	# Up 				Vector2(0,	-0.99)
		180, -180: 	s_frame = 	8; _z_index = -1 	# Left 				Vector2(-0.99,	0)
		90: 		s_frame = 	12; 				# Down 				Vector2(0,	0.99)
		0: 			s_frame = 	0; 					# Right				Vector2(0.99,	0)

		# Diagonal stuff
		45: 	s_frame = 	14;					# Low Right		Vector2(0.66,	0.66)
		135: 	s_frame = 	10;				 	# Low Left		Vector2(-0.66,	0.66)
		-45: 	s_frame = 	2; _z_index = -1 	# High Right 	Vector2(0.66,	-0.66)
		-135:	s_frame = 	6; _z_index = -1	# High Left		Vector2(-0.66,	-0.66)

		# Madness
		67: 	s_frame = 	13;						# Rightish	# Down			Vector2(0.33,	0.99)
		112: 	s_frame = 	11;						# Leftish	# Down 			Vector2(-0.33,	0.99)
		-67: 	s_frame = 	3; _z_index = -1 		# Rightish	# Up 			Vector2(0.33,	-0.99)
		-112: 	s_frame = 	5; _z_index = -1		# Leftish	# Up 			Vector2(-0.33,	-0.99)
		157: 	s_frame = 	9;						# Downish	# Left 			Vector2(-0.99,	0.33)
		-157: 	s_frame = 	7;						# Upish		# Left 			Vector2(-0.99,	-0.33)
		22: 	s_frame = 	15;						# Downish	# Right			Vector2(0.99,	0.33)
		-22: 	s_frame = 	1;						# Upish		# Right			Vector2(0.99,	-0.33)
		_:
			print( "Weird gun angle: ", int( rad_to_deg(target_angle) ) )
	
	var new_gun_pos := Vector2.ZERO
	## Decide where the gun should be placed in relation to the player sprite.
	## Handguns usually are placed on the center, but rifles and heavy weapons are held by the right of the PC.
	
	# adjust the gun position on hoopz hands. This is more complicated than it sounds, since each gun type has a different position and offset.
	# took 3 days finetuning this. 11/03/25 
	new_gun_pos 	= mouse_input * B2_Gun.get_gun_held_dist()
	
	new_gun_pos 	-= B2_Gun.get_gun_shifts().rotated( target_angle )
	new_gun_pos.y 	-= B2_Gun.get_gun_shifts().y * 0.75
	new_gun_pos.y 	*= 0.75
	new_gun_pos.y 	-= 18.0 # was 16.0
	new_gun_pos 	= new_gun_pos.round()
	
	## Decide where the muzzle is.
	gun_muzzle.position = new_gun_pos + Vector2( B2_Gun.get_muzzle_dist(), 0.0 ).rotated( target_angle )
	gun_muzzle.position.y -= 3.0
	
	combat_weapon.frame 			= s_frame
	combat_weapon.position 			= new_gun_pos
	combat_weapon.z_index			= _z_index
	
	combat_weapon_parts.frame 		= s_frame
	combat_weapon_parts.position 	= new_gun_pos
	combat_weapon_parts.z_index		= _z_index
	
	combat_weapon_spots.frame 		= s_frame
	combat_weapon_spots.position 	= new_gun_pos
	combat_weapon_spots.z_index		= _z_index
		
func _on_combat_actor_entered(body: Node) -> void:
	if body is B2_CombatActor:
		if curr_STATE == STATE.ROLL:
			body.apply_damage( 75.0 ) ## Debug setup ## DEPRECATED
			
# handle step sounds
func _on_hoopz_upper_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0

func _on_combat_lower_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0

## Change the held weapon sprite. Also can change hoopz torso.
## NOTE Check combat_gunwield_drawGun_player_frontHand() and combat_gunwield_drawGun_player_backHand().
## WARNING Missing "Dual" type. TODO
func set_gun( gun_name : String, gun_type : B2_Gun.TYPE ) -> void:
	if combat_weapon.sprite_frames.has_animation( gun_name ):
		combat_weapon.show()
		combat_weapon.animation = gun_name
	else: combat_weapon.hide(); push_warning("Invalid main gun sprite")
		
	if combat_weapon_parts.sprite_frames.has_animation( gun_name ):
		combat_weapon_parts.show()
		combat_weapon_parts.animation = gun_name
	else: combat_weapon_parts.hide()
		
	if combat_weapon_spots.sprite_frames.has_animation( gun_name ):
		combat_weapon_spots.show()
		combat_weapon_spots.animation = gun_name
	else: combat_weapon_spots.hide()
	
	# Save current frame. changing animations resets the frame
	var combat_arm_back_frame 	:= combat_arm_back.frame
	var combat_arm_front_frame 	:= combat_arm_front.frame
	
	# Apply new torso animation
	if [
		B2_Gun.TYPE.GUN_TYPE_REVOLVER,
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
		## Unknown type. Should never hit this.
		breakpoint
		
	# reapply the animation frame
	combat_arm_back.frame 	= combat_arm_back_frame
	combat_arm_front.frame 	= combat_arm_front_frame
	
## NOTE disabled due to changes in the combat manager pipeline
#func shoot_gun() -> void:
	#var gun := B2_Gun.get_current_gun()
	#if gun:
		#ready_label.start_loading( 0.5 )
		#B2_Sound.play_pick( B2_Gun.get_current_gun().get_reload_sound() )
		#await ready_label.finish_loading
		#gun.shoot_gun( get_parent(), combat_weapon.global_position, gun_muzzle.global_position, aim_target )
	#else:
		#push_warning("No Gun???")

## NOTE aim_target is a position in space or a direction?
func aim_gun( _aim_target : Vector2 ) -> void:
	aim_target 			= _aim_target.normalized() #( Vector2(0,-16) + position ).direction_to(_aim_target) * 64
	curr_STATE 			= STATE.AIM

func stop_aiming() -> void:
	move_target 		= aim_target
	movement_vector 	= aim_target.normalized()
	last_input 			= Vector2.ZERO
	last_direction 		= Vector2.ZERO
	curr_STATE 			= STATE.NORMAL

func start_roling( _roll_dir : Vector2, delta : float ) -> void:
	# Roooolliiing staaaaart! ...here vvv
	curr_STATE = STATE.ROLL
	linear_damp = roll_damp
	hoopz_normal_body.play( ROLL )
	var roll_dir 	: Vector2
	var input 		:= Vector2.UP # Input.get_vector("Left","Right","Up","Down")
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
	
	var move := _roll_dir ## CRITICAL Should not be Vector2.ZERO
	velocity = ( walk_speed * delta ) * move

func _physics_process(delta: float) -> void:
	match curr_STATE:
		STATE.ROLL:
			pass
				
		STATE.NORMAL, STATE.AIM:
			## Play Animations
			if curr_STATE == STATE.NORMAL:
				normal_animation( delta )
			elif  curr_STATE == STATE.AIM:
				combat_walk_animation( delta ) # delta is for the turning animation
				combat_aim_animation()
				combat_weapon_animation()
			else:
				push_warning("Weird state: ", curr_STATE)
	
	_process_movement( delta )
