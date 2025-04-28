@icon("res://barkley2/assets/b2_original/images/merged/s_blocker_down.png")
extends AnimatedSprite2D
class_name B2_Blocker

@onready var push_area: 			Area2D = $push_area
@onready var actor_blocker: 		StaticBody2D = $actor_blocker

@onready var area_collision: 		CollisionShape2D = $push_area/area_collision
@onready var blocker_collision: 	CollisionShape2D = $actor_blocker/blocker_collision

@export var pushResist 				= 600000; # Pushing resist, higher is more pusback ## was 70

@export var push_vector 	:= Vector2.ZERO
@export var working_anim 	:= animation
@export var working_frame 	:= frame

@export var is_active 		:= false
@export var monitor_pacify 	:= true

func _ready() -> void:
	if not Engine.is_editor_hint():
		change_state( is_active )
		
	modulate = Color.RED
	animation 	= working_anim
	frame 		= working_frame
	
	if monitor_pacify:
		if get_parent() is B2_ROOMS:
			get_parent().pacify_changed.connect( change_state )
		else:
			push_error("Ops, unknown parent.")
	

func change_state( activated : bool ):
	print("%s changed state to %s." % [name, activated])
	if activated:
		activate_block()
	else:
		deactivate_block()

func activate_block():
	show()
	modulate.a = 0.0
	is_active = true
	blocker_collision.disabled = false

func deactivate_block():
	hide()
	modulate.a = 0.0
	is_active = false
	blocker_collision.disabled = true

func push_player( body : RigidBody2D, delta : float ):
	body.external_velocity = push_vector * pushResist * delta

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or not is_active:
		return
	var has_player := false
	if push_area.has_overlapping_bodies():
		var body : Array[Node2D] = push_area.get_overlapping_bodies()
		for b in body:
			if (b is B2_Player) or (b is B2_HoopzCombatActor):
				push_player( b, delta )
				has_player = true
	
	if has_player:
		modulate.a = lerpf(modulate.a, 0.15, 5.0 * delta)
	else:
		modulate.a = lerpf(modulate.a, 0.0, 5.0 * delta)
