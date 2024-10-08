extends CharacterBody2D
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
# Missing roll
# Missing "Wading wave" (No idea what it is)

# Handle costume / body changes
enum BODY{HOOPZ,MATTHIAS,GOVERNOR,UNTAMO,DIAPER,PRISON}
@onready var curr_BODY := BODY.HOOPZ :
	set( body ):
		curr_BODY = body
		_load_sprite_frames()

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

# Used on the tutorial
const DIAPER_GROUND 	:= "diaper_ground"
const DIAPER_SPANK 		:= "diaper_spank"
const DIAPER_GETUP 		:= "diaper_getup"
const DIAPER_GOOROLL 	:= "diaper_gooroll"
const DIAPER_SPANKCRY 	:= "diaper_spankcry"


@onready var hoopz_upper_body: 	AnimatedSprite2D = $hoopz_upper_body
@onready var hoopz_lower_body: 	AnimatedSprite2D = $hoopz_lower_body

@onready var step_smoke: 		GPUParticles2D = $step_smoke


var sprite_map_upper := {
	BODY.HOOPZ 		: preload("res://barkley2/resources/Player/hoopz_upper_body_hoopz.tres"),
	BODY.DIAPER 	: preload("res://barkley2/resources/Player/hoopz_upper_body_diaper.tres")
}
var sprite_map_lower := {
	BODY.HOOPZ 		: preload("res://barkley2/resources/Player/hoopz_upper_body_hoopz.tres"),
	BODY.DIAPER 	: preload("res://barkley2/resources/Player/hoopz_upper_body_diaper.tres")
}

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

# Movement
var external_velocity := Vector2.ZERO ## DEBUG - applyied by the door.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#B2_Playerdata.player_node = self
	B2_Cinema.o_hoopz = self
	B2_Input.player_follow_mouse.connect( func(state): follow_mouse = state )
	
	pass # Replace with function body.

func _load_sprite_frames():
	hoopz_upper_body.sprite_frames = sprite_map_upper[ curr_BODY ]
	hoopz_lower_body.sprite_frames = sprite_map_lower[ curr_BODY ]
	
func add_smoke():
	#for i in randi_range( 1, 2 ):
	step_smoke.emit_particle( Transform2D( 0, step_smoke.position ), Vector2.ZERO, Color.WHITE, Color.WHITE, 2 )
	
func animation(delta : float):
	var input := Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if last_input != input:
			add_smoke()
			
			match input:
				Vector2.UP + Vector2.LEFT:
					hoopz_upper_body.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:
					hoopz_upper_body.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:
					hoopz_upper_body.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:
					hoopz_upper_body.play(WALK_SE)
					
				Vector2.UP:
					hoopz_upper_body.play(WALK_N)
				Vector2.LEFT:
					hoopz_upper_body.play(WALK_W)
				Vector2.DOWN:
					hoopz_upper_body.play(WALK_S)
				Vector2.RIGHT:
					hoopz_upper_body.play(WALK_E)
					
				_: # Catch All
					hoopz_upper_body.play(WALK_S)
					print("Catch all, ", input)
					
	else:
		# player is not moving the character anymore
		hoopz_upper_body.stop()
		move_dist = min_move_dist
		
		var curr_direction : Vector2 = input
		
		if follow_mouse:
			curr_direction = position.direction_to( get_global_mouse_position() ).round()
		
		if curr_direction != last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			hoopz_upper_body.animation = SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle.
				B2_Sound.play_pick("hoopz_footstep")
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			hoopz_upper_body.animation = STAND
			is_turning = false
			
		# change the animation itself.
		match last_direction:
			Vector2.UP + Vector2.LEFT:
				hoopz_upper_body.frame = STAND_NW
			Vector2.UP + Vector2.RIGHT:
				hoopz_upper_body.frame = STAND_NE
			Vector2.DOWN + Vector2.LEFT:
				hoopz_upper_body.frame = STAND_SW
			Vector2.DOWN + Vector2.RIGHT:
				hoopz_upper_body.frame = STAND_SE
				
			Vector2.UP:
				hoopz_upper_body.frame = STAND_N
			Vector2.LEFT:
				hoopz_upper_body.frame = STAND_W
			Vector2.DOWN:
				hoopz_upper_body.frame = STAND_S
			Vector2.RIGHT:
				hoopz_upper_body.frame = STAND_E
				
			_: # Catch All
				hoopz_upper_body.frame = STAND_S
				# print("Catch all, ", input)
				
		# Update var
		last_direction = curr_direction
	# Update var
	last_input = input
	
func _physics_process(delta: float) -> void:
	if B2_Input.player_has_control:
		## Player has influence over this node
		var move := Input.get_vector("Left","Right","Up","Down")
		velocity = ( 5000 * delta ) * move
	else:
		velocity = Vector2.ZERO
	velocity += external_velocity
	external_velocity = Vector2.ZERO # Reset Ext velocity
	move_and_slide()
	animation(delta)
	
# handle step sounds
func _on_hoopz_upper_body_frame_changed() -> void:
	if hoopz_upper_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_upper_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
			
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is B2_InteractiveActor:
		body.is_player_near = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is B2_InteractiveActor:
		body.is_player_near = false
