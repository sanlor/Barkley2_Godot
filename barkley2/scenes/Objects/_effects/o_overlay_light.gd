extends TextureRect

const TIME := 1.5

var t : Tween

func _ready() -> void:
	modulate = Color.TRANSPARENT
	t = create_tween()
	t.tween_property( self, "modulate", Color.WHITE * 0.5, TIME )

func execute_event_user_0():
	if t: t.kill()
	t = create_tween()
	
	t.tween_property( self, "modulate", Color.TRANSPARENT, TIME )

func _physics_process(_delta: float) -> void:
	## Center self on camera
	if B2_CManager.camera:
		position = (B2_CManager.camera.position + B2_CManager.camera.offset) - Vector2( 384,240 ) / 2.0
