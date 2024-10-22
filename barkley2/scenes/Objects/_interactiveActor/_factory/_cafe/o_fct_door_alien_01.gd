@tool
extends B2_Environ

#@onready var EnvCol: StaticBody2D = $EnvCol
@onready var EnvCol: CollisionShape2D = $EnvCol/CollisionShape2D

func _ready() -> void:
	EnvCol.disabled = true
	
	if B2_Playerdata.Quest("tutorialGunking") == 1:
		lock()

func lock():
	animation = "busted"
	EnvCol.disabled = false

func _on_animation_changed() -> void:
	if animation == "busted":
		lock()
