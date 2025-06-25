extends Control
## Main DNET Page

@onready var titles: Label = $bottom_menu/titles

@onready var top_menu: NinePatchRect = $top_menu
@onready var bottom_menu: NinePatchRect = $bottom_menu


@export var info_sfx_player 	: AudioStreamPlayer
@onready var o_dnet_app: 			Control = $o_dnet_app
@onready var o_dnet_rulez: 			Control = $o_dnet_rulez
@onready var o_dnet_muzak: 			Control = $o_dnet_muzak
@onready var o_dnet_chat: 			Control = $o_dnet_chat
@onready var o_dnet_settings: 		Control = $o_dnet_settings
@onready var o_dnet_exit: 			Control = $o_dnet_exit

enum STATUS{HOME,RULEZ,MUSIC,CHAT,SETTINGS,EXIT,FORUM}
const TITLES := {
	STATUS.HOME 		: "Willkommen bei den DwarfNet Foren!",
	STATUS.RULEZ 		: "DwarfNET Regeln und Vorschriften",
	STATUS.MUSIC 		: "Pappys Midihutte",
	STATUS.CHAT 		: "Diskussion",
	STATUS.SETTINGS 	: "Konfiguration",
	STATUS.EXIT 		: "Trennen",
	STATUS.FORUM		: "Placeholder",
	}

var curr_STATUS := STATUS.HOME

func surf_the_web() -> void:
	B2_Screen.set_cursor_type( B2_Screen.TYPE.HAND )
	B2_Playerdata.Quest( "dwarfnet_skin_system", randi_range(0,3) )
	_update_status( STATUS.HOME )

func _manage_windows() -> void:
	o_dnet_rulez.hide()
	o_dnet_app.hide()
	o_dnet_muzak.hide()
	o_dnet_chat.hide()
	o_dnet_settings.hide()
	o_dnet_exit.hide()
	
	## Stop info SFX if playing
	if info_sfx_player:
		info_sfx_player.stop()
	
	match curr_STATUS:
		STATUS.HOME:
			o_dnet_app.show()
		STATUS.RULEZ:
			o_dnet_rulez.show()
		STATUS.MUSIC:
			o_dnet_muzak.show()
		STATUS.CHAT:
			o_dnet_chat.show()
		STATUS.SETTINGS:
			o_dnet_settings.show()
		STATUS.EXIT:
			o_dnet_exit.show()
		_:
			push_error("Weird window state.")
			_update_status( STATUS.HOME )
			

func change_menu_color( color : Color ) -> void:
	top_menu.self_modulate = color
	bottom_menu.self_modulate = color

func _update_status( status : STATUS ) -> void:
	titles.text = TITLES[status]
	curr_STATUS = status
	
	_manage_windows()

func _on_forum_salutations_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_comix_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_gems_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_vydia_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_fruit_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_dating_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_religion_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_ads_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_politic_button_pressed() -> void:
	_update_status( STATUS.FORUM )

func _on_forum_madden_button_pressed() -> void:
	_update_status( STATUS.FORUM )


func _on_app_home_pressed() -> void:
	_update_status( STATUS.HOME )

func _on_app_rules_pressed() -> void:
	_update_status( STATUS.RULEZ )

func _on_app_music_pressed() -> void:
	_update_status( STATUS.MUSIC )

func _on_app_chat_pressed() -> void:
	_update_status( STATUS.CHAT )

func _on_app_settings_pressed() -> void:
	_update_status( STATUS.SETTINGS )

func _on_app_exit_pressed() -> void:
	_update_status( STATUS.EXIT )
