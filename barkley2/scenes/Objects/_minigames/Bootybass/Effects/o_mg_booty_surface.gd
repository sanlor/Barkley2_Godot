extends Node
## Node that controls how the spotlight work.

# Podium lights
@onready var light_control: 	Node2D 			= $"../light_control"

# Dance floor lights
@onready var spotlight: 		PointLight2D 	= $"../spotlight"
@onready var spotlight_2: 		PointLight2D 	= $"../spotlight2"
@onready var spotlight_3: 		PointLight2D 	= $"../spotlight3"

func enable_light() -> void:
	spotlight.show()
	spotlight_2.show()
	spotlight_3.show()

func disable_light() -> void: ## TODO
	spotlight.hide()
	spotlight_2.hide()
	spotlight_3.hide()
