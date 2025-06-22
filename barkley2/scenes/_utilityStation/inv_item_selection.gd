extends Panel

signal was_selected( my_item : String)

@onready var item_spr: TextureRect = $Control/item_spr
@onready var item_name: Label = $Control/item_name
@onready var item_count: Label = $Control/item_count


const name_color 		:= Color.WHITE
const sel_name_color 	:= Color.YELLOW

var my_item_name : String 		= "Placeholder Item"
var my_item_amount : int 		= randi_range(1,99)
var my_item_data : Dictionary 	= {}

func _ready() -> void:
	if B2_Database.items.has( my_item_name ):
		my_item_data = B2_Database.items.get( my_item_name )
		
	if not my_item_data.is_empty():
		item_spr.texture.region.position.x = int( my_item_data["id"] ) * 16
		item_name.text = str( my_item_name )
		item_count.text = "x" + str( my_item_amount )
		
	_on_focus_exited()
	
func _on_mouse_entered() -> void:
	item_name.modulate 			= sel_name_color
	item_count.modulate 		= sel_name_color
	was_selected.emit( my_item_name )

func _on_mouse_exited() -> void:
	item_name.modulate 			= name_color
	item_count.modulate 		= name_color

func _on_focus_entered() -> void:
	self_modulate = Color.WHITE * 2.0
	
func _on_focus_exited() -> void:
	self_modulate = Color.WHITE * 1.0
