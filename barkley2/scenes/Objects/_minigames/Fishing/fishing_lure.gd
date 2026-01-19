@icon("uid://c0osjxqpnqvqy")
extends Marker2D
class_name B2_MiniGame_Lure
# Lure for the fishing minigame
# check o_mg_fishing_lure

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var lure: 		Sprite2D = $lure
@onready var shadow: 	Sprite2D = $shadow

func _ready() -> void:
	_on_animated_sprite_2d_animation_finished()

func set_mod( c : Color ) -> void:
	lure.modulate = c

func set_y_offset(_offset : float) -> void:
	lure.position.y = _offset

func set_lure_rot( rot : float, s := 0.001) -> void:
	lure.rotation = lerp( lure.rotation, rot, s )
	shadow.rotation = lerp( shadow.rotation, rot, s )

func enable_shadow( enabled : bool ) -> void:
	shadow.visible = enabled
	
func splash() -> void:
	B2_Sound.play("splash_out")
	animated_sprite_2d.show()
	animated_sprite_2d.top_level = true # <- important!
	animated_sprite_2d.global_position = global_position
	animated_sprite_2d.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.hide()
