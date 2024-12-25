extends Control
class_name B2_DiagBG

## Simplified version of the Border node. Doesnt have the random border flair and is a bit smaller.

## BG stuff
const S_DIAG_BG = preload("res://barkley2/assets/b2_original/images/merged/s_diag_bg.png")
const S_DIAG_BG_ALT = preload("res://barkley2/assets/b2_original/images/merged/s_diag_bg_alt.png")
const S_DIAG_BG_VRW = preload("res://barkley2/assets/b2_original/images/merged/s_diag_bg_vrw.png")
		
var diag_fg : B2_DiagFG
@export var diag_size := Vector2(32,32) : 
	set(s):
		diag_size = s
		queue_redraw()

func _init():
	diag_fg = B2_DiagFG.new()
	add_child(diag_fg)
	
func set_panel_size(x, y):
	diag_size = Vector2(x,y)
	size = diag_size
	diag_fg.set_panel_size(diag_size.x, diag_size.y)
	queue_redraw()
	
func _draw() -> void:
	draw_texture_rect( S_DIAG_BG, Rect2( Vector2.ZERO, diag_size), true, Color( Color.WHITE, 0.5 ) )
