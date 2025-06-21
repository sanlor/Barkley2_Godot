extends Panel

@export var candy_panel : 	B2_UtilityPanel
@onready var item_icon: 	TextureRect 	= $item_icon
@onready var item_value: 	Label 			= $item_value

@export var is_selectable	:= false
var is_disabled 			:= true
var my_item					:= ""

func _ready() -> void:
	item_icon.hide()
	#item_value.hide()
	update_tile( my_item )
	
	if is_selectable:
		if has_focus():
			_on_focus_entered()
		else:
			_on_focus_exited()

func update_tile( _my_item : String ) -> void:
	if my_item != _my_item:
		my_item = _my_item
		glow()
		
	if is_disabled:
		focus_mode = Control.FOCUS_NONE
		item_value.text = Text.pr( "X" )
		item_value.modulate = Color.DIM_GRAY
		return
		
	if is_selectable:
		focus_mode = Control.FOCUS_ALL
		
	## No item in Pocket
	if my_item.is_empty():
		item_value.text = Text.pr( "NONE" )
		item_value.modulate = Color.WHITE
		item_value.show()
		return
	item_value.hide()
	item_icon.show()
	item_icon.texture.region.position.x = 16.0 * B2_Candy.CANDY_LIST[my_item][ B2_Candy.SUB ]
	
func glow() -> void:
	modulate = Color.WHITE * 2.0
	var t := create_tween()
	t.tween_property( self, "modulate", Color.WHITE * 1.0, 0.2 )
	
func _on_focus_entered() -> void:
	if is_selectable:
		if candy_panel:
			candy_panel.select_recipe( my_item )
		self_modulate = Color.WHITE * 2.0
	
func _on_focus_exited() -> void:
	if is_selectable:
		self_modulate = Color.WHITE * 1.0
