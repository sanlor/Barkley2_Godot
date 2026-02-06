extends Control

signal finished

@onready var refresh_btn: 			Button = $server_controls/refresh_btn
@onready var update_btn: 			Button = $server_controls/update_btn
@onready var jack_in_btn: 			Button = $server_controls/jack_in_btn
@onready var jack_out_btn: 			Button = $server_controls/jack_out_btn

@onready var alignment_holy_btn: 	Button = $alignment_border/MarginContainer/VBoxContainer/alignment_holy_btn
@onready var alignment_dogood_btn: 	Button = $alignment_border/MarginContainer/VBoxContainer/alignment_dogood_btn
@onready var alignment_venga_btn: 	Button = $alignment_border/MarginContainer/VBoxContainer/alignment_venga_btn
@onready var alignment_wicked_btn: 	Button = $alignment_border/MarginContainer/VBoxContainer/alignment_wicked_btn

@onready var job_croupier_btn: 		Button = $job_border/MarginContainer/VBoxContainer/job_croupier_btn
@onready var job_jobber_btn: 		Button = $job_border/MarginContainer/VBoxContainer/job_jobber_btn
@onready var job_cobbler_btn: 		Button = $job_border/MarginContainer/VBoxContainer/job_cobbler_btn
@onready var job_roofer_btn: 		Button = $job_border/MarginContainer/VBoxContainer/job_roofer_btn

@onready var player_name_lbl: 		Label = $player_name_lbl
@onready var player_class_lbl: 		Label = $player_class_lbl

@onready var list_refresh_lbl: Label = $server_list_border/MarginContainer/VBoxContainer/list_refresh_lbl
@onready var server_list_border: 	Control = $server_list_border
@onready var window_bg: 			ColorRect 	= $window_bg
@onready var window_msg_lbl: 		Label 		= $window_bg/window_border/window_msg_lbl

var serRan := [100,							75,								100,						10,								25]
var serMsg := ["ERROR 392 #Ping timeout.",	"ERROR 135 #Server is full.",	"CONNECTING",				"ERROR 900 #Locked server.",	"ERROR 342 #Invalid server."]

var selected_server := -1 :
	set(s):
		selected_server = s
		_update_server_btns()

@onready var button_group_class : ButtonGroup = job_croupier_btn.button_group
@onready var button_group_align : ButtonGroup = alignment_holy_btn.button_group

var player_align := ""
var player_class := ""

func _ready() -> void:
	if B2_Playerdata.Quest("vrwInside") == 1:
		print_rich("[color=pink]Player is already inside O.O.[/color]")
		finished.emit()
		queue_free()
	refresh_btn.text 	= Text.pr( refresh_btn.text )
	update_btn.text 	= Text.pr( update_btn.text )
	jack_in_btn.text 	= Text.pr( jack_in_btn.text )
	jack_out_btn.text 	= Text.pr( jack_out_btn.text )
	
	window_bg.hide()
	_update_server_btns()
	button_group_class.pressed.connect( _update_class )
	button_group_align.pressed.connect( _update_align )
	
	## Pre-set some random buttons.
	[job_croupier_btn,job_jobber_btn,job_cobbler_btn,job_roofer_btn].pick_random().call_deferred("set_pressed", true)
	[alignment_holy_btn,alignment_dogood_btn,alignment_venga_btn,alignment_wicked_btn].pick_random().call_deferred("set_pressed", true)
	
	## Safety
	B2_RoomXY.fadeout_finished.connect( queue_free )
	
func _update_class( btn : Button ) -> void:
	player_class = btn.text
	_update_name()
	
func _update_align( btn : Button ) -> void:
	player_align = btn.text	
	_update_name()
	
func _update_name() -> void:
	player_class_lbl.text = Text.pr( player_align + " " + player_class )

func _update_server_btns() -> void:
	refresh_btn.set_disabled(false)
	update_btn.set_disabled(selected_server < 0 and list_refresh_lbl.visible )
	jack_in_btn.set_disabled(selected_server < 0)
	jack_out_btn.set_disabled(false)

func _disable_buttons( action : bool ) -> void:
	refresh_btn.set_disabled(action)
	update_btn.set_disabled(action or (selected_server < 0 and list_refresh_lbl.visible))
	jack_in_btn.set_disabled(action or selected_server < 0)
	jack_out_btn.set_disabled(action)

func show_msg_window( message : String, connect_to_server : bool ) -> void:
	var t := create_tween()
	t.tween_callback( _disable_buttons.bind(true) )
	
	t.tween_callback( window_bg.show )
	t.tween_callback( window_msg_lbl.set_text.bind( Text.pr("Jacking into server...") ) )
	t.tween_interval( randf_range(1,5) )
	t.tween_callback( window_msg_lbl.set_text.bind( Text.pr(message) ) )
	t.tween_interval( randf_range(2,5) )
	if connect_to_server:
		await t.finished
		B2_Playerdata.Quest("vrwInside", 1)
		finished.emit()
		queue_free()
	else:
		t.tween_callback( window_bg.hide )
		t.tween_callback( _disable_buttons.bind(false) )

func _on_refresh_btn_pressed() -> void:
	var server_order := [0,1,2,3,4]
	server_order.shuffle()
	
	var t := create_tween()
	t.tween_callback( _disable_buttons.bind(true) )
	
	t.tween_callback( server_list_border.refresh_servers )
	t.tween_callback( window_bg.show )
	t.tween_callback( window_msg_lbl.set_text.bind( Text.pr("Refreshing server list...") ) )
	
	for i in clampi(randi_range(2,6), 2, 4): ## Make more probable that a full server list appears.
		t.tween_interval( randf_range(0.1,2.5) )
		t.tween_callback( server_list_border.display_server.bind( server_order[i] ) )
		
	t.tween_interval( randf_range(0.1,1.5) )
	t.tween_callback( window_bg.hide )
	t.tween_callback( _disable_buttons.bind(false) )

func _on_update_btn_pressed() -> void:
	var t := create_tween()
	t.tween_callback( _disable_buttons.bind(true) )
	
	t.tween_callback( window_bg.show )
	t.tween_callback( window_msg_lbl.set_text.bind( Text.pr("Updating server info...") ) )
	t.tween_interval( randf_range(2.0,3.0) )
	t.tween_callback( server_list_border._reset_ranges )
	t.tween_callback(  server_list_border._populate_server_list )
	
	t.tween_callback( window_bg.hide )
	t.tween_callback( _disable_buttons.bind(false) )

func _on_jack_in_btn_pressed() -> void:
	show_msg_window( serMsg[selected_server], selected_server == 2 )

func _on_jack_out_btn_pressed() -> void:
	B2_Playerdata.Quest("vrwInside", 0)
	B2_Music.stop()
	B2_RoomXY.fancy_warp_to("r_bct_tower04", 208, 1424);
