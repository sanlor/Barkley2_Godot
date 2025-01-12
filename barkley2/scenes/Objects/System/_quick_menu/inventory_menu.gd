extends B2_Border

const ITEM_BTN = preload("res://barkley2/scenes/Objects/System/_quick_menu/item_btn.tscn")

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
	
func update_list() -> void:
	for c in item_list.get_children():
		if is_instance_valid(c):
			c.queue_free()
	
	var player_items := B2_Item.get_items()
	for item in player_items.keys():
		var btn = ITEM_BTN.instantiate()
		btn.my_item_name = item
		btn.my_item_amount = player_items[item]
		btn.name = item + "_btn"
		item_list.add_child( btn, true )
	
func _on_close_btn_pressed() -> void:
	closed.emit()
