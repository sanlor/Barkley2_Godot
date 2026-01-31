@tool
extends Control

@onready var gun_info_rename_panel: 			Control = $".."
@onready var new_name: 							Label = $new_name
@onready var buttons: 							GridContainer = $buttons
@onready var utilitystation_screen: 			Control = $"../../.."

@export_tool_button("Make keyboard") var aaa := _aaa

@export var disablable_buttons : 				Array[Button] = [] ## Is this even a word?

func _aaa() -> void:
	for i in buttons.get_children():
		i.queue_free()
	
	disablable_buttons.clear()
	
	var keys := "0123456789abcdefghijklmnokqrstuvwxyz+-"
	for l in keys:
		var b := Button.new()
		b.name = "button_" + str(l)
		b.text = str(l).to_upper()
		b.custom_minimum_size = Vector2(20,16)
		b.pressed.connect( write_letter.call( str( l ) ) )
		disablable_buttons.append( b )
		buttons.add_child( b, true )
		b.owner = get_tree().edited_scene_root
		
func write_letter( letter : String ) -> void:
	B2_Sound.play("hoopz_click")
	if new_name.text.length() < 4:
		new_name.text += str(letter).to_upper()

func reset() -> void:
	new_name.text = ""

func _on_button_end_pressed() -> void:
	B2_Sound.play("hoopz_click")
	gun_info_rename_panel.gun.weapon_short_name = new_name.text.left( 4 )
	gun_info_rename_panel.renamed_gun.emit( gun_info_rename_panel.gun )
	reset()
	
func _on_button_del_pressed() -> void:
	B2_Sound.play("hoopz_click")
	new_name.text = new_name.text.left( new_name.text.length() - 1 )
