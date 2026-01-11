extends Marker2D

@onready var lure: 		Sprite2D = $lure
@onready var shadow: 	Sprite2D = $shadow

func set_y_offset(_offset : float) -> void:
	lure.position.y = _offset

func set_lure_rot( rot : float) -> void:
	lure.rotation = lerp( lure.rotation, rot, 0.001 )
	shadow.rotation = lerp( shadow.rotation, rot, 0.001 )

func enable_shadow( enabled : bool ) -> void:
	shadow.visible = enabled
	
