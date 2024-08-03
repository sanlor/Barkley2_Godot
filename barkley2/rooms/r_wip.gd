extends Control

## Little temp scene. Game is not done and was wasnt in the mood od adding a fancy screen.

const R_TITLE = preload("res://barkley2/rooms/r_title.tscn")
@onready var color_rect : ColorRect = $ColorRect

@onready var noise := FastNoiseLite.new()
var noise_x := 0.0
var noise_y := 0.0

func _ready():
	B2_Music.play( "mus_dancePAX", 0.0 )
	noise.seed = hash("big butts")

func _on_button_pressed():
	get_tree().change_scene_to_packed( R_TITLE )

func _process(delta):
	noise_x += delta * 10
	noise_y += delta * 10
	color_rect.color.h = (noise.get_noise_2d(noise_x, 0) + 1) / 2
	color_rect.color.s = (noise.get_noise_2d(0, noise_y) + 1) / 2
	#color_rect.color.v = (noise.get_noise_2d(noise_x, noise_y) + 1) / 2
	#print(noise.get_noise_2d(noise_x, noise_y))
