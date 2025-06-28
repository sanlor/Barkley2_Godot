extends PanelContainer

@onready var attachment: TextureRect = $VBoxContainer/attachment
@onready var attach_title: Label = $VBoxContainer/MarginContainer/HBoxContainer/attach_title
@onready var attach_name_lbl: Label = $VBoxContainer/MarginContainer/HBoxContainer/attach_name


var attach_name := "Placeholder"
var is_open := false

func _ready() -> void:
	self_modulate = Color("ff5b4a")
	attach_name_lbl.text = attach_name
	attachment.hide()

func light_up( enabled : bool ) -> void:
	if enabled:		self_modulate = Color("ff8473")
	else:			self_modulate = Color("ff5b4a")

func _on_focus_entered() -> void:
	light_up( true )

func _on_focus_exited() -> void:
	light_up( false )

func _on_mouse_entered() -> void:
	light_up( true )

func _on_mouse_exited() -> void:
	if not has_focus():
		light_up( false )

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventKey:
		if has_focus():
			if Input.is_action_just_pressed("Action"):
				## TODO Add SFX (Like the one used on old Internet explorer when you clicked on a link)
				if is_open:
					is_open = false
					_close_window()
				else:
					is_open = true
					_open_window()

## Add a fun effect of an image loading. im getting old... Yesterday at work we were laughing at the new guy when he said "back in my day, this and that" and that was when we were on our early 20s.
func _open_window() -> void:
	attachment.show()
	
	var ratio := 0.0
	for i in 20:
		if not is_open:
			break
		ratio += 0.05
		attachment.material.set_shader_parameter("ratio", ratio)
		
		## random delays
		for ii in randi_range(0,60):
			if not is_open:
				break
			await get_tree().physics_frame

func _close_window() -> void:
	attachment.hide()
