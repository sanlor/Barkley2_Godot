extends B2_EnvironInteractive

@export var vidconIndex = 21

@onready var area_2d: Area2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D


func _ready() -> void:
	if B2_Playerdata.Quest("sewerGame") == 1:
		queue_free()
	
	B2_Playerdata.Quest("gamename", B2_Vidcon.get_vidcon_name(vidconIndex) ) 
	
func execute_event_user_0():
	## VIDCON: CRIME BUDDIES 2 
	B2_Vidcon.give_vidcon( vidconIndex )
	area_2d.queue_free()
	static_body_2d.queue_free()
	is_interactive = false
	hide()
