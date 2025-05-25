extends Button

const S_JERKIN 	= preload("uid://cvyp0k17ke0yg")
const S_CANDY 	= preload("uid://ckdra5vpxt43g")

@export var folded_size := 24
@export var unfolded_size := 70

@onready var item_icon: 		TextureRect 	= $MarginContainer/VBoxContainer/item_summary/item_icon
@onready var item_name: 		Label 			= $MarginContainer/VBoxContainer/item_summary/item_name
@onready var item_cost: 		Label 			= $MarginContainer/VBoxContainer/item_summary/item_cost

@onready var item_stats: 		HBoxContainer 	= $MarginContainer/VBoxContainer/item_stats
@onready var evs_value: 		Label 			= $MarginContainer/VBoxContainer/item_stats/evs/evs_value
@onready var weight_value: 		Label 			= $MarginContainer/VBoxContainer/item_stats/weight/weight_value
@onready var pockets_value: 	Label 			= $MarginContainer/VBoxContainer/item_stats/pockets/pockets_value

@onready var resistence_graph: 	Control 		= $MarginContainer/VBoxContainer/item_stats/resistence/resistence_graph

@onready var item_description: 	Label 			= $MarginContainer/VBoxContainer/item_description
enum TYPE{GUN, JERKIN, RECIPE, VIDCON}

@export var my_item 		:= ""
@export var my_item_type 	:= TYPE.JERKIN
@export var my_item_cost		:= 10
var my_item_data : Dictionary

var item_tween : Tween

func _ready() -> void:
	custom_minimum_size.y = folded_size
	
	if my_item_type == TYPE.JERKIN:
		my_item_data = B2_Jerkin.get_jerkin_stats( my_item )
		item_icon.texture.atlas 				= S_JERKIN
		item_icon.texture.region.size 			= Vector2(24,24)
		item_icon.texture.region.position.x 	= int( my_item_data["Sub"] ) * 24
		item_name.text							= Text.pr( my_item )
		item_cost.text							= "£" + str(my_item_cost)
		
		item_stats.show()
		evs_value.text			= str( my_item_data["Fsh"] )
		pockets_value.text		= str( my_item_data["Pkt"] )
		weight_value.text 		= str( my_item_data["Wgt"] )
		
		resistence_graph.generic_res 		+= -my_item_data["Normal"]
		resistence_graph.bio_res			+= -my_item_data["Bio"]
		resistence_graph.cyber_res			+= -my_item_data["Cyber"]
		resistence_graph.mental_res			+= -my_item_data["Mental"]
		resistence_graph.cosmic_res			+= -my_item_data["Kosmic"]
		resistence_graph.zauber_res			+= -my_item_data["Zauber"]
		
		item_description.text 	= Text.pr( my_item_data["Description"] )
		
		folded_size 	= 24
		unfolded_size 	= 70
		
	if my_item_type == TYPE.RECIPE:
		my_item_data = B2_Candy.get_candy( my_item )
		item_icon.texture.atlas 				= S_CANDY
		item_icon.texture.region.size 			= Vector2(16,16)
		item_icon.texture.region.position.x 	= int( my_item_data["sub"] ) * 16
		item_name.text							= Text.pr( my_item + " Recipe" )
		item_cost.text							= "£" + str(my_item_cost)
		
		item_stats.hide()
		
		item_description.text 	= Text.pr( my_item_data["utility"] )
		
		folded_size 	= 20
		unfolded_size 	= 44
	
	if B2_Playerdata.Quest("money") < my_item_cost:
		item_cost.modulate = Color.ORANGE_RED
	else:
		item_cost.modulate = Color.LIGHT_GRAY
		
	_shrink_button()
	
func _on_pressed() -> void:
	_expand_button()

func _on_focus_entered() -> void:
	#_shrink_button()
	_expand_button()

func _on_focus_exited() -> void:
	_shrink_button()

func _shrink_button() -> void:
	if item_tween:
		item_tween.kill()
	item_tween = create_tween()
	item_tween.tween_property( self, "custom_minimum_size:y", folded_size, 0.1 )
	
	evs_value.modulate 			= Color.LIGHT_GRAY
	weight_value.modulate 		= Color.LIGHT_GRAY
	pockets_value.modulate 		= Color.LIGHT_GRAY
	item_name.modulate 			= Color.LIGHT_GRAY
	
	if B2_Playerdata.Quest("money") < my_item_cost:
		item_cost.modulate = Color.ORANGE_RED
	else:
		item_cost.modulate = Color.LIGHT_GRAY

func _expand_button() -> void:
	if item_tween:
		item_tween.kill()
	item_tween = create_tween()
	item_tween.tween_property( self, "custom_minimum_size:y", unfolded_size, 0.1 )
	
	evs_value.modulate 			= Color.YELLOW
	weight_value.modulate 		= Color.YELLOW
	pockets_value.modulate 		= Color.YELLOW
	item_name.modulate 			= Color.YELLOW
	
	if B2_Playerdata.Quest("money") < my_item_cost:
		item_cost.modulate = Color.RED
	else:
		item_cost.modulate = Color.YELLOW
