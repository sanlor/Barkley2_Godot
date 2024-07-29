extends Sprite2D

signal line_pressed

@onready var mouse_area = $mouse_area

var line_type := 0 ## This defines if its going to use the long or short text.
var index := 0

var time_goes_on := 0.0

var is_hovering 	:= false
var is_active 		:= false

func _ready():
	index = get_index() - 2 # 2 is an offset
	if index > 8:
		line_type = 1
	self_modulate.a = 0.0
	show()
		
	mouse_area.mouse_entered.connect( func(): self_modulate.a = 1.0; is_hovering = true )
	mouse_area.mouse_exited.connect( func(): self_modulate.a = 0.0; is_hovering = false )

func _process(delta):
	time_goes_on += delta
	modulate.a = ( sin( time_goes_on * 5.0) + PI ) / TAU
