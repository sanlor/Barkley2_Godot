@tool
extends AnimatedSprite2D
class_name CC_ZodiacDial

signal pressed_finish
signal activated_next_dial(node)

@export_category("Debug")
@export var debug_color := Color.HOT_PINK

@export_category("Dial")
@export var can_rotate := true
@export var button_radius := 10.0 :
	set(_r):
		button_radius = _r
		queue_redraw()
@export var button_position := Vector2(150,0) :
	set(_p):
		button_position = _p
		queue_redraw()
@export var downstream_dial : CC_ZodiacDial
@export var floating_label_name := ""
@export var connected_display_label : Label
@export var display_division := 31
@export var sfx_hover 	:= ""
@export var sfx_click 	:= ""
@export var sfx_drag 	:= ""
@export var display_year := false

@export var is_active := false :
	set(b):
		is_active = b
		if is_active and hotspot:
			hotspot.focus_mode = Control.FOCUS_ALL
			hotspot.grab_focus() # Gamepad fix
		elif not is_active and hotspot:
			hotspot.focus_mode = Control.FOCUS_NONE

@export var hotspot	: Control

var is_hovering := false
var is_pressed := false
var is_dragging := false

var floating_label_node : Label

# zodiac wheel
var mouse_curr_pos := Vector2.ZERO
var mouse_last_pos := Vector2.ZERO

# Sound
var hover_sfx_played := false
var click_sfx_played := false
var drag_sfx_played := false
var drag_sfx_timeout := 0.85
var drag_sfx_player : AudioStreamPlayer

func _ready():
	assert(hotspot, "No hotspot added.")
	hotspot.size = Vector2(button_radius, button_radius)
	hotspot.position = button_position - (hotspot.size / 2)
	
	hotspot.mouse_entered.connect( _entered )
	hotspot.mouse_exited.connect( _exited )
	
	hotspot.focus_entered.connect( _entered )
	hotspot.focus_exited.connect( _exited )
	
	B2_Input.input_changed.connect(input_changed)
	
	# Debug draw
	queue_redraw()
	
	## Run the set script. Trust me.
	is_active = is_active

## Gamepad fix
func input_changed(_aaaaa) -> void:
	_exited()
	is_dragging = false
	is_pressed = false

func _entered() -> void:
	is_hovering = true
	_play_sounds()

func _exited() -> void:
	is_hovering = false
	hover_sfx_played = false;
	_play_sounds()

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return
	
	if not is_active:
		return
	
	if B2_Input.is_using_gamepad():
		if hotspot.has_focus():
			is_hovering = true
			
		if Input.get_axis("Up","Down") and is_pressed and can_rotate:
			rotation += _delta * Input.get_axis("Up","Down")
			is_dragging = true
		else:
			is_dragging = false
	
	if Input.is_action_just_pressed("Action") and is_hovering:
		is_pressed = true
		
		# check if this is the big fuckoff button.
		if not can_rotate:
			pressed_finish.emit()
		
		
	if Input.is_action_just_released("Action"):
		# during the first press
		if is_pressed:
			if downstream_dial != null:
				if not downstream_dial.is_active:
					downstream_dial.is_active = true
					activated_next_dial.emit( downstream_dial )
					
		is_pressed = false
		click_sfx_played = false
		
	if is_active:
		if is_pressed:
			frame = 2
			update_floating_label()
			
			# Mouse controls
			if can_rotate and not B2_Input.is_using_gamepad():
				mouse_curr_pos = get_global_mouse_position()
				if mouse_curr_pos != mouse_last_pos:
				#if snapped(rotation, 0.1) != snapped(global_position.angle_to_point( get_global_mouse_position() ), 0.1):
					is_dragging = true
					mouse_last_pos = mouse_curr_pos 
				else:
					is_dragging = false
					
				rotation = global_position.angle_to_point( get_global_mouse_position() )
		elif is_hovering:
			frame = 1
			update_floating_label()
			
		else:
			frame = 0
			is_dragging = false
			if floating_label_node != null:
				floating_label_node.queue_free()
	else:
		frame = 3
		
	_play_sounds()
	_update_display_label()
		
func _update_display_label():
	if connected_display_label != null:
		var rotation_rate := wrapf(rotation, 0, TAU) / TAU
		if display_year:
			connected_display_label.text = str( (display_division * rotation_rate) +1 ).pad_decimals(0).lpad(4, "0")
		else:
			connected_display_label.text = str( (display_division * rotation_rate) +1  ).pad_decimals(0).lpad(2, "0")
		
func _play_sounds():
	if is_active:
		#if mouse_entered:
		if is_pressed and not click_sfx_played:
			click_sfx_played = true
			var sfx : AudioStreamPlayer = B2_Sound.play(sfx_click)
			#await sfx.finished
			
			
		elif is_hovering and not hover_sfx_played and not is_pressed:
			hover_sfx_played = true
			var sfx : AudioStreamPlayer = B2_Sound.play(sfx_hover)
			#await sfx.finished
			
			
		elif is_dragging: ## Terrible solution, FIXME
			if not drag_sfx_played:
				drag_sfx_played = true
				drag_sfx_player = B2_Sound.play(sfx_drag, randf_range(0.0, 1.5))
				await get_tree().create_timer(drag_sfx_timeout).timeout
				#await drag_sfx_player.finished
				drag_sfx_player.stop()
				B2_Sound.finished_playing(drag_sfx_player)
				drag_sfx_player = null
				drag_sfx_played = false
			

func update_floating_label():
	if floating_label_name.is_empty():
		return
		
	if floating_label_node == null:
		floating_label_node = Label.new()
		add_child(floating_label_node)
		floating_label_node.text = floating_label_name
		floating_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		floating_label_node.top_level = true
		floating_label_node.theme = preload("res://barkley2/themes/main.tres")
	
	floating_label_node.global_position = get_global_mouse_position() + Vector2(16,8)
		

func _draw():
	if Engine.is_editor_hint():
		#draw_circle( button_position, button_radius, debug_color)
		draw_rect( Rect2(button_position - ( Vector2(button_radius, button_radius ) / 2), Vector2(button_radius, button_radius) ), debug_color )
