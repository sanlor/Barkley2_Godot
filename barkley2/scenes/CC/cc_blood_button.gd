extends TextureRect

signal pressed

var is_hovering := false
var is_selected := false
var can_toggle := false
var is_disabled := false

func _ready():
	mouse_entered.connect( func(): 	is_hovering = true )
	mouse_exited.connect( func(): 	is_hovering = false )
	
func _process(_delta):
	if is_hovering and (not is_selected or can_toggle):
		modulate.a = 0.5
		if Input.is_action_just_pressed("Action"):
			if is_disabled:
				return
			is_selected = not is_selected #true
			pressed.emit( self )
	elif is_selected:
		modulate.a = 1.0
	else:
		modulate.a = 0.0
