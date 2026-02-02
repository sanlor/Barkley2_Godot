extends Control

@onready var show_raw_cutscene_dialog_btn: Button = $show_raw_cutscene_dialog_btn
@onready var raw_cutscene_dialog: AcceptDialog = $raw_cutscene_dialog

## Breakout stuff
var show_breakout := false
var breakout_data := {
	"value" 		: "money", 	# what is shown in the breakbox
	"prev_value" 	: 0, 		# what is shown in the breakbox
	"modifier"		: 0, 		# preview of the pruchase (ex: item cost 10 NS, you have 100 NS, show 100 - 10 on the breakout)
	"opt"			: 0, 		# I have no idea what this is.
}

## Flourish stuff
var flourish_enabled 	:= false
var flourish_portrait 	:= ""
var flourish_time 		:= 0.0

## Data for CHOICE and REPLY
var last_talker_portrait			:= ""
var is_selecting_choices 			:= false
var choice_question					:= ""
var choices_labels					:= []
var choices_strings					:= []

@export var cutscene_script					:= B2_Script_Legacy.new()

func _ready() -> void:
	#B2_Screen.change_input_mouse( B2_Input.CONTROL.GAMEPAD )
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	B2_Screen.mouse.hide()
	
	_make_dialog( ["DIALOG", "Eric", "As much as it pains me to suffer your presence, I will agree to your terms."] )

func _make_dialog( parsed_line : PackedStringArray ) -> void:
	var dialogue := B2_Dialogue.new()
	B2_Screen.add_child( dialogue, true ) # 30/01/26 moved to B2_Screen and set as Control node.
	
	# Setup flourish
	dialogue.flourish_enabled 	= flourish_enabled
	dialogue.flourish_portrait 	= flourish_portrait
	dialogue.flourish_time 		= flourish_time
	
	# Reset flourish
	flourish_enabled 		= false
	flourish_portrait 		= ""
	flourish_time 			= 0.0
	
	if show_breakout:
		var brk := B2_Breakout.new()
		brk.breakout_data = breakout_data.duplicate()
		breakout_data["prev_value"] = B2_Playerdata.Quest( breakout_data["value"] )
		dialogue.add_child(brk, true)
		
		# Reset mods and opts.
		breakout_data["modifier"] = 0
		breakout_data["opt"] = 0
		
	# parse talker´s name
	if parsed_line[1].contains("="):
		var talker_split = parsed_line[1].split("=")
		var talker_name := Text.pr( talker_split[0].strip_edges(true,true) )
		var talker_port := talker_split[1].strip_edges(true,true)
		if talker_port == "P_NAME": 
			talker_port = "s_port_hoopz" ## TEMP HACK
			last_talker_portrait = B2_Gamedata.get_hoopz_portrait() # Maybe unnecessary?
		dialogue.set_portrait(talker_port, false)
		# Set the dialogue, with the variable injection
		dialogue.set_text( Text.qst( parsed_line[2].strip_edges(true,true) ), talker_name )
	else:
		var talker_port := parsed_line[1].strip_edges(true,true)

		if B2_Gamedata.portrait_from_name.has( talker_port ):
			dialogue.set_portrait( talker_port, true )
		if talker_port == "P_NAME":  ## TEMP HACK
			dialogue.set_portrait( "s_port_hoopz", false )
			last_talker_portrait = B2_Gamedata.get_hoopz_portrait() # Maybe unnecessary?
			# Set the dialogue, with the variable injection
		dialogue.set_text( Text.qst( parsed_line[2].strip_edges(true,true) ), talker_port )
								
	await dialogue.display_dialog()
	dialogue.queue_free()

func _on_show_raw_cutscene_dialog_btn_pressed() -> void:
	raw_cutscene_dialog.visible = not raw_cutscene_dialog.visible
