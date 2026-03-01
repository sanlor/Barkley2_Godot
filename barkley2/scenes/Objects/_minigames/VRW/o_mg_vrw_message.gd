extends Area2D

const O_MG_VRW_MESSAGE_SCREEN = preload("uid://c5v4xji5k56as")

@onready var message_timer: Timer = $message_timer

@export var message_index := 0

func _on_body_entered(body: Node2D) -> void:
	if body is B2_Player_FreeRoam:
		if message_timer.is_stopped():
			var screen := O_MG_VRW_MESSAGE_SCREEN.instantiate()
			screen.message_index = message_index
			B2_Screen.add_child( screen, true )
			
			message_timer.start( 2.0 )
