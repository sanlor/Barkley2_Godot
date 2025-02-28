extends B2_ScriptActions
class_name B2_SA_Sound

@export var sound_name 		: String
@export var sound_pitch 	:= 1.0
@export var sound_loop		:= 1

#func _init() -> void:
	#assert( not sound_name.is_empty() )
