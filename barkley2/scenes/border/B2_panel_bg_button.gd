@tool
extends B2_Border
class_name B2_Border_Button

## This node is part of the translation of the Border() script.
# THis one also acts like a button.

signal button_pressed

const S_1X_1 = preload("res://barkley2/assets/b2_original/images/s1x1.png")

@export_category("Panel Setup")
@export var monitor_mouse 					:= true
@export var change_children_color 			:= true
@export var content_selected_color 			:= Color.ORANGE
@export var content_highlight_color 		:= Color.WHITE
@export var bg_selected_color 				:= Color.ORANGE
@export var bg_highlight_color 				:= Color.WHITE
@export var can_toggle 						:= false
@export var disabled						:= false
@export var is_pressed 						:= false :
	set(p):
		is_pressed = p
		queue_redraw()
@export var manual_decorations				: Array[Node]
var is_highlighted := false


func _ready():
	for node in manual_decorations: ## Manually add nodes to have its colors changed.
		add_decorations(node, false, false)
		
	size = border_size
	b_2_panel_fg.set_panel_size(border_size.x, border_size.y)
	
	if monitor_mouse:
		mouse_entered.connect( 	func(): is_highlighted = true; 		queue_redraw() )
		mouse_exited.connect( 	func(): is_highlighted = false; 	queue_redraw() )
	
func _gui_input(event):
	if monitor_mouse:
		if event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventKey: ## Allow window to be pressed, if the mouse is being monitored.
			if disabled: # dont do anything if its disabled.
				return
				
			if event.is_action_pressed("ui_accept") or event.is_action_pressed("Action"):
				if can_toggle:
					is_pressed = not is_pressed
			if event.is_action_released("ui_accept") or event.is_action_released("Action"):
				if not can_toggle:
					is_pressed = false
				button_pressed.emit()
				
func _draw():
	## BG
	var bg_rect := Rect2( Vector2(4,4), border_size - Vector2(8,8) ) # Small offset to hide the BG
	if not disable_bg:
		draw_texture_rect( S_BORDER_BG_0, bg_rect, true, Color(1, 1, 1, 0.65), false ) ## Checkered BG
	
	if is_highlighted or has_focus():
		draw_texture_rect( S_1X_1, bg_rect, true, Color(bg_highlight_color, 0.05), false )
	if is_pressed:
		draw_texture_rect( S_1X_1, bg_rect, true, Color(bg_selected_color, 0.25), false )
		
	if change_children_color:
		for n in decorations:
			if n == null:
				continue
				
			if is_highlighted:
				n.modulate = content_highlight_color
			else:
				if decorations_color.has(n):
					n.modulate = decorations_color[n]
				else:
					decorations_color.erase(n)
			if is_pressed:
				n.modulate = content_selected_color
			
	
	if is_first_draw: ## avoid updating the border decorations
		b_2_panel_fg.queue_redraw()
		is_first_draw = false
