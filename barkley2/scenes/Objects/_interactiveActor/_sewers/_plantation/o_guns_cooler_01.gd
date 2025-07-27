extends B2_EnvironInteractive

@export var destination_gun : B2_CinemaSpot

func _ready() -> void:
	pass
	
func execute_event_user_0() -> void:
	B2_Sound.play("catfishshield_netthrow")
	B2_Drop.create_drops_from_db( "turald free", position, destination_gun.position + Vector2.RIGHT.rotated( randf_range(-PI, PI) ) * 25.0, randf_range(0.85,1.25) )
	#push_warning("Gun drop not set yet.")
	
func execute_event_user_1() -> void:
	## Does nothing, basically.
	pass
