extends Button

@onready var s_return_vrw: TextureRect = $SReturnVrw

func _init() -> void:
	text = Text.pr(text)
	button_group.pressed.connect( _icon_show )

func _ready() -> void:
	assert( s_return_vrw, "icon not set" )
	assert( button_group, "buton group not set.")
	if button_pressed: _icon_show(self)
	
func _icon_show( btn : Button ) -> void:
	s_return_vrw.visible = btn == self
