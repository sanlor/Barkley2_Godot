extends B2_ROOMS
## Fishing minigame room

@onready var o_cts_hoopz: CharacterBody2D = $o_cts_hoopz

func _enter_tree() -> void:
	super()
	B2_Playerdata.disable_save()

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	B2_Music.play("mus_fishing_casualTEMP")
