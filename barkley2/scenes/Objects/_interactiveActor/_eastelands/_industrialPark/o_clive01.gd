extends B2_InteractiveActor

@onready var timer: Timer = $Timer

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	B2_Playerdata.Quest("temp", 0);

	# Deactivation #
	if B2_Playerdata.Quest("chupQuest") >= 1 and B2_Playerdata.Quest("chupQuest") != 4:
		B2_Playerdata.Quest("chupQuest", 4);
		queue_free()
	if B2_ClockTime.time_gate() < 8: queue_free()
	if B2_ClockTime.time_gate() > 11:
		B2_Playerdata.Quest("chupQuest", 4);
		queue_free()
	
	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"
	
	timer.start( randf_range(2.0,6.0) )
	
## Cut the profits in half
func execute_event_user_0():
	var tempoo : float = float( B2_Playerdata.Quest("temp", 0.0) )
	tempoo /= 2.0;
	B2_Playerdata.Quest("temp", tempoo);
	
## Reset actors
func execute_event_user_1():
	#with (InteractiveActor)
	#{
	#	if (object_index != o_clive01 && object_index != o_cts_hoopz) scr_event_set_object(id, xSav, ySav);
	#}
	pass
	
## Save x and y on actors
func execute_event_user_2():
	#with (InteractiveActor)
	#{
	#	xSav = x;
	#	ySav = y;
	#}
	pass
	
func execute_event_user_3():
	queue_free()

func _on_timer_timeout() -> void:
	var anim := ActorAnim.animation
	var options := ["look_left","look_right","open_hood"]
	
	if anim == "unhooded":
		ActorAnim.play("pull_hood")
	else:
		ActorAnim.play(options.pick_random())
	
	timer.start( randf_range(2.0,6.0) )

func _on_actor_anim_animation_finished() -> void:
	match ActorAnim.animation:
		"look_left":
			ActorAnim.animation = "default"
		"look_right":
			ActorAnim.animation = "default"
		"pull_hood":
			ActorAnim.animation = "default"
		"open_hood":
			ActorAnim.animation = "unhooded"
