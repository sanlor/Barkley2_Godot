@tool
extends B2_Border

var tween : Tween

@export var gun_name_panel: Control

@onready var ammo_title: Label = $ammo_title
@onready var wgt_title: Label = $wgt_title
@onready var gunbag_title: Label = $gun_bag/gunbag_title
@onready var gun_list: VBoxContainer = $gun_list


const x_hidden 	:= -100.0
const x_shown	:= 0.0
const t_speed	:= 1.0

func _post_ready() -> void:
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)
	
	_on_mouse_exited()

func flicker( alpha : float ) -> void:
	for c in gun_name_panel.get_children():
		if c is not B2_Border and c is not B2_Border_Foreground:
			c.modulate.a = alpha
			
	ammo_title.modulate.a = alpha
	wgt_title.modulate.a = alpha
	gunbag_title.modulate.a = alpha
	
	for c in gun_list.get_children():
		if c is Button:
			for btn in c.get_children():
				btn.modulate.a = alpha

func _on_mouse_entered() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property( gun_name_panel, "position:x", x_shown, t_speed ).set_trans(Tween.TRANS_SPRING)

func _on_mouse_exited() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property( gun_name_panel, "position:x", x_hidden, t_speed ).set_trans(Tween.TRANS_SPRING)
