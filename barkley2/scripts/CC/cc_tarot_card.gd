extends AnimatedSprite2D

## When I was a kid, I had some pokemon playing cards. I think I had a charizard. No idea what became of them....

@onready var mouse_listener = $mouse_listener

var can_be_selected := false
var is_hovering := false

func _ready():
	mouse_listener.mouse_entered.connect( 	mouse_entered )
	mouse_listener.mouse_exited.connect( 	mouse_exited )
	pass
	
func mouse_entered():
	if can_be_selected:
		is_hovering = true
		frame = 1
	
func mouse_exited():
	if can_be_selected:
		is_hovering = false
		frame = 0
