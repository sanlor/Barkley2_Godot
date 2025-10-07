extends AnimatedSprite2D

@onready var timer: Timer = $Timer

var on := true

func _ready() -> void:
	if B2_Playerdata.Quest("prisonLiberated") == 3: 
		on = false
	else:
		timer.start( randf() * 2.0 )
	
func _on_timer_timeout() -> void:
	if speed_scale < 0:
		play("default", randf_range(0.6,1.4) )
	else:
		play("default", -randf_range(0.6,1.4) )

func _on_animation_finished() -> void:
	timer.start( randf() * 2.0 )
