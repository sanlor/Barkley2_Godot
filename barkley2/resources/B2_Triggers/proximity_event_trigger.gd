extends B2_Event_Root
class_name B2_ProxEventTrigger

# Detect if the player is near, does something if so.

@export var radius_distance := 10.0

var trigger_col : CollisionShape2D

func _enter_tree() -> void:
	var shape 	:= CircleShape2D.new()
	shape.radius = radius_distance
	trigger_col = CollisionShape2D.new()
	trigger_col.shape = shape
	trigger_col.debug_color = Color("b557df6b")
	
	add_child(trigger_col, true)
	body_entered.connect( event_trigger )
