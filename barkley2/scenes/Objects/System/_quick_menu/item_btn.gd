extends Button

@onready var item_spr: 			TextureRect = $item_spr
@onready var item_name: 		Label = $item_name
@onready var item_count: 		Label = $item_count
@onready var item_description: 	Label = $item_description

const itemHeight := 20.0

const name_color 		:= Color.ORANGE
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
		item_description.text = str( my_item_data["description"] )
	
	_on_mouse_exited()
	
func _on_mouse_entered() -> void:
	item_name.modulate 			= sel_name_color
	item_count.modulate 		= sel_name_color
	item_description.modulate 	= sel_name_color
	change_muh_size( true )

func _on_mouse_exited() -> void:
	item_name.modulate 			= name_color
	item_count.modulate 		= name_color
	item_description.modulate 	= name_color
	change_muh_size( false )

func change_muh_size(toggled_on : bool):
	custom_minimum_size.y = 0
	if toggled_on:
		size.y = (itemHeight * 2) + 4
	else:
		size.y = itemHeight
	custom_minimum_size.y = size.y

func _on_focus_entered() -> void:
	_on_mouse_entered()

func _on_focus_exited() -> void:
	await get_tree().process_frame
	_on_mouse_exited()

func _on_pressed() -> void:
	pass
