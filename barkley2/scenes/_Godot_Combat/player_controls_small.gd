extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var defend_btn: 	Button = $menu_space/defend_btn
@onready var attack_btn: 	Button = $menu_space/ScrollContainer/VBoxContainer/attack_btn
@onready var skill_btn: 	Button = $menu_space/ScrollContainer/VBoxContainer/skill_btn
@onready var item_btn: 		Button = $menu_space/ScrollContainer/VBoxContainer/item_btn
@onready var escape_btn: 	Button = $menu_space/ScrollContainer/VBoxContainer/escape_btn
@onready var move_btn: 		Button = $menu_space/move_btn

func disable_all_buttons( disabled : bool ) -> void:
	attack_btn.disabled 	= disabled
	skill_btn.disabled 		= disabled
	item_btn.disabled 		= disabled
	escape_btn.disabled 	= disabled
	move_btn.disabled 		= disabled
	defend_btn.disabled 	= disabled

func _ready() -> void:
	#position.y = 192.0 # default hidden
	pass

func show_menu() -> void:
	show()
	animation_player.play("show")
	disable_all_buttons( false )
	B2_Sound.play("sn_mouse_analoghover01")
	await animation_player.animation_finished
	attack_btn.grab_focus()
	
func hide_menu() -> void:
	animation_player.play("hide")
	disable_all_buttons( true )
	B2_Sound.play("sn_mouse_analoghover01")
	await animation_player.animation_finished
	hide()
