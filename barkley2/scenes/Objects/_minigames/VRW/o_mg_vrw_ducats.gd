extends B2_EnvironInteractive

func _ready() -> void:
	var cutscene := B2_Script_Legacy.new()
	cutscene.original_script = \
	"CREATE  | o_mg_vrw_ducats_mining
	WAIT    | 5
	QUEST   | digiducats += 5
	EVENT   | %s | 0" % name
	cutscene_script = cutscene
	
	speed_scale = randf_range(0.8,1.2)
	
func execute_event_user_0():
	is_interactive = false
	var t := create_tween()
	t.tween_property( self, "modulate", Color.TRANSPARENT, 1.0 )
	t.tween_callback( queue_free )
