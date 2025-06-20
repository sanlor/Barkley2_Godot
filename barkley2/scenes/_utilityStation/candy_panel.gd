extends B2_UtilityPanel

@onready var pockets: GridContainer = $pockets
@onready var schemes: GridContainer = $schemes

@onready var jerkin_name: 		Label 			= $jerkin/jerkin_name
@onready var jerkin_texture: 	TextureRect 	= $jerkin/jerkin_texture
@onready var jerking_pocket: 	Label 			= $jerkin/jerking_pocket

var my_item : String

func update_menu() -> void:
	if not is_node_ready():
		return

func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
		
	for i : int in B2_Jerkin.get_jerkin_stats( B2_Jerkin.get_current_jerkin() )["Pkt"]:
		var btn := pockets.get_children()[i]
		btn.is_disabled = false
		btn.update_tile( B2_Jerkin.get_pocket_content(i) )
		
	for i in B2_Candy.list_recipes().size():
		var btn := schemes.get_children()[i]
		btn.is_disabled = false
		btn.is_selectable = true
		btn.update_tile( B2_Candy.list_recipes()[i] )
		
	jerkin_name.text 							= Text.pr( B2_Jerkin.get_current_jerkin() )
	jerking_pocket.text 						= Text.pr( "POCKETS: %s" % B2_Jerkin.get_jerkin_stats()["Pkt"] )
	jerkin_texture.texture.region.position.x 	= 24.0 * B2_Jerkin.get_jerkin_stats()["Sub"]

func select_recipe( _my_item ) -> void:
	my_item = _my_item
	print("Selected recipe %s." % _my_item)
