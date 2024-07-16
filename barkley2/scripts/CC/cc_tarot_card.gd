extends AnimatedSprite2D

## When I was a kid, I had some pokemon playing cards. I think I had a charizard. No idea what became of them....

@onready var mouse_listener = $mouse_listener

signal card_pressed

var can_be_selected := false
var is_hovering := false

func _ready():
	mouse_listener.mouse_entered.connect( 	mouse_entered )
	mouse_listener.mouse_exited.connect( 	mouse_exited )
	pass
	
func _process(_delta):
	if can_be_selected:
		if Input.is_action_just_pressed("Action"):
			if is_hovering:
				card_pressed.emit()
				mouse_exited()
				can_be_selected =  false
	
func mouse_entered():
	if can_be_selected:
		is_hovering = true
		frame = 1
	
func mouse_exited():
	if can_be_selected:
		is_hovering = false
		frame = 0
