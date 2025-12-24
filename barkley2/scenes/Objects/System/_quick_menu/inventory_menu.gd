@warning_ignore("missing_tool")
extends B2_Border

const ITEM_BTN = preload("res://barkley2/scenes/Objects/System/_quick_menu/item_btn.tscn")

signal closed

@onready var item_list: VBoxContainer = $item_list_panel/ScrollContainer/item_list
@onready var scroll_container: ScrollContainer = $item_list_panel/ScrollContainer

@onready var close_btn: Button = $close_btn
@onready var pg_up_btn: Button = $pg_up_btn
@onready var pg_dn_btn: Button = $pg_dn_btn
@onready var pg_scroll: VScrollBar = $pg_scroll

func _ready() -> void:
	scroll_container.get_v_scroll_bar().value_changed.connect( _on_scroll_container_value_changed )

func flicker( alpha : float ) -> void:
	for c in item_list.get_children():
		c.modulate.a = alpha
	
	pg_scroll.modulate.a = alpha
	pg_up_btn.modulate = Color.WHITE.darkened( alpha * 0.3 )
	pg_dn_btn.modulate = Color.WHITE.darkened( alpha * 0.3 )
	close_btn.modulate = Color.WHITE.darkened( alpha * 0.3 )
	
func update_list() -> void:
	for c in item_list.get_children():
		if is_instance_valid(c):
			c.queue_free()
	
	var player_items := B2_Item.get_items()
	for item in player_items.keys():
		var btn : Button = ITEM_BTN.instantiate()
		btn.my_item_name = item
		btn.my_item_amount = player_items[item]
		btn.name = item + "_btn"
		item_list.add_child( btn, true )
		btn.focus_neighbor_right = pg_up_btn.get_path()
	
	await get_tree().process_frame
	pg_scroll.max_value = scroll_container.get_v_scroll_bar().max_value
	if not item_list.get_children().is_empty():
		pg_up_btn.focus_neighbor_left = item_list.get_children().front().get_path()
	
func _on_close_btn_pressed() -> void:
	closed.emit()

func _on_pg_scroll_value_changed(value: float) -> void:
	#scroll_container.scroll_vertical = value
	scroll_container.get_v_scroll_bar().value = value

func _on_scroll_container_value_changed(value: float) -> void:
	pg_scroll.value = value

func _on_pg_up_btn_pressed() -> void:
	scroll_container.scroll_vertical -= 19

func _on_pg_dn_btn_pressed() -> void:
	scroll_container.scroll_vertical += 19

func _on_visibility_changed() -> void:
	if visible:
		close_btn.grab_focus()
