extends Sprite2D

const O_PRISON_RIOTER = preload("uid://botbpg4wpe5fd")

@export var o_cinema20 : B2_CinemaSpot
@export var o_cinema21 : B2_CinemaSpot
@export var o_cinema22 : B2_CinemaSpot
@export var o_cinema23 : B2_CinemaSpot

@onready var cinema_spots := [
	o_cinema20,
	o_cinema21,
	o_cinema22,
	o_cinema23,
]

func _ready() -> void:
	for spot : B2_CinemaSpot in cinema_spots:
		var fella : Node2D = O_PRISON_RIOTER.instantiate()
		fella.global_position = spot.global_position
		fella.facing_up = true
		add_sibling.call_deferred( fella, true )
