extends Control

const R_TITLE = preload("res://barkley2/rooms/r_title.tscn")

func _ready():
	B2_Music.play( "mus_dancePAX", 0.1 )

func _on_button_pressed():
	get_tree().change_scene_to_packed( R_TITLE )
