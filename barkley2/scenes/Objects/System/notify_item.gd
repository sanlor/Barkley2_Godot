extends CanvasLayer

@onready var notify_item: ColorRect 		= $notify_item
@onready var dialog: TextureRect 			= $notify_item/dialog
@onready var dialog_text: Label 			= $notify_item/dialog/dialog_text

var is_showing_notify := false
var notify_text := "Male rats have huge balls, but do female rats have huge ovaries? <- this is an error message. Something went wrong."

func _ready() -> void:
	layer = B2_Config.NOTICE_LAYER

func show_notify_screen( text : String ) -> void:
	is_showing_notify = true
	notify_item.show()
	
	if text.is_empty():
		dialog_text.text 		= Text.pr(notify_text)
		push_warning("No text! defaulting to the derranged one.")
	else:
		dialog_text.text 		= Text.pr(text)
	
	dialog_text.modulate.a 	= 0.0
	notify_item.modulate.a 	= 0.0
	set_deferred("dialog.size:y", 0.0)
	
	var tween := create_tween()
	tween.tween_interval( 0.5 )
	tween.tween_property( notify_item, 			"modulate:a", 		1.0, 	0.15 )
	tween.parallel().tween_property( dialog, 	"position:y", 		86, 	0.15 )
	tween.parallel().tween_property( dialog, 	"size:y", 			68, 	0.15 )
	tween.tween_property( dialog_text, 			"modulate:a", 		1.0, 	0.15 )
	
	await tween.finished
	if not B2_Input.is_fastforwarding: #Skip the message if its FF.
		await B2_Input.action_pressed
	
	tween = create_tween()
	tween.tween_interval( 0.25 )
	tween.tween_property( dialog_text, 				"modulate:a", 		0.0, 	0.15 )
	tween.parallel().tween_property( dialog, 		"position:y", 		112, 	0.15 )
	tween.parallel().tween_property( dialog, 		"size:y", 			16, 	0.15 )
	tween.parallel().tween_property( notify_item, 	"modulate:a", 		0.0, 	0.15 )
	
	tween.tween_interval( 0.25 )
	await tween.finished
	notify_item.hide()
	is_showing_notify = false
	return
