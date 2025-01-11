extends B2_InteractiveActor

# This actor should neve move. It can, but it shouldnt.

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	for i in 4:
		var mask := B2_Script_Mask.new()
		cutscene_script_mask.append(mask)
		
	var pos1 := Vector2(position.x, position.y + 16);
	var pos2 := Vector2(position.x, position.y + 26);
	var snd1 = B2_Sound.get_sound_pick("utility_open");
	var snd2 = B2_Sound.get_sound_pick("utility_close");
	
	@warning_ignore("standalone_expression")
	cutscene_script_mask[0].setup( "$pos1", str(pos1.x) + " " + str(pos1.y) ) as B2_Script_Mask
	@warning_ignore("standalone_expression")
	cutscene_script_mask[1].setup( "$pos2", str(pos2.x) + " " + str(pos2.y) ) as B2_Script_Mask
	@warning_ignore("standalone_expression")
	cutscene_script_mask[2].setup( "$snd", str(snd1) ) as B2_Script_Mask
	@warning_ignore("standalone_expression")
	cutscene_script_mask[3].setup( "$snd2", str(snd2) ) as B2_Script_Mask
	
