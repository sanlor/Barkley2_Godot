extends B2_UtilityPanel

@export var make_btn : Button ## Button to make Candies.

@onready var pockets: GridContainer = $pockets
@onready var schemes: GridContainer = $schemes

@onready var jerkin_name: 		Label 			= $jerkin/jerkin_name
@onready var jerkin_texture: 	TextureRect 	= $jerkin/jerkin_texture
@onready var jerking_pocket: 	Label 			= $jerkin/jerking_pocket

@onready var item_icon: TextureRect = $curr_scheme/candy_image/item_icon
@onready var candy_name: Label = $curr_scheme/candy_description/candy_name
@onready var candy_effect: Label = $curr_scheme/candy_description/candy_effect

@onready var smelt_gauge: TextureRect = $smelt/smelt_panel/smelt_gauge
@onready var smelt_value: Label = $smelt/smelt_panel/smelt_value
@onready var smelt_cost_value: Label = $smelt/smelt_panel/smelt_cost_value


var my_item : String

func _ready() -> void:
	if make_btn:
		make_btn.pressed.connect( smelt_candy )

func update_menu() -> void:
	if not is_node_ready():
		return

func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
		
	update_pockets()
	update_curr_scheme()
	update_smelt_gauge()
	
func update_pockets() -> void:
	for i : int in B2_Jerkin.get_jerkin_stats( B2_Jerkin.get_current_jerkin() )["Pkt"]:
		var btn := pockets.get_children()[i]
		btn.is_disabled = false
		btn.update_tile( B2_Jerkin.get_pocket_content(i) )

func update_curr_scheme() -> void:
	for i in B2_Candy.list_recipes().size():
		var btn := schemes.get_children()[i]
		btn.is_disabled = false
		btn.is_selectable = true
		btn.update_tile( B2_Candy.list_recipes()[i] )
		
	if my_item.is_empty():
		item_icon.hide()
		candy_name.text = ""
		candy_effect.text = ""
		if make_btn: make_btn.disabled = true # Cant make candy if nothing is selected.
		return
		
	if make_btn and B2_Jerkin.pockets_free() > 0: # Only enable the button if therer ar pockets free
		if B2_Config.get_user_save_data( "ustation.smelt", 0 ) - B2_Candy.CANDY_LIST[my_item][B2_Candy.SMELT] >= 0: ## Check for avaiable smelt points
			make_btn.disabled = false
		else:
			print(name + ": No smelt points - " + str( B2_Config.get_user_save_data( "ustation.smelt", 0 ) ) )
	else:
		print(name + ": No free pockets")
			
	item_icon.show()
		
	jerkin_name.text 							= Text.pr( B2_Jerkin.get_current_jerkin() )
	jerking_pocket.text 						= Text.pr( "POCKETS: %s" % B2_Jerkin.get_jerkin_stats()["Pkt"] )
	jerkin_texture.texture.region.position.x 	= 24.0 * B2_Jerkin.get_jerkin_stats()["Sub"]
	
	## Curr Candy
	item_icon.texture.region.position.x 		= 16.0 * B2_Candy.CANDY_LIST[my_item][B2_Candy.SUB]
	candy_name.text 							= Text.pr( my_item )
	candy_effect.text 							= Text.pr( B2_Candy.CANDY_LIST[my_item][B2_Candy.DESCRIPTION] )
	
	update_smelt_gauge()

func update_smelt_gauge() -> void:
	##  Smelt Gauge
	var smelt : float 							= B2_Config.get_user_save_data("ustation.smelt", 0.0)
	smelt_value.text 							= str( int( smelt ) ) #str( int( smelt / 1000.0) )
	smelt_gauge.texture.region.position.x 		= 176.0 * roundf( (smelt / 1000.0) * 45 )
	if my_item.is_empty():
		smelt_cost_value.text = ""
	else:
		smelt_cost_value.text = "- %s" % str( B2_Candy.CANDY_LIST[my_item][B2_Candy.SMELT] )

func smelt_candy() -> void:
	if make_btn:
		if B2_Jerkin.pockets_free() > 0:
			if B2_Config.get_user_save_data( "ustation.smelt", 0 ) - B2_Candy.CANDY_LIST[my_item][B2_Candy.SMELT] >= 0:
				B2_Config.set_user_save_data( "ustation.smelt", B2_Config.get_user_save_data( "ustation.smelt", 0 ) - B2_Candy.CANDY_LIST[my_item][B2_Candy.SMELT] )
				B2_Jerkin.add_pocket_content( my_item )
				B2_Sound.play( "hoopz_crunchcandy" )
				update_pockets()
				update_smelt_gauge()
				
				if B2_Jerkin.pockets_free() <= 0:
					make_btn.disabled = true
			else:
				print(name + ": No smelt points - " + str( B2_Config.get_user_save_data( "ustation.smelt", 0 ) ) )
		else:
			print(name + ": No free pockets")
	else:
		print(name + ": No button????")

func select_recipe( _my_item ) -> void:
	my_item = _my_item
	update_curr_scheme()
	print("Selected recipe %s." % _my_item)
