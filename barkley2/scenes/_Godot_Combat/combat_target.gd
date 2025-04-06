@tool
extends AnimatedSprite2D
## Used by enemies to target the player.

@onready var target_line: Line2D = $target_line

@export var my_target	: Vector2
@export var my_source 	: B2_CombatActor
@export var dist		:= 0.0

func destroy() -> void:
	var t := create_tween()
	t.tween_property( self, "modulate", Color.TRANSPARENT, 0.25)
	t.tween_callback( queue_free )

func _physics_process(delta: float) -> void:
	rotation += delta
	
	if my_target:
		global_position = my_target
	
	if my_source:
		var source_dir 	:= global_position.direction_to( my_source.global_position )
		
		target_line.points[0] = my_source.global_position.lerp( global_position, dist )#global_position + (source_dir * 4.0) * dist
		target_line.points[1] = my_source.global_position
