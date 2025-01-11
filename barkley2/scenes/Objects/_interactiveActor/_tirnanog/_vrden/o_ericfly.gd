@tool
extends AnimatedSprite2D

var t 					:= 0.0
var speed 				:= 3.0 * randf()
var in_back_of_char 	:= false
var radius 				:= +21.0 * randf_range(0.8, 1.6)
var height				:= -16.0 * randf_range(0.7, 1.3)

@onready var noise		:= FastNoiseLite.new()

func _ready() -> void:
	if randf() <= 0.5:
		speed *= -1.0
		
	noise.seed = hash("bing bing wahoo")
	play("default", randf_range(0.5, 1.1) )
	
func _physics_process(delta: float) -> void:
	t += speed * delta 
	offset.x = sin( t ) * radius + noise.get_noise_1d( t * 10.0 )
	offset.y = height + ( noise.get_noise_1d( t * 15.0 ) * 10.0 ) # makes the fly jittery
	
	if in_back_of_char:
		if round(offset.x) == round(radius):
			z_index = -2
			in_back_of_char = false
	else:
		if round(offset.x) == round(-radius):
			z_index = 0
			in_back_of_char = true
