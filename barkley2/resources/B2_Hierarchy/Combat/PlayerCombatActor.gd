@icon("res://barkley2/assets/b2_original/images/merged/icon_parent.png")
extends B2_CombatActor
class_name B2_PlayerCombatActor

## Class used only by Hoopz - Mostly used to organize things.
## WARNING Class incomplete. Its missing a lot of things.

## CHeck B2_Player for the movement code and aiming, damage and such.

# Sprite frame indexes - s_cts_hoopz_stand
const SHUFFLE 		:= "shuffle"
const STAND 		:= "stand"
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

const ROLL			:= "diaper_gooroll"

# Used on the tutorial
const DIAPER_GROUND 	:= "diaper_ground"
const DIAPER_SPANK 		:= "diaper_spank"
const DIAPER_GETUP 		:= "diaper_getup"
const DIAPER_GOOROLL 	:= "diaper_gooroll"
const DIAPER_SPANKCRY 	:= "diaper_spankcry"

@export var hoopz_normal_body: 	AnimatedSprite2D
@export var step_smoke: 		GPUParticles2D

## Sound
var min_move_dist 	:= 1.0
var move_dist 		:= 0.0 # Avoid issues with SFX playing too much during movement. # its a bad sollution, but ist works.

## Animation
var last_direction 	:= Vector2.ZERO
var last_input 		:= Vector2.ZERO
var is_turning 		:= false # Shuffling when turning using the mouse. # check scr_player_stance_diaper() line 142
var turning_time 	:= 1.0

# player direction is influenced by the mouse position
var follow_mouse := true

func add_smoke():
	#for i in randi_range( 1, 2 ):
	step_smoke.emit_particle( Transform2D( 0, step_smoke.position ), Vector2.ZERO, Color.WHITE, Color.WHITE, 2 )
	
func normal_animation(delta : float):
	var input := Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if last_input != input:
			add_smoke()
			
			match input:
				Vector2.UP + Vector2.LEFT:
					hoopz_normal_body.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:
					hoopz_normal_body.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:
					hoopz_normal_body.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:
					hoopz_normal_body.play(WALK_SE)
					
				Vector2.UP:
					hoopz_normal_body.play(WALK_N)
				Vector2.LEFT:
					hoopz_normal_body.play(WALK_W)
				Vector2.DOWN:
					hoopz_normal_body.play(WALK_S)
				Vector2.RIGHT:
					hoopz_normal_body.play(WALK_E)
					
				_: # Catch All
					hoopz_normal_body.play(WALK_S)
					print("Catch all, ", input)
					
	else:
		# player is not moving the character anymore
		hoopz_normal_body.stop()
		move_dist = min_move_dist
		
		var curr_direction : Vector2 = input
		
		if follow_mouse:
			curr_direction = position.direction_to( get_global_mouse_position() ).round()
		
		if curr_direction != last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			hoopz_normal_body.animation = SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle.
				## WARNING Original game doesnt do this.
				#B2_Sound.play_pick("hoopz_footstep")
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			hoopz_normal_body.animation = STAND
			is_turning = false
			
		# change the animation itself.
		match last_direction:
			Vector2.UP + Vector2.LEFT:
				hoopz_normal_body.frame = STAND_NW
			Vector2.UP + Vector2.RIGHT:
				hoopz_normal_body.frame = STAND_NE
			Vector2.DOWN + Vector2.LEFT:
				hoopz_normal_body.frame = STAND_SW
			Vector2.DOWN + Vector2.RIGHT:
				hoopz_normal_body.frame = STAND_SE
				
			Vector2.UP:
				hoopz_normal_body.frame = STAND_N
			Vector2.LEFT:
				hoopz_normal_body.frame = STAND_W
			Vector2.DOWN:
				hoopz_normal_body.frame = STAND_S
			Vector2.RIGHT:
				hoopz_normal_body.frame = STAND_E
				
			_: # Catch All
				hoopz_normal_body.frame = STAND_S
				# print("Catch all, ", input)
				
		# Update var
		last_direction = curr_direction
	# Update var
	last_input = input
