extends CanvasLayer

## Check o_hud.
# Oh boy... more work.

@onready var hud_bar: 	TextureRect 	= $hud_bar
@onready var hud_tv: 	Control 		= $hud_bar/hud_tv

@export var is_hud_visible := true

## Anim
var tween : Tween

const SHOWN_Y 	:= 200.0
const HIDDEN_Y 	:= 240.0


func _ready() -> void:
	if is_hud_visible: 	hud_bar.position.y = SHOWN_Y
	else: 				hud_bar.position.y = HIDDEN_Y
	hud_tv.change_tv_face()
	
func show_hud():
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property( hud_bar, "position:y", SHOWN_Y, 0.25 )
	
func hide_hud():
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property( hud_bar, "position:y", HIDDEN_Y, 0.25 )

	
