extends Node
## Node that controls how the spotlight work.

# Podium lights
@onready var light_control: 	Node2D 			= $"../light_control"

# Dance floor lights
@onready var spotlight: 		PointLight2D 	= $"../spotlight"
@onready var spotlight_2: 		PointLight2D 	= $"../spotlight2"
@onready var spotlight_3: 		PointLight2D 	= $"../spotlight3"

func bootyslayer_lights() -> void:
	light_control.enabled = true
	light_control.flash_enabled = true
	light_control.spin_enabled = false
	light_control.set_timer( 0.125 )

func animebulldog_lights() -> void:
	light_control.enabled = true
	light_control.flash_enabled = false
	light_control.spin_enabled = true
	light_control.set_timer( 0.025 )
	push_warning("MISSING VISUAL EFFECTS!!!!!")

func enable_light() -> void:
	spotlight.show()
	spotlight_2.show()
	spotlight_3.show()
	light_control.enabled = true
	light_control.set_timer( 0.25 )
	light_control.flash_enabled = true
	light_control.spin_enabled = true

func disable_light() -> void: ## TODO
	spotlight.hide()
	spotlight_2.hide()
	spotlight_3.hide()
	light_control.enabled = false
