extends Panel

## TODO Actually make this work

signal pressed

@onready var pocket_descript_lbl: 	Label 		= $pocket_descript_lbl
@onready var pocket_item: 			TextureRect = $pocket_item

var item_name 	:= ""
var my_slot		:= 0

func _ready() -> void:
	pocket_item.hide()
	_on_mouse_exited()

func setup_button( _item_name : String, _item_slot : int ) -> void:
	pocket_item.show()
	var candy : Dictionary = B2_Candy.get_candy( _item_name )
	pocket_item.texture.region.position.x = 16.0 * candy["sub"]
			
	item_name 		= _item_name
	my_slot			= _item_slot

func _on_mouse_entered() -> void:
	if item_name:
		pocket_descript_lbl.text = Text.pr(item_name)
	else:
		pocket_descript_lbl.text = Text.pr("Empty")
	modulate = Color.YELLOW

func _on_mouse_exited() -> void:
	if item_name:
		pocket_descript_lbl.text = Text.pr( item_name.left(4).to_upper() )
	else:
		pocket_descript_lbl.text = Text.pr("X")
	modulate = Color.GRAY


func _on_pocket_item_gui_input(event: InputEvent) -> void:
	if item_name: # Do nothing if no item.
		if event is InputEventMouseButton or event is InputEventJoypadButton  or event is InputEventKey:
			if Input.is_action_just_pressed("Action"):
				print(self, ": Button %s pressed." % str(my_slot))
				pressed.emit()
