extends Control
## Main DNET Page

@onready var titles: Label = $bottom_menu/titles

@onready var top_menu: NinePatchRect = $top_menu
@onready var bottom_menu: NinePatchRect = $bottom_menu


@export var info_sfx_player: 		AudioStreamPlayer
@onready var o_dnet_thread: 		Control = $o_dnet_thread
@onready var o_dnet_post: 			Control = $o_dnet_post
@onready var o_dnet_app: 			Control = $o_dnet_app
@onready var o_dnet_rulez: 			Control = $o_dnet_rulez
@onready var o_dnet_muzak: 			Control = $o_dnet_muzak
@onready var o_dnet_chat: 			Control = $o_dnet_chat
@onready var o_dnet_settings: 		Control = $o_dnet_settings
@onready var o_dnet_exit: 			Control = $o_dnet_exit

enum STATUS{HOME,RULEZ,MUSIC,CHAT,SETTINGS,EXIT,FORUM,POST}
const TITLES := {
	STATUS.HOME 		: "Willkommen bei den DwarfNet Foren!",
	STATUS.RULEZ 		: "DwarfNET Regeln und Vorschriften",
	STATUS.MUSIC 		: "Pappys Midihutte",
	STATUS.CHAT 		: "Diskussion",
	STATUS.SETTINGS 	: "Konfiguration",
	STATUS.EXIT 		: "Trennen",
	STATUS.FORUM		: "Placeholder",
	STATUS.POST			: "Placeholder",
	}

var curr_STATUS := STATUS.HOME
var selected_forum := ""

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
	o_dnet_thread.hide()
	o_dnet_post.hide()
	
	## Stop info SFX if playing
	if info_sfx_player:
		info_sfx_player.stop()
	
	match curr_STATUS:
		STATUS.FORUM:
			o_dnet_thread.show()
		STATUS.POST:
			o_dnet_post.show()
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

func _update_status( status : STATUS, title := "" ) -> void:
	if status == STATUS.FORUM:
		titles.text = title
		_forum_builder( title )
	elif status == STATUS.POST:
		titles.text = title
	else:
		titles.text = TITLES[status]
	curr_STATUS = status
	
	_manage_windows()

func _forum_builder( forum_name : String ) -> void:
	match forum_name:
		"Fehlersuche":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "troubleshoot bootybass" )
		"Netz-comic":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "webcomix quack" )
			o_dnet_thread.add_thread( "webcomix help" )
		"Edelsteine":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "gemstones rules", 1)
			o_dnet_thread.add_thread( "gemstones raincoat");
			o_dnet_thread.add_thread( "gemstones rubyfever");
			o_dnet_thread.add_thread( "gemstones song");
		"Videospiele":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "vidcons imdone");
			o_dnet_thread.add_thread( "vidcons lore");
			o_dnet_thread.add_thread( "vidcons patchnotes");
			o_dnet_thread.add_thread( "vidcons jones boom");
		"Frucht":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "fruit apple");
			o_dnet_thread.add_thread( "fruit grapes");
			o_dnet_thread.add_thread( "fruit orange");
			o_dnet_thread.add_thread( "fruit cherry");
			o_dnet_thread.add_thread( "fruit banana");
			o_dnet_thread.add_thread( "fruit banana double");
		"Romantik":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "dating eric");
			o_dnet_thread.add_thread( "dating mojitos");
			o_dnet_thread.add_thread( "dating sanicstory");
			o_dnet_thread.add_thread( "dating anyone");
			o_dnet_thread.add_thread( "dating newcomer");
		"Glauben":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "religion dwarfism");
			o_dnet_thread.add_thread( "religion poem");
		"Anzeigen":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "ads zauber" )
			o_dnet_thread.add_thread( "ads vidcon collection" )
			o_dnet_thread.add_thread( "ads compson" )
		"Politik":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "politix saveswamps");
		"Sport/LARP":
			o_dnet_thread.clear_threads()
			o_dnet_thread.add_thread( "sports kyphosis");
			o_dnet_thread.add_thread( "sports adventure");
			o_dnet_thread.add_thread( "sports garfunkel0");
			
	selected_forum = forum_name
	
func _on_forum_salutations_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Fehlersuche" )

func _on_forum_comix_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Netz-comic" )

func _on_forum_gems_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Edelsteine" )

func _on_forum_vydia_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Videospiele" )

func _on_forum_fruit_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Frucht" )

func _on_forum_dating_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Romantik" )

func _on_forum_religion_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Glauben" )

func _on_forum_ads_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Anzeigen" )

func _on_forum_politic_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Politik" )

func _on_forum_madden_button_pressed() -> void:
	_update_status( STATUS.FORUM, "Sport/LARP" )


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

func _on_o_dnet_thread_thread_pressed( thread_name: String ) -> void:
	_update_status( STATUS.POST, thread_name )
	o_dnet_post.post_dem_posts( thread_name )
