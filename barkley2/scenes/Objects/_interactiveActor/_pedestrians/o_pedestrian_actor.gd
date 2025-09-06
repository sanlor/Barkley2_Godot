@icon("res://barkley2/assets/b2_original/images/merged/s_pedestrianIcon.png")
extends RigidBody2D
class_name B2_Pedestrian

const O_SHADOW 						= preload("uid://c54kloot7bcu2")
const O_ENTITY_INDICATOR_GOSSIP 	= preload("res://barkley2/scenes/Objects/_interactiveActor/_pedestrians/o_entity_indicatorGossip.tscn")

# List of sprites that the peds can use.
const PED_SPRITES := [
	"res://barkley2/resources/B2_Pedestrians/s_ped_01.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_02.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_03.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_04.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_05.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_06.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_07.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_08.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_09.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_10.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_11.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_12.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_13.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_14.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_15.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_16.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_18.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_20.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_22.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_24.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_26.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_28.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_30.tres",
	]

@onready var actor_anim: 	AnimatedSprite2D = $ActorAnim
@onready var actor_nav: 	NavigationAgent2D = $ActorNav
@onready var gossip_timer: Timer = $GossipTimer

## DEBUG
@export_category("Debug")
@export var debug_move_finish 				:= false ## Print some debug shit.
@export var debug_check_movement_vector 	:= false ## Draw lines to show the current movement vector.

## Pedestrian stuff
var ped_exits 		:= []
var ped_entrances 	:= []
var ped_waypoints 	:= []


var gossip_pool 		:= []
var ped_can_gossip 		:= false
var gossip_area 		:= 0
var my_gossip 			:= 0
var ped_timer 			:= 55.0

var heading_to_waypoint := false

signal destination_reached
signal set_played

@export_category("Actor Stuff")
@export var cast_shadow		:= true
@export var ActorAnim 		: AnimatedSprite2D
@export var has_collision 	:= true
@export var ActorCol 		: CollisionShape2D
@export var can_move_around	:= true
@export var ActorNav		: NavigationAgent2D

var my_shadow 		: Sprite2D

var is_moving 			:= false
var playing_animation 	:= "stand"

var destination 			:= Vector2.ZERO
var destination_path 		:= PackedVector2Array()
var destination_offset 		:= Vector2.ZERO # Vector2(8,8)

# used to define the movement sprite
var movement_vector 		:= Vector2.ZERO :
	set(m):
		movement_vector = m
		
var real_movement_vector 	:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

var velocity				:= Vector2.ZERO

@export_category("Movement Stuff")
## Speed stuff
var speed_multiplier 		:= 5000.0 # was 900.0
@export var speed_slow 		:= 12.0 # was 1.5
@export var speed_normal 	:= 20.0 # was 2.5
@export var speed_fast 		:= 35.0 # was 5.0
var speed 					:= speed_normal

@export_category("Pathfinding")
@export var path_desired_distance 	= 4.0
@export var target_desired_distance = 4.0

@export_category("Animation")
@export var animation_speed 	:= 1.5			## Multiplier used on playset animations

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if not get_parent() is B2_ROOMS:
		return
	
	ped_exits 		= get_tree().get_nodes_in_group("ped_exit")
	ped_entrances 	= get_tree().get_nodes_in_group("ped_entrance")
	ped_waypoints 	= get_tree().get_nodes_in_group("ped_waypoint")
	
	## Gossip pool setup
	#region Gossip
	gossip_pool.resize( 8 )
	for i in gossip_pool.size():
		gossip_pool[i] = Array()
		gossip_pool[i].resize( 10)
	
	## TNN ##
	gossip_pool[0][0] = "Go North from Gilberts Peak";
	gossip_pool[0][1] = "Look for the Hammer of Zoldar";
	gossip_pool[0][2] = "Golden Fish has mystical power";
	gossip_pool[0][3] = "Talk to people for clues and hints";
	gossip_pool[0][4] = "Friends and Foes get stronger during the night";
	gossip_pool[0][5] = "Go to Father Giuseppes church for sanctuary";
	gossip_pool[0][6] = "I smell something... dank. Could it be...?";
	gossip_pool[0][7] = "Where there is smoke... there is fire";
	gossip_pool[0][8] = "Remember this, youngster: Still waters run deep...";
	gossip_pool[0][9] = "Rock the Vote";

	## Brain City ##
	gossip_pool[1][0] = "I'm proud to be a Braincinian";
	gossip_pool[1][1] = "Where's my son? Have you seen my baby boy?!";
	gossip_pool[1][2] = "I'm a resolute coffee drinker, full of beans";
	gossip_pool[1][3] = "A neurodeck in the head is worth ten in the belfry";
	gossip_pool[1][4] = "Cyberdwarf is a scam, don't believe the hype";
	gossip_pool[1][5] = "The tallest tower holds the deepest secrets";
	gossip_pool[1][6] = "Gilberts Peak eludes me";
	gossip_pool[1][7] = "Fortune favors the bald";
	gossip_pool[1][8] = "Search south of Castle Duffrey";
	gossip_pool[1][9] = "My next upgrade is going to be my tendons";

	## Al-akihabara ##
	gossip_pool[2][0] = "Ugh... I'm so parched...";
	gossip_pool[2][1] = "Water... I need... Water...";
	gossip_pool[2][2] = "Ungh... It's so hot in here...";
	gossip_pool[2][3] = "Please, someone, anyone... Give me nectar!";
	gossip_pool[2][4] = "If only us dwarfs wouldn't need to drink...";
	gossip_pool[2][5] = "Every word pains my parched throat";
	gossip_pool[2][6] = "My sore throat beckons for water...";
	gossip_pool[2][7] = "So thirsty...";
	gossip_pool[2][8] = "Thirst is the real enemy of us dwarfs...";
	gossip_pool[2][9] = "Hattori Temple appears only when the moon is full";

	## Ys-Kolob ## Esperanto ##
	gossip_pool[3][0] = "Ĉiuj gloro al la urbestro de la Manĝtuloj";
	gossip_pool[3][1] = "Bonvenon al Ys-Kolob, amiko";
	gossip_pool[3][2] = "Beware la fantomoj de Kastelo Duffrey";
	gossip_pool[3][3] = "Birdo en la ĉapelo valoras du en la sonorilejo";
	gossip_pool[3][4] = "Mi sentas komploto mortigi ĉiuj Manĝtuloj";
	gossip_pool[3][5] = "Pekoj de la patro neston profunde en la itala";
	gossip_pool[3][6] = "Don de la Vega estas ne kiu li ŝajnas";
	gossip_pool[3][7] = "Se nur sinjoro Passepartout estis ankoraŭ tie...";
	gossip_pool[3][8] = "La fosaĵoj teni kaŝitan trezoron";
	gossip_pool[3][9] = "La knabo faris de betulo... Ĉu li vere mortas?";

	## Triskelion
	for i in 10:
		gossip_pool[4][i] = "I like looking at the water.";

	## Triskelion Bar
	gossip_pool[5][0] = "*BURP*";
	gossip_pool[5][1] = "*SLURP*";
	gossip_pool[5][2] = "*HIC*";
	gossip_pool[5][3] = "*HORK*";
	gossip_pool[5][4] = "*HOOT*";
	gossip_pool[5][ 5] = "*COUGH*";
	gossip_pool[5][6] = "*HOLLER*";
	gossip_pool[5][7] = "Fuck you!";
	gossip_pool[5][8] = "*MUNCH*";
	gossip_pool[5][9] = "*CRUNCH*";

	## Triskelion ghetto
	gossip_pool[6][0] = "I ain't sayin' anythin'";
	gossip_pool[6][1] = "Please... One more grape...";
	gossip_pool[6][2] = "Do you have a noose I could borrow?";
	gossip_pool[6][3] = "The cock-sucker guards won't let me in the city";
	gossip_pool[6][4] = "I wonder where the ladders go...";
	gossip_pool[6][5] = "...What!";
	gossip_pool[6][6] = "What a load of horse patoot!";
	gossip_pool[6][7] = "They call me Il Pauper.";
	gossip_pool[6][8] = "Greetings, saahib.";
	gossip_pool[6][9] = "I'm afraid of the night.";

	## Industrial Park ##
	gossip_pool[7][0] = "Great POWER is northwest";
	gossip_pool[7][1] = "The dankest of Swamps lie south";
	gossip_pool[7][2] = "Fary's are racist";
	gossip_pool[7][3] = "Stay clear of chups";
	gossip_pool[7][4] = "Respect the rules...";
	gossip_pool[7][5] = "One man's piece of shit is another man's gold";
	gossip_pool[7][6] = "Use anesthetics to capture live enemies";
	gossip_pool[7][7] = "Cybergremlins are BULLSHIT!";
	gossip_pool[7][8] = "Knowledge is power";
	gossip_pool[7][9] = "Sepideh's machine will save us all";
#endregion
	
	_setup_actor()
	
	if ped_waypoints.is_empty():
		push_error("Map has no Waypoints!!")
		return
		
	# Randomish speed for each ped
	speed *= randf_range(0.85, 1.15)
	
		
	change_costume()
	is_moving = true
	heading_to_waypoint = true
	pedestrians_destiny()
	
## Stolen from B2_Actor script.
func _setup_actor():
	if not is_instance_valid( ActorAnim ):
		ActorAnim 	= get_node( "ActorAnim" )
	if not is_instance_valid( ActorCol ):
		ActorCol 	= get_node( "ActorCol" )
	if can_move_around:
		if not is_instance_valid( ActorNav):
			ActorNav	= get_node( "ActorNav" )
		if is_instance_valid( ActorNav ): # Setup NavigationAgent2D
			ActorNav.path_desired_distance 			= path_desired_distance
			ActorNav.target_desired_distance 		= target_desired_distance
			ActorNav.velocity_computed.connect( Callable(_on_velocity_computed) )
			ActorNav.debug_enabled = B2_Debug.PATHFIND_SHOW
		else:
			push_error( "ActorNav is invalid for node %s." % name )
	
	if is_instance_valid( ActorAnim ):
		ActorAnim.use_parent_material = true ## Shader stuff
	else:
		push_error( "ActorAnim is invalid for node %s." % name )
		
	if not is_instance_valid( ActorCol ):
		push_error( "ActorCol is invalid for node %s." % name )
		
	if cast_shadow:
		my_shadow = O_SHADOW.instantiate()
		add_child( my_shadow, true)
	
## Peds behavior, moving to a waypoint or an exit.
## NOTE Bug here. Peds can get confused when entrying and exiting the map. the spawn position of the entry is wrong. Too lazy to fix it.
func pedestrians_destiny():
	# ped was moving to a waypoint
	if heading_to_waypoint:
		if randi_range( 0, 99 ) >= 15:
			if ped_waypoints.is_empty():
				push_error("Map has no Waypoints!!")
				breakpoint
				return
			heading_to_waypoint = true
			is_moving = true
			# get a new random waypoint
			ActorNav.set_target_position( ped_waypoints.pick_random().position )
		else:
			if ped_exits.is_empty():
				push_error("Map has no exits!!!")
				return
			# time to go home
			heading_to_waypoint = false
			is_moving = true
			ActorNav.set_target_position( ped_exits.pick_random().position )
	else:
		if ped_entrances.is_empty():
			push_error("Map has no entrances!!")
			breakpoint
			return
			
		if ped_waypoints.is_empty():
			push_error("Map has no Waypoints!!")
			breakpoint
			return
				
		# ped was moving to an exit.
		var new_pos := ped_entrances.pick_random().position as Vector2
		heading_to_waypoint = true
		is_moving = false
		var ped_tween := create_tween()
		
		ped_tween.tween_property( self, "modulate:a", 0.0, 0.5 )
		ped_tween.tween_interval( randf_range( 0, 2.0 ) )
		ped_tween.tween_callback( set.bind("position", new_pos ) )
		ped_tween.tween_callback( change_costume )
		ped_tween.tween_property( self, "modulate:a", 1.0, 0.5 )
		await ped_tween.finished
		
		is_moving = true
		playing_animation = ""
		position = new_pos 
		
		ActorNav.set_target_position( ped_waypoints.pick_random().position )
	
func change_costume():
	var costume : SpriteFrames = load( PED_SPRITES.pick_random() )
	ActorAnim.sprite_frames = costume
	
	#actor_anim.stop()
	#actor_anim.animation = "stand"
	#actor_anim.frame = 0
	
	# o_pedestrianActor - create - line 61
	if randi_range(0, 99) <= 30:
		ped_can_gossip = true
		my_gossip = randi_range( 0, 9 )
		speed *= randf_range( 0.85, 1.15 )
	
	movement_vector 		= Vector2.ZERO
	last_movement_vector 	= Vector2.ZERO
	
func ped_animation(): # Apply animation when the character is moved by a cinema script.
	#if movement_vector != last_movement_vector:
	var _dir := "stand"
			
	match movement_vector:
		Vector2.UP + Vector2.LEFT: 		_dir = "walk_sideways"
		Vector2.UP + Vector2.RIGHT: 	_dir = "walk_sideways"
		Vector2.DOWN + Vector2.LEFT: 	_dir = "walk_sideways"
		Vector2.DOWN + Vector2.RIGHT: 	_dir = "walk_sideways"
			
		Vector2.UP: 		_dir = "walk_S" ## NOTE I goofed during the convertion proccess. N is S and S is N. No way im converting everything again.
		Vector2.LEFT: 		_dir = "walk_sideways"
		Vector2.DOWN: 		_dir = "walk_N" ## NOTE I goofed during the convertion proccess. N is S and S is N. No way im converting everything again.
		Vector2.RIGHT: 		_dir = "walk_sideways"
		
	if movement_vector.x < 0:
		ActorAnim.flip_h = true
	else:
		ActorAnim.flip_h = false
		
	if playing_animation != _dir:
		ActorAnim.play(_dir, animation_speed)
		playing_animation = _dir
		
func _physics_process(_delta: float) -> void:
	if not gossip_timer.is_stopped() or not is_moving:
		return
		
	if debug_check_movement_vector or B2_Debug.ENABLE_MOVEMENT_VECTOR_VISUALIZE:
		queue_redraw()
		
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id( ActorNav.get_navigation_map() ) == 0:
		return
		
	# Finish navigation
	if ActorNav.is_target_reached():
		is_moving = false
		
		if debug_move_finish:	print("%s finished moving." % name)
			
		destination_reached.emit()
		pedestrians_destiny()
		return
	
	if ActorNav.is_navigation_finished():
		return
		
	var next_path_position: Vector2 = ActorNav.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to( next_path_position ) * ( speed * speed_multiplier ) 
	
	# This "Engine.time_scale" is used when the game is FFWDing. Actors used to have issues reaching the waypoint without this.
	#new_velocity /= Engine.time_scale
	
	if ActorNav.avoidance_enabled:
		ActorNav.set_velocity( new_velocity )
	else:
		_on_velocity_computed( new_velocity )
			
func _draw() -> void:
	if debug_check_movement_vector or B2_Debug.ENABLE_MOVEMENT_VECTOR_VISUALIZE:
		draw_line(Vector2.ZERO, real_movement_vector * 32, Color.HOT_PINK)
		draw_line(Vector2.ZERO, velocity.normalized() * 48, Color.YELLOW)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	apply_central_force( velocity )
	
	movement_vector 		= velocity.normalized().round()
	ped_animation()
	last_movement_vector 	= movement_vector


func _on_body_entered(body: Node) -> void:
	if gossip_timer.is_stopped():
		if body is B2_PlayerCombatActor and ped_can_gossip:
			gossip_timer.start( ped_timer / 10.0 ) ## DEBUG
			actor_anim.stop()
			actor_anim.animation = "stand"
			actor_anim.frame = 0
			#if ped_can_gossip:
			var gos = O_ENTITY_INDICATOR_GOSSIP.instantiate()
			gos.position.y -= 64.0
			gos.text = gossip_pool[gossip_area][my_gossip]
			add_child( gos, true )
			
			playing_animation		= "stand"
			velocity				= Vector2.ZERO
			movement_vector 		= Vector2.ZERO
			last_movement_vector 	= Vector2.ZERO
