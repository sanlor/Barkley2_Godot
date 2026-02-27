extends Node2D

var clones : Array[Node2D]

func _ready() -> void:
	var child : B2_Minigame_VRW_Ducats = get_children().front()
	assert( child, "More than one child is not expected. Check this shit out, homie." )
	clones = B2_Minigame_VRW_Object.dew_it( child )
	clones.append( child )
	
	await get_tree().process_frame
	
	var _seed := randi()
	for i : B2_Minigame_VRW_Ducats in clones:
		i.rng.seed = _seed
		
		var cutscene := B2_Script_Legacy.new()
		cutscene.original_script = \
		"CREATE  | o_mg_vrw_ducats_mining
		WAIT    | 5
		QUEST   | digiducats += 5
		EVENT   | %s | 0" % name
		i.cutscene_script = cutscene
		
		i.call_deferred("begin")

func execute_event_user_0():
	for i : B2_Minigame_VRW_Ducats in clones:
		i.is_interactive = false
	var t := create_tween()
	t.tween_property( self, "modulate", Color.TRANSPARENT, 1.0 )
	t.tween_callback( queue_free )
