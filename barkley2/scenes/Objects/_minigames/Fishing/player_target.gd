@tool
extends Marker2D

const POINTS := 8.0

signal updated_position

@onready var reticle: 			Line2D = $player_target/reticle
@onready var player_target: 	Node2D = $player_target

@export var play_area : Node2D
@export_tool_button("make_circle") var make_circle : Callable = _make_circle

var speed 			:= 0.05
var spin_speed 		:= 0.40

var distance_limit := 400.0

func _ready() -> void:
	#my_original_pos = get_parent().global
	pass

func _make_circle() -> void:
	reticle.clear_points()
	
	for i in POINTS:
		var angle := Vector2.LEFT.rotated( TAU * (i / POINTS) )
		reticle.add_point( angle * 10 )

func _physics_process(_delta: float) -> void:
	reticle.rotation -= spin_speed # speen
	
	if not Engine.is_editor_hint():
		if Input.get_vector("Left","Right","Up","Down").round() == Vector2.ZERO:
			spin_speed = move_toward(spin_speed, 0.05, 0.0125) # add a fun spin
			
		if Input.get_axis("Left","Right"):
			var distance_speed_modifier := 1 - (absf(player_target.position.y) / distance_limit) # Modifier used to that the lure has the same rotational speed on every distance
			distance_speed_modifier = clampf(distance_speed_modifier, 0.05, 1.0) # Add a limit for the modifier
			
			rotation = clampf( rotation + Input.get_axis("Left","Right") * (speed * distance_speed_modifier), 0.0, PI / 2.0) # Rotate the pivot
			
			spin_speed = move_toward(spin_speed, 0.2, 0.0125) # add a fun spin
			if randf() > 0.85: updated_position.emit() # Lazy way to reduce the amount of signals
			
		if Input.get_axis("Up","Down"):
			player_target.position.y += Input.get_axis("Up","Down")
			player_target.position.y = clampf( player_target.position.y, -distance_limit, 0.0 ) ## TODO change 400.0
			
			spin_speed = move_toward(spin_speed, 0.2, 0.0125) # add a fun spin
			if randf() > 0.85: updated_position.emit() # Lazy way to reduce the amount of signals
			
