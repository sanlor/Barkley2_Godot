extends ColorRect

@onready var debug_lbl: Label = $MarginContainer/VBoxContainer/debug_lbl
@onready var save_game_btn: Button = $MarginContainer/VBoxContainer/save_game_btn
@onready var export_btn: Button = $MarginContainer/VBoxContainer/export_btn
@onready var timer: Timer = $Timer

var save_game_btn_text 	:= "Save game"
var export_btn_text 	:= "Export save slot"

func _ready() -> void:
	debug_lbl.text 					= Text.pr(debug_lbl.text)
	save_game_btn.tooltip_text 		= Text.pr(save_game_btn.tooltip_text)
	export_btn.text 				= Text.pr(export_btn.tooltip_text)
	_on_timer_timeout()

func _physics_process(_delta: float) -> void:
	if visible:
		save_game_btn.disabled = B2_Input.cutscene_is_playing
		queue_redraw()

func _draw() -> void:
	var rect := Rect2( -Vector2.ONE, size + Vector2(2,2))
	draw_rect( rect, Color.GREEN * randf_range(0.55,1.55), false )

func _on_save_game_btn_pressed() -> void:
	B2_Playerdata.SaveGame()
	save_game_btn.text = Text.pr("Done!")
	save_game_btn.disabled = true
	timer.start()

func _on_export_btn_pressed() -> void:
	DisplayServer.clipboard_set( B2_Config.encode_save_slot_to_string() )
	export_btn.text = Text.pr("Done!")
	export_btn.disabled = true
	timer.start()

func _on_timer_timeout() -> void:
	save_game_btn.disabled = false
	export_btn.disabled = false
	save_game_btn.text = Text.pr(save_game_btn_text)
	export_btn.text = Text.pr(export_btn_text)
	
