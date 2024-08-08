extends Marker2D
class_name B2_CinemaSpot

@export var cinema_id := 0

func _enter_tree() -> void:
	add_to_group("cinema_spot")
