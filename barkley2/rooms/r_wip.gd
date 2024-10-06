extends Control

## Little temp scene. Game is not done and was wasnt in the mood od adding a fancy screen.
@onready var button: Button = $Button

@onready var color_rect : ColorRect = $ColorRect

@onready var noise := FastNoiseLite.new()
var noise_x := 0.0
var noise_y := 0.0

func _ready():
	B2_Music.play( "mus_dancePAX" )
	noise.seed = hash("big butts")

func _on_button_pressed():
	button.disabled = true
	B2_RoomXY.warp_to( "r_title" )

func _process(delta):
	noise_x += delta * 10
	noise_y += delta * 10
	color_rect.color.h = (noise.get_noise_2d(noise_x, 0) + 1) / 2
	color_rect.color.s = (noise.get_noise_2d(0, noise_y) + 1) / 2
	#color_rect.color.v = (noise.get_noise_2d(noise_x, noise_y) + 1) / 2
	#print(noise.get_noise_2d(noise_x, noise_y))
