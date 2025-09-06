extends B2_Environ
class_name B2_Puddle

@onready var area_2d: Area2D = $Area2D

## Check o_rain_puddle
func _ready() -> void:
	play()
	
	area_2d.monitorable = false
	area_2d.monitoring = true
	
	area_2d.body_entered.connect(	_enter_puddle	)
	area_2d.body_exited.connect(	_exit_puddle	)


func _enter_puddle( body ) -> void:
	if body is B2_Player_FreeRoam:
		#print("aaaaa")
		body.is_on_a_puddle = true
	
func _exit_puddle( body ) -> void:
	if body is B2_Player_FreeRoam:
		#print("ooooo")
		body.is_on_a_puddle = false
