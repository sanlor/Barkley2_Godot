extends AnimatedSprite2D

@onready var door_collision: StaticBody2D = $door_collision
@onready var door_collision_shape: CollisionShape2D = $door_collision/door_collision_shape
@onready var door_sprite: AnimatedSprite2D = $door_sprite

func _ready() -> void:
	if B2_Playerdata.Quest("prisonDoors") == 0:
		lock_door()
	else:
		unlock_door()
		
		
func lock_door() -> void:
	door_collision_shape.disabled = false
	door_sprite.show()
	
func unlock_door() -> void:
	if global_position.x < 184: ## HATE THIS!!!
		if B2_Playerdata.Quest("prisonLiberated") == 3:
			door_collision_shape.disabled = true
			door_sprite.hide()
		else:
			lock_door()
	else:
		door_collision_shape.disabled = true
		door_sprite.hide()
