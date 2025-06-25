@tool
extends HBoxContainer

signal button_pressed

enum INFO{ADS,DATING,EXIT,FRUIT,GEMSTONES,POLITIX,RELIGION,SALUTATIONS,VIDCONS,WEBCOMIX}
const INFO_SFX := {
	INFO.ADS : 			preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_ads.ogg"),
	INFO.DATING : 		preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_dating.ogg"),
	INFO.EXIT : 		preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_exit.ogg"),
	INFO.FRUIT : 		preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_fruit.ogg"),
	INFO.GEMSTONES : 	preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_gemstones.ogg"),
	INFO.POLITIX : 		preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_politix.ogg"),
	INFO.RELIGION : 	preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_religion.ogg"),
	INFO.SALUTATIONS : 	preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_salutations.ogg"),
	INFO.VIDCONS : 		preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_vidcons.ogg"),
	INFO.WEBCOMIX : 	preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_subforum_webcomix.ogg"),
	}

@onready var forum_panel		: NinePatchRect = $forum_panel
@onready var forum_text_lbl		: Label = $forum_panel/forum_text_lbl
@onready var forum_icon_tex		: TextureRect = $forum_panel/forum_icon_tex
	
@export var info_sfx_player 	: AudioStreamPlayer
@export var info_audio			: INFO
@export var forum_icon 			:= 0
@export var forum_text			:= "Placeholder"

@export_tool_button("Update Icon") var _update : Callable = update_button

func _ready() -> void:
	update_button()

func update_button() -> void:
	forum_text_lbl.text = forum_text
	forum_icon_tex.texture.region.position.x = forum_icon * 29

func _on_forum_panel_focus_entered() -> void:
	light_up( true )

func _on_forum_panel_mouse_entered() -> void:
	light_up( true )

func _on_forum_panel_focus_exited() -> void:
	light_up( false )

func _on_forum_panel_mouse_exited() -> void:
	if not forum_panel.has_focus():
		light_up( false )

func light_up( enabled : bool ) -> void:
	if enabled:
		forum_panel.texture.region.position.x = 30.0
	else:
		forum_panel.texture.region.position.x = 0.0

func _on_info_btn_pressed() -> void:
	if info_sfx_player:
		info_sfx_player.stream = INFO_SFX[info_audio]
		info_sfx_player.play()
	else:
		push_error("info_sfx_player not set.")

func _on_forum_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventKey:
		if forum_panel.has_focus():
			if Input.is_action_just_pressed("Action"):
				## TODO Add SFX (Like the one used on old Internet explorer when you clicked on a link)
				button_pressed.emit()
