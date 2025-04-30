extends CanvasLayer

const VRDATA = preload("res://barkley2/scenes/sTitle/vr_missions/vr_data.gd")

@onready var animation_player: 		AnimationPlayer 	= $AnimationPlayer
@onready var mission_desc: 			Label 				= $mission_desc/MarginContainer/mission_label
@onready var mission_container: 	VBoxContainer 		= $mission_list/MarginContainer/ScrollContainer/VBoxContainer
@onready var mission_color_panel: 	ColorRect 			= $mission_desc


@onready var begin_label: 			Label 				= $begin_btn/begin_label
@onready var back_label: 			Label 				= $back_btn/back_label

func _ready() -> void:
	for b : Button in mission_container.get_children():
		b.text = Text.pr( b.text )
		b.pressed.connect( _update_description.bind( b.my_mission_id ) )
		if b.button_pressed:
			_update_description( 0 )
	begin_label.text 	= Text.pr( begin_label.text )
	back_label.text 	= Text.pr( back_label.text )
	
func show_menu() -> void:
	animation_player.play("show_menu")
	
func hide_menu() -> void:
	animation_player.play("hide_menu")

func _update_description( id : int ) -> void:
	var mission_description := VRDATA.get_description( id )
	if mission_description:
		mission_desc.text = Text.pr( mission_description )
	else:
		mission_desc.text = Text.pr( "Invalid mission description." )

func _on_back_btn_button_pressed() -> void:
	hide_menu()
	await animation_player.animation_finished
	get_parent().change_menu("basic")

func _physics_process(delta: float) -> void:
	if visible:
		mission_color_panel.color.a = ( sin( Time.get_ticks_msec() * 0.0025 ) * 0.015 ) + 0.015
		#print( mission_color_panel.color.a )
