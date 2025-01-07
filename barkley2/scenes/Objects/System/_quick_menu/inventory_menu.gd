extends B2_Border

signal closed

@onready var item_list: VBoxContainer = $item_list_panel/item_list

@onready var close_btn: Button = $close_btn
@onready var pg_up_btn: Button = $pg_up_btn
@onready var pg_dn_btn: Button = $pg_dn_btn
@onready var page_count: Label = $page_count


func flicker( alpha : float ) -> void:
	for c in item_list.get_children():
		c.modulate.a = alpha
	
	page_count.modulate.a = alpha
	pg_up_btn.modulate = Color.WHITE.darkened( alpha * 0.3 )
	pg_dn_btn.modulate = Color.WHITE.darkened( alpha * 0.3 )
	close_btn.modulate = Color.WHITE.darkened( alpha * 0.3 )
	
func _on_close_btn_pressed() -> void:
	closed.emit()
