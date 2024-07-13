extends TextureRect

signal pressed

var is_hovering := false
var is_selected := false

func _ready():
	mouse_entered.connect( func(): 	is_hovering = true )
	mouse_exited.connect( func(): 	is_hovering = false )
	
func _process(_delta):
	if is_hovering and not is_selected:
		modulate.a = 0.5
		if Input.is_action_just_pressed("Action"):
			is_selected = true
			pressed.emit( self )
	elif is_selected:
		modulate.a = 1.0
	else:
		modulate.a = 0.0
