extends Sprite2D

signal line_pressed( index )

@onready var mouse_area = $mouse_area
@onready var cc_palm_reading = $"../.."

var line_type := 0 ## This defines if its going to use the long or short text.
var index := 0

var time_goes_on := 0.0

var is_hovering 	:= false
var is_active 		:= false

func _ready():
	add_to_group( "hand_lines" )
	index = get_index() - 2 # 2 is an offset
	if index > 8:
		line_type = 1
	self_modulate.a = 0.0
	show()
		
	mouse_area.mouse_entered.connect( _mouse_entered )
	mouse_area.mouse_exited.connect( _mouse_exited )

func _mouse_entered():
	if is_active:
		self_modulate.a = 1.0; 
		is_hovering = true
	
func _mouse_exited():
	self_modulate.a = 0.0; 
	is_hovering = false
	
func change_activity( enabled : bool ):
	is_active = enabled

func _process(delta):
	time_goes_on += delta
	modulate.a = 0.5 + ( sin( time_goes_on * 5.0) + 1 ) / 8
	
	if is_active:
		if is_hovering:
			if Input.is_action_just_pressed("Action"):
				cc_palm_reading.clicked_line( index )
				
