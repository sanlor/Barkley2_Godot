extends Control
## 07/03/26 My save games keep getting corrupted. This allows for the games to be imported or exported for easier backups.

@onready var import_btn: Button = $import_btn
@onready var export_btn: Button = $export_btn
@onready var timer: Timer = $Timer

var import_txt := "Import"
var export_txt := "Export"

var save_slot := 999

func _ready() -> void:
	# Translate, bitch
	import_btn.text = Text.pr(import_txt)
	export_btn.text = Text.pr(export_txt)
	import_btn.tooltip_text = Text.pr(import_btn.tooltip_text)
	export_btn.tooltip_text = Text.pr(export_btn.tooltip_text)
	set_buttons()
	
func set_buttons() -> void:
	if B2_Config.has_user_save( save_slot ):
		import_btn.disabled = true
		export_btn.disabled = false
	else:
		import_btn.disabled = false
		export_btn.disabled = true

func _on_import_btn_pressed() -> void:
	var clipboard_text := DisplayServer.clipboard_get().strip_edges()
	if B2_Config.decode_string_to_save_slot(clipboard_text, save_slot):
		import_btn.text = Text.pr( "Done!" )
		import_btn.disabled = true
		timer.start()
	else:
		push_warning("Clipboard text not valid.")
		import_btn.text = Text.pr( "Invalid Text!" )
		import_btn.disabled = true
		timer.start()

func _on_export_btn_pressed() -> void:
	DisplayServer.clipboard_set( B2_Config.encode_save_slot_to_string(save_slot) )
	print_rich("[bgcolor=blue][color=white]Save slot %s Exported.[/color][/bgcolor]" % save_slot)
	
	export_btn.text = Text.pr( "Done!" )
	export_btn.disabled = true
	timer.start()

func _on_timer_timeout() -> void:
	export_btn.text = Text.pr( export_txt )
	import_btn.text = Text.pr( import_txt )
	set_buttons()
