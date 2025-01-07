@tool
extends B2_Border

@onready var maps_btn: Button = $maps_btn
@onready var notes_btn: Button = $notes_btn
@onready var chat_btn: Button = $chat_btn
@onready var items_btn: Button = $items_btn
@onready var o_btn: Button = $o_btn

## NOTE Yep. Im not dumb, I know you can do this using themes, but not the flickering. The flickering forced me to do this weird setup.

const sel_btn := Color.YELLOW
const norm_btn := Color.ORANGE

func _post_ready() -> void:
	maps_btn.mouse_entered.connect( _on_mouse_entered.bind(maps_btn) )
	notes_btn.mouse_entered.connect( _on_mouse_entered.bind(notes_btn) )
	chat_btn.mouse_entered.connect( _on_mouse_entered.bind(chat_btn) )
	items_btn.mouse_entered.connect( _on_mouse_entered.bind(items_btn) )
	o_btn.mouse_entered.connect( _on_mouse_entered.bind(o_btn) )
	
	maps_btn.mouse_exited.connect( _on_mouse_exited.bind(maps_btn) )
	notes_btn.mouse_exited.connect( _on_mouse_exited.bind(notes_btn) )
	chat_btn.mouse_exited.connect( _on_mouse_exited.bind(chat_btn) )
	items_btn.mouse_exited.connect( _on_mouse_exited.bind(items_btn) )
	o_btn.mouse_exited.connect( _on_mouse_exited.bind(o_btn) )

func _on_mouse_entered( btn : Button ) -> void:
	btn.get_child(0).modulate = sel_btn
	
func _on_mouse_exited( btn : Button ) -> void:
	btn.get_child(0).modulate = norm_btn

func flicker( alpha : float ) -> void:
	maps_btn.get_child(0).self_modulate.a = alpha
	notes_btn.get_child(0).self_modulate.a = alpha
	chat_btn.get_child(0).self_modulate.a = alpha
	items_btn.get_child(0).self_modulate.a = alpha
	o_btn.get_child(0).self_modulate.a = alpha
