extends CanvasLayer

const VRDATA = preload("res://barkley2/scenes/sTitle/vr_missions/vr_data.gd")

@onready var animation_player: 		AnimationPlayer 	= $AnimationPlayer
@onready var mission_desc: 			Label 				= $mission_desc/MarginContainer/mission_label
@onready var mission_container: 	VBoxContainer 		= $mission_list/MarginContainer/ScrollContainer/VBoxContainer
@onready var mission_color_panel: 	ColorRect 			= $mission_desc

@onready var vr_death_counter: Label = $vr_death_counter

@onready var begin_label: 			Label 				= $begin_btn/begin_label
@onready var back_label: 			Label 				= $back_btn/back_label

var selected_mission := 0

func _ready() -> void:
	for b : Button in mission_container.get_children():
		b.text = Text.pr( b.text )
		b.pressed.connect( _update_description.bind( b.my_mission_id ) )
		if b.button_pressed:
			_update_description( selected_mission )
	begin_label.text 	= Text.pr( begin_label.text )
	back_label.text 	= Text.pr( back_label.text )
	
func show_menu() -> void:
	B2_Config.select_user_slot( 69 ) ## Lol
	vr_death_counter.text = Text.pr( "Hypothetical Deaths: %s " % str( int(B2_Config.get_user_save_data( "player.deaths.total", 0 ) ) ) )
	for i in 6: ## reset mission select variable.
		if B2_Playerdata.Quest("vr_mission_%s" % str(i) ) == 1:
			B2_Playerdata.Quest("vr_mission_%s" % str(i), 0 )
			
	B2_Music.volume_menu( true )
	B2_Sound.play("mgs_open")
	animation_player.play("show_menu")
	_update_description( selected_mission )
	
func hide_menu() -> void:
	B2_Music.volume_menu( false )
	animation_player.play("hide_menu")

func _update_description( id : int ) -> void:
	B2_Sound.play("mgs_select")
	selected_mission = id
	var mission_description := VRDATA.get_description( id )
	if mission_description:
		mission_desc.text = Text.pr( mission_description )
		if B2_Playerdata.Quest("vr_mission_%s_complete" % str(id) ) == 1:
			mission_desc.text += "\n" + Text.pr( "(Completed)" )
		elif B2_Playerdata.Quest("vr_mission_%s" % str(id) ) == 2:
			mission_desc.text += "\n" + Text.pr( "(Unfinished)" )
	else:
		mission_desc.text = Text.pr( "Invalid mission description." )

func _on_back_btn_button_pressed() -> void:
	hide_menu()
	B2_Sound.play("mgs_exit_menu")
	await animation_player.animation_finished
	get_parent().change_menu("basic")

func _physics_process(_delta: float) -> void:
	if visible:
		mission_color_panel.color.a = ( sin( Time.get_ticks_msec() * 0.0025 ) * 0.015 ) + 0.015
		#print( mission_color_panel.color.a )

func _on_begin_btn_button_pressed() -> void:
	## Quest "vr_mission_x" || 1 -> selected mission || 2 -> Begun mission || 3 -> Finished mission
	# B2_Playerdata.preload_skip_tutorial_save_data() <- is this needed?
	match selected_mission:
		0: ## Mission 01
			print("Loading Mission %s data." % str(selected_mission + 1) )
			#B2_CManager.BodySwap("diaper") ## DEBUG
			B2_Playerdata.Quest( "infiniteAmmo", 1 )
			B2_Playerdata.Quest( "vr_mission_0", 1 )
			B2_Playerdata.Quest( "escape_disabled", 1 )
			
			B2_Playerdata.Quest( "playerName", 		"???" ); # constant P_NAME
			B2_Playerdata.Quest( "playerNameFull", 	"???" ); # constant P_NAME_F
			B2_Playerdata.Quest( "playerNameShort", 	"???" ); # constant P_NAME_S
			
			B2_Jerkin.reset()
			B2_Jerkin.gain_jerkin( "Cornhusk Jerkin" )
			B2_Jerkin.equip_jerkin( "Cornhusk Jerkin" )
			
			B2_Candy.reset()
			B2_Candy.gain_candy( "Butterscotch" 	)
			B2_Candy.gain_candy( "Chickenfry Dew" 	)
			
			B2_Gun.reset()
			B2_Gun.add_gun_to_bandolier( B2_Gun.TYPE.GUN_TYPE_PISTOL, 			B2_Gun.MATERIAL.STEEL, 		"BUTT", false )
			B2_Gun.add_gun_to_bandolier( B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN, 	B2_Gun.MATERIAL.MYTHRIL, 	"BUST", false )
			B2_Gun.add_gun_to_bandolier( B2_Gun.TYPE.GUN_TYPE_SHOTGUN,			B2_Gun.MATERIAL.IRON, 		"OMGA", false )
			B2_Gun.add_gun_to_gunbag( B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,		B2_Gun.MATERIAL.STEEL,		"TRSH", true )
			
		1:
			## Etc...
			breakpoint
		_:
			## Etc...
			breakpoint
			
	B2_Music.stop()
	B2_Sound.play( "mgs_gunshot" ) 
	animation_player.play("start_mission")
	await animation_player.animation_finished
	print("Loading V.R. Mission %s room. Good luck." % str(selected_mission + 1) )
	B2_RoomXY.warp_to( "r_combat_tutorial01,0,0" )
