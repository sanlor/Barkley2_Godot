extends RigidBody2D

const MIN_ANIM_SPEED 	:= 0.4
const MAX_ANIM_SPEED 	:= 2.2
const SPEED 			:= 15000.0

const HEAD_POS_UP		:= Vector2(4,-10)
const HEAD_POS_DW		:= Vector2(9,+07)

@onready var actor_anim: 			AnimatedSprite2D 	= $ActorAnim
@onready var actor_col: 			CollisionShape2D = $ActorCol
@onready var head_position_marker: 	Marker2D 			= $head_position_marker
@onready var flashlight: 			PointLight2D 		= $head_position_marker/flashlight
@onready var bubbles: 				GPUParticles2D 		= $head_position_marker/bubbles
@onready var bubbles_hurt: 			GPUParticles2D 		= $head_position_marker/bubbles_hurt

@onready var boost_timer: Timer = $boost_timer

@export var ui : CanvasLayer

var hurt_sfx := [
	"sn_mg_diving_hit1",
	"sn_mg_diving_hit2",
	"sn_mg_diving_hit3",
	"sn_mg_diving_hit4",
]


var prev_input 			:= Vector2.ZERO

var anim_speed 			:= 0.2

var swim_down_anim 		:= "swim_down_prison"
var swim_up_anim 		:= "swim_up_prison"
var swim_gulp_anim 		:= "gulp_prison"
var swim_drown_anim 	:= "drown_prison"

var curr_head_pos			:= HEAD_POS_UP
var bubble_direction_offset := Vector2.ONE

var is_gulping 			:= false
var is_dying			:= false
var is_teleporting		:= false

func _ready() -> void:
	if B2_CManager.get_BodySwap() == "prison":
		swim_down_anim 		= "swim_down_prison"
		swim_up_anim 		= "swim_up_prison"
		swim_gulp_anim 		= "gulp_prison"
		swim_drown_anim 	= "drown_prison"
	else:
		swim_down_anim 		= "swim_down"
		swim_up_anim 		= "swim_up"
		swim_gulp_anim 		= "gulp"
		swim_drown_anim 	= "drown"
	
	print( B2_CManager.get_BodySwap() )
	actor_anim.frame = 0
	actor_anim.play(swim_down_anim)

func hurt() -> void:
	bubbles_hurt.emitting = true
	bubbles_hurt.restart()
	B2_Sound.play( hurt_sfx.pick_random() )
	ui.oxygen += 10.0

func refill_air() -> void:
	is_gulping = true
	B2_Sound.play( hurt_sfx.pick_random() )
	ui.oxygen = 0.0
	actor_anim.play( swim_gulp_anim )
	await actor_anim.animation_finished
	actor_anim.play( swim_up_anim )
	prev_input = Vector2.INF ## Force input update
	is_gulping = false

func drown() -> void:
	bubbles_hurt.emitting = true
	bubbles_hurt.restart()
		
	is_dying = true
	B2_Sound.play( "sn_mg_diving_toilet_scream" )
	actor_anim.speed_scale = 1.0
	actor_anim.play( swim_drown_anim )
	actor_col.disabled = true
	bubbles.emitting = false

func _physics_process(_delta: float) -> void:
	if is_gulping:
		return
		
	if is_dying:
		return
		
	if is_teleporting:
		return
		
	## Point flashlight torward the mouse position.
	flashlight.look_at( get_global_mouse_position() )
	#print(flashlight.rotation)
	
	## Get current input
	var my_input := Input.get_vector("Left","Right","Up","Down")
	
	## Animation speed stuff
	if my_input:		anim_speed = move_toward(anim_speed, MAX_ANIM_SPEED, 0.06)
	else:				anim_speed = move_toward(anim_speed, MIN_ANIM_SPEED, 0.06)
	actor_anim.speed_scale = anim_speed
	#print(anim_speed)
	#print(my_input)
		
	## Player input stuff
	if my_input.round() != prev_input: # Only apply this condition if the input is brand new.
		if my_input.y < 0:
			actor_anim.play( swim_up_anim )
			curr_head_pos = HEAD_POS_UP
		elif my_input.y > 0:
			actor_anim.play( swim_down_anim )
			curr_head_pos = HEAD_POS_DW
		
		if my_input.x < 0:			actor_anim.flip_h = true; 	bubble_direction_offset = Vector2( -1.0, 1.0 )
		elif my_input.x > 0:		actor_anim.flip_h = false;	bubble_direction_offset = Vector2( +1.0, 1.0 )
		
		## Save previous input
		prev_input = my_input.round()
	
	## Head position stuff
	head_position_marker.position = curr_head_pos * bubble_direction_offset
	
	## Actually move around.
	apply_central_force( my_input * SPEED )
	
	if my_input and Input.is_action_just_pressed("Roll") and boost_timer.is_stopped():
		apply_central_impulse( my_input * SPEED )
		anim_speed = MAX_ANIM_SPEED * 3.0
		
		B2_Sound.play("hoopz_wadestep")
		
		bubbles_hurt.emitting = true
		bubbles_hurt.restart()
		ui.oxygen += 4.0
		boost_timer.start()


func _on_body_entered(body: Node) -> void:
	if body is TileMapLayer:
		#apply_central_impulse( Vector2( Input.get_axis("Left","Right") * -SPEED,  Input.get_axis("Up","Down") * -SPEED ) )
		#print( linear_velocity )
		pass
		## Fuck bouncing around.
