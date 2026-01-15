extends Marker2D

@onready var lure: 		Sprite2D = $lure
@onready var shadow: 	Sprite2D = $shadow

func set_y_offset(_offset : float) -> void:
	lure.position.y = _offset

func set_lure_rot( rot : float, s := 0.001) -> void:
	lure.rotation = lerp( lure.rotation, rot, s )
	shadow.rotation = lerp( shadow.rotation, rot, s )

func enable_shadow( enabled : bool ) -> void:
	shadow.visible = enabled
	
