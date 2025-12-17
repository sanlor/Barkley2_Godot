extends B2_UtilityPanel

signal confirmation( choice : bool )

@onready var confirmation_dialog: 	Label = $Panel/confirmation_dialog

@onready var yes_btn: 				Button = $Panel/HBoxContainer/yes_btn
@onready var no_btn: 				Button = $Panel/HBoxContainer/no_btn

func _ready() -> void:
	yes_btn.text = Text.pr( yes_btn.text )
	no_btn.text = Text.pr( no_btn.text )
	no_btn.grab_focus()

func setup_text( text : String ) -> void:
	confirmation_dialog.text = Text.pr( text )

func show_panel( _speed := 0.4 ) -> void:
	super()
	no_btn.grab_focus()

func _on_yes_btn_pressed() -> void:
	confirmation.emit( true )
	B2_Sound.play( "utility_button_click" )
	await hide_panel()
	queue_free()

func _on_no_btn_pressed() -> void:
	confirmation.emit( false )
	B2_Sound.play( "utility_button_click" )
	await hide_panel()
	queue_free()
