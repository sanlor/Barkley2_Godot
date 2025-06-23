extends B2_UtilityPanel

@onready var s_gleb_face: TextureRect = $SGlebFace

var t := 0.0
func _physics_process(delta: float) -> void:
	if visible:
		s_gleb_face.scale.x = sin( t )
		if s_gleb_face.scale.x < 0.0:			s_gleb_face.modulate = Color.DIM_GRAY
		else:									s_gleb_face.modulate = Color.WHITE
		t += 1.0 * delta
