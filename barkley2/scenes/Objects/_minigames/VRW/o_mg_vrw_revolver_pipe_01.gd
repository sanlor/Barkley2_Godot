@tool
extends AnimatedSprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var hue : int
var hueSpd

func _ready() -> void:
	animated_sprite_2d.frame = frame + 1
	
	hue = randi_range(0,255);
	hueSpd = (100 + randi_range(0,50) ) * [-1, 1].pick_random()

func _physics_process(delta: float) -> void:
	hue += hueSpd * delta
	if hue < 0: hue += 255;
	if hue > 255: hue -= 255;
	if animated_sprite_2d:
		animated_sprite_2d.modulate = Color.from_hsv(float(hue) / 255.0, 1.0, 1.0)
