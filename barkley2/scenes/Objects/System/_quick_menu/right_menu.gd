@tool
extends B2_Border

@onready var glamp: Control = $glamp
@onready var status_effects: Control = $status_effects


func flicker( alpha : float ) -> void:
	for c in get_children():
		if c is not B2_Border and c is not B2_Border_Foreground:
			c.self_modulate.a = alpha
	
	for c in glamp.get_children():
		c.self_modulate.a = alpha
		
	for c in status_effects.get_children():
		c.self_modulate.a = alpha
