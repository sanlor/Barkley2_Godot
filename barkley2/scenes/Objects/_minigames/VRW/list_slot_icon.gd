extends HBoxContainer

@onready var s_return_vrw: TextureRect = $list_players_lbl/SReturnVrw

func _ready() -> void:
	assert( s_return_vrw, "icon not set" )
	#draw.connect( s_return_vrw.set_visible.bind(modulate == Color.GREEN) )
	
func _physics_process(_delta: float) -> void:
	s_return_vrw.set_visible( modulate == Color.GREEN )
