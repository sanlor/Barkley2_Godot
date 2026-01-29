extends B2_UtilityPanel

const INV_ITEM_SELECTION = preload("res://barkley2/scenes/_utilityStation/inv_item_selection.tscn")

@onready var item_list: VBoxContainer = $items/items/ScrollContainer/item_list
@onready var descr_value: Label = $description/descr/descr_value
@onready var scroll_container: ScrollContainer = $items/items/ScrollContainer

var utilityHue : int = B2_Playerdata.Quest("playerGumballColor") 	## Utility line 2509
var grid_color := Color.from_rgba8(utilityHue, 128, 255)			## Utility line 34

func _ready() -> void:
	descr_value.text = ""
	scroll_container.self_modulate = Color(grid_color, 0.500)

func update_menu() -> void:
	if not is_node_ready():
		return
		
	for i in item_list.get_children():
		i.queue_free()
		
	var player_items := B2_Item.get_items()
	for item in player_items.keys():
		var btn : Panel = INV_ITEM_SELECTION.instantiate()
		btn.my_item_name = item
		btn.my_item_amount = player_items[item]
		btn.name = item + "_btn"
		btn.was_selected.connect( _update_description )
		item_list.add_child( btn, true )
		
	## No items :(
	if item_list.get_children().is_empty():
		descr_value.text = Text.pr("No items in inventory.")
		
func _update_description( my_item : String ) -> void:
	descr_value.text = Text.pr( B2_Database.items.get(my_item)["description"] )
		
func _on_visibility_changed() -> void:
	update_menu()
