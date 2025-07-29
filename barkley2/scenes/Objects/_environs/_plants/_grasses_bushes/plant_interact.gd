extends AnimatedSprite2D

## Too lazy to make this a class.

@export var is_on_land 				:= true
@export var sound 					:= ""
@export var shrink_on_collision 	:= false;
@export var slow_on_collision 		:= false;

@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var player_contact 	:= false
var player_node 	: Node2D

func _ready() -> void:
	if is_on_land:
		frame = randi_range(0,5)
	else:
		frame = randi_range(6,11)
	
	if sound:
		audio_stream_player_2d.stream = load( B2_Sound.get_sound(sound) )
	else:
		push_warning("No sound set.")
		
	if slow_on_collision:
		area_2d.linear_damp_space_override = Area2D.SPACE_OVERRIDE_COMBINE
		area_2d.linear_damp = 0.5

func _physics_process(_delta: float) -> void:
	if player_contact:
		if player_node:
			rotation = lerp(rotation, player_node.position.angle_to_point(position), 0.2 ) * 0.35
	else:
		rotation = lerp(rotation, 0.0, 0.2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is B2_Player:
		if shrink_on_collision:
			var t = create_tween()
			t.tween_property(self, "scale", Vector2.ONE * 0.85, 0.25)
		player_contact = true
		player_node = body
		if sound: audio_stream_player_2d.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is B2_Player:
		if shrink_on_collision:
			var t = create_tween()
			t.tween_property(self, "scale", Vector2.ONE, 0.25)
		player_contact = false
		player_node = null
		if sound: audio_stream_player_2d.play()
