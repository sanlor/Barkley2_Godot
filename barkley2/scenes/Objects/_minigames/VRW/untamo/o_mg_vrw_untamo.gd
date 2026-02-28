extends B2_Minigame_VRW_Object
class_name B2_Minigame_VRW_Untamo

## Weird script that controls how untamos as spawned.
# NOTE no idea what a untamo is. maybe the player characters in O.O.? why this name?
## Since the map "r_bct_vrw_town02" infinitelly scrolls on the X axis, each untamos has 3 simultaneous sprites to fool the player.
# Check 'o_mg_vrw_untamo' and 'o_mg_vrw_object' and 'o_mg_vrw_untamo_spawner', bitch.

## This is a different behaviour from the original game. I think.
# States:
# STAND -> Untamo does nothing.
# WALK -> Untamo is walking right now.
# CHAT -> Untamo stopped and is typing something.
# LAG -> Untamo is lagging. It is stopped with its walking animation.
enum STATE{STAND,WALK,CHAT,LAG}
var curr_STATE := STATE.STAND

const BASE_SPEED := 100.0

## Timers
@onready var move_timer: 	Timer = $move_timer
@onready var lag_timer: 	Timer = $lag_timer
@onready var chat_timer: 	Timer = $chat_timer

@onready var ActorNav: NavigationAgent2D = $ActorNav


# Check 'o_mg_vrw_object' draw event.
var o_mg_vrw_untamo_body : Array[Node2D]

@export var messages : B2_Minigame_VRW_Messages

var usrNam := "PLACEHOLDER"
var usrCol := Color.HOT_PINK

var my_identity := 0

## Movement stuff
var target_pos			:= Vector2.ZERO
var speed				:= BASE_SPEED
var movement_vector 	:= Vector2.ZERO

func _ready() -> void:
	var index_head 	:= randi_range( 0,7		);
	var index_eyes 	:= randi_range( 0,14	);
	var index_hair 	:= randi_range( 0,14	);
	var index_mouth := randi_range( 0,14	);
	var index_nose 	:= randi_range( 0,14	);
	var bodCol 		:= Color.from_hsv(randf(), 1.0, 1.0);
	var heaCol 		:= Color.from_hsv(randf(), 1.0, 1.0);
	var haiCol 		:= Color.from_hsv(randf(), 1.0, 1.0);
	
	usrCol = Color.from_hsv( randf(), 1.0, 1.0 );
	
	## Clone object
	var child : B2_Minigame_VRW_Untamo_Body = get_children().front()
	assert( child, "More than one child is not expected. Check this shit out, homie." )
	o_mg_vrw_untamo_body = B2_Minigame_VRW_Object.dew_it( child )
	o_mg_vrw_untamo_body.append( child )
	
	## Set username for this ped.
	usrNam = B2_Minigame_VRW_Messages.scr_vrw_username()
		
	await get_tree().process_frame
	for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
		body.set_head( 			index_head )
		body.set_eyes( 			index_eyes )
		body.set_hair( 			index_hair )
		body.set_mouth( 		index_mouth )
		body.set_nose( 			index_nose )
		body.set_body_color( 	bodCol )
		body.set_head_color( 	heaCol )
		body.set_hair_color( 	haiCol )
	
	set_new_target()
	
func set_new_target() -> void:
	var random_x := randi_range(0, 1440);
	if randf() > 0.4: # Randomly, reduce the size of the distance traveled.
		random_x /= 2
	var random_y := randi_range(148, 288 - 16);
	target_pos = Vector2( random_x, random_y )
	ActorNav.target_position = target_pos
	
	## vary the walking speed
	speed = BASE_SPEED * randf_range(0.25, 1.25)
	
	change_STATE( STATE.WALK )
	
func change_STATE( state : STATE ) -> void:
	curr_STATE = state
	match curr_STATE:
		STATE.WALK:
			for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
				body.play_anim()
				body.hide_emote()
			modulate.a = 1.0
		STATE.STAND:
			for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
				body.stop_anim()
				body.hide_emote()
			modulate.a = 1.0
			velocity = Vector2.ZERO
		STATE.CHAT:
			for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
				body.stop_anim()
			modulate.a = 1.0
			velocity = Vector2.ZERO
		STATE.LAG:
			speed = 0.0
			velocity = Vector2.ZERO
	
func animations() -> void:
	for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
		body.flip( movement_vector.x < 0 )
	
func _physics_process(_delta: float) -> void:
	match curr_STATE:
		STATE.LAG:
			modulate.a = randi_range(0,1)
			
		STATE.WALK:
			# Do not query when the map has never synchronized and is empty.
			if NavigationServer2D.map_get_iteration_id( ActorNav.get_navigation_map() ) == 0:
				return
				
			# Finish navigation
			if ActorNav.is_target_reached() or ActorNav.is_navigation_finished():
				target_reached()
				return
			
			var next_path_position: Vector2 = ActorNav.get_next_path_position()
			var new_velocity: Vector2 = global_position.direction_to( next_path_position ) * ( speed / lerpf(1.0, Engine.time_scale, 0.25) ) # This "Engine.time_scale" is used when the game is FFWDing. Actors used to have issues reaching the waypoint without this.
			
			if ActorNav.avoidance_enabled:			ActorNav.set_velocity(new_velocity)
			else:									_on_actor_nav_velocity_computed(new_velocity)
			
			## Randomly, stop moving and do something else.
			if randf() > 0.995:
				target_reached()
			
			## Set movement vector
			if movement_vector != new_velocity.sign():
				movement_vector = new_velocity.sign()
			
				## Change animation
				animations()

func type_message() -> void:
	change_STATE(STATE.CHAT)
	for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
		body.show_emote( B2_Minigame_VRW_Untamo_Body.EMOTE.SPEAK )
	chat_timer.start( randf_range(1.0,5.0) )
	
func emote() -> void:
	change_STATE(STATE.CHAT)
	for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
		body.show_emote( 	[
								B2_Minigame_VRW_Untamo_Body.EMOTE.SMILEY,
								B2_Minigame_VRW_Untamo_Body.EMOTE.HEART,
								B2_Minigame_VRW_Untamo_Body.EMOTE.REAL,
							].pick_random()
						)
	chat_timer.start( randf_range(0.5, 2.0) )
	
func lag_out() -> void:
	change_STATE(STATE.LAG)
	lag_timer.start( randf_range(0.5, 10.0) )

## The untamo reached its target. What now:
func target_reached() -> void:
	change_STATE(STATE.STAND) ## First, change its state to standing.
	
	var r := randf() 				# Roll them dice
	if r < 0.5:						# immediatelly move to another place
		set_new_target() 
	elif r >= 0.5 and r < 0.75:		# Type or emote something
		if randf() >= 0.5:	type_message()
		else:				emote()
	else:							# Do nothing for a while
		move_timer.start( randf_range(0.1, 3.0) )

func _on_actor_nav_velocity_computed(safe_velocity: Vector2) -> void:
	match curr_STATE:
		STATE.WALK:
			velocity = safe_velocity
			move_and_slide()

func _on_chat_timer_timeout() -> void:
	target_reached()

func _on_lag_timer_timeout() -> void:
	target_reached()

func _on_move_timer_timeout() -> void:
	target_reached()
