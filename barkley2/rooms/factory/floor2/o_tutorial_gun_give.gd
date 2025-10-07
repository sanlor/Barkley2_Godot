@tool
extends B2_Event_Step_Trigger

# Came back afer breaking the light bulbs.
#@onready var enemy_nest: Area2D = $"../enemy_nest"

func _ready() -> void:
	# Already triggered.
	if B2_Playerdata.Quest("tutorialCollision", null, 0) >= 2:
		queue_free()

func event_trigger( _node ):
	if B2_Playerdata.Quest("tutorialCollision", null, 0) >= 1:
		if is_instance_valid(cutscene_script):
			B2_CManager.play_cutscene( cutscene_script, self, [] )

func execute_event_user_0():
	if get_parent() is B2_ROOMS:
		get_parent().set_pacify( false )
#		enemy_nest.activate_nest() # 06/09/25 - Disabled due to changes in the combat system
		B2_Gun.add_gun_to_bandolier( B2_Gun.TYPE.GUN_TYPE_PISTOL, B2_Gun.MATERIAL.STEEL )
		
		queue_free()
	else:
		# Where am I?
		breakpoint
