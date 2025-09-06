@tool
extends B2_EnvironProp

func _ready() -> void:
	EnvCol.get_child(0).disabled = true

func execute_event_user_0():
	EnvCol.get_child(0).disabled = false
