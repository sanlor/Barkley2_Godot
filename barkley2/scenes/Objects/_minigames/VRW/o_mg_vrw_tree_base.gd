extends Node2D

var clones : Array[Node2D]

func _ready() -> void:
	var child : B2_Minigame_VRW_Tree = get_children().front()
	assert( child, "More than one child is not expected. Check this shit out, homie." )
	clones = B2_Minigame_VRW_Object.dew_it( child )
	clones.append( child )
	
	await get_tree().process_frame
	
	var _seed := randi()
	for i : B2_Minigame_VRW_Tree in clones:
		i.rng.seed = _seed
		i.call_deferred("begin")
