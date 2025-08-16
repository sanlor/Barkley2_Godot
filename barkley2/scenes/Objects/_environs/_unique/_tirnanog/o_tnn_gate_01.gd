extends AnimatedSprite2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	## Wait for other events to occur.
	await get_tree().process_frame
	
	## During Branding Scene OR after Gov Speech the gate is open ##
	if B2_Playerdata.Quest("sceneBrandingStart") == 1 or B2_Playerdata.Quest("govQuest") == 6: unlock()
	else: lock()
			
	## Shutdown permanently after you've escaped from TNN ##
	if B2_Playerdata.Quest("escapedFromTNN") >= 2: lock()

func unlock() -> void:
	frame = 0
	collision_shape_2d.disabled = true

func lock() -> void:
	frame = 1
	collision_shape_2d.disabled = false
