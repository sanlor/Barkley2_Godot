@tool
extends B2_Border
class_name B2_Border_Button

signal button_pressed

const S_1X_1 = preload("res://barkley2/assets/b2_original/images/s1x1.png")

@export_category("Panel Setup")
@export var monitor_mouse := true
@export var change_children_color := true
@export var selected_color := Color.ORANGE

var is_highlighted := false

func _ready():
	size = border_size
	b_2_panel_fg.set_panel_size(border_size.x, border_size.y)
	
	if monitor_mouse:
		mouse_entered.connect( 	func(): is_highlighted = true; 		queue_redraw() )
		mouse_exited.connect( 	func(): is_highlighted = false; 	queue_redraw() )
	
func _gui_input(event):
	if monitor_mouse:
		if event is InputEventMouseButton: ## Allow window to be pressed, if the mouse is being monitored.
			if event.is_action_pressed("Action"):
				button_pressed.emit()
				
func _draw():
	## BG
	var bg_rect := Rect2( Vector2(4,4), border_size - Vector2(8,8) ) # Small offset to hide the BG
	if not disable_bg:
		draw_texture_rect( S_BORDER_BG_0, bg_rect, true, Color(1, 1, 1, 0.5), false )
	if is_highlighted:
		draw_texture_rect( S_1X_1, bg_rect, true, Color(1, 1, 1, 0.25), false )
		
	if change_children_color:
		for n in decorations:
			if is_highlighted:
				n.modulate = selected_color
			else:
				n.modulate = Color.WHITE
	
	if is_first_draw: ## avoid updating the border decorations
		b_2_panel_fg.queue_redraw()
		is_first_draw = false
