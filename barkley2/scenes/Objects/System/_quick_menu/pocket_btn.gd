extends Panel
## Global foot head tutorial: https://www.youtube.com/watch?v=ZR6Ct_0VYfo
# INFO gabagol
# bagbol
# gabol
#
# a

signal pressed

@onready var pocket_descript_lbl: 	Label 		= $pocket_descript_lbl
@onready var pocket_item: 			TextureRect = $pocket_item

var item_name 	:= ""
var my_slot		:= 0

func _ready() -> void:
	pocket_item.hide()
	_on_mouse_exited()

func setup_button( _item_name : String, _item_slot : int ) -> void:
	item_name 		= _item_name
	my_slot			= _item_slot
	
	if _item_name:
		pocket_item.show()
		var candy : Dictionary = B2_Candy.get_candy( _item_name )
		tooltip_text = _item_name + "\n" + candy["utility"] + "\n" + candy["flavor"]
		pocket_item.texture.region.position.x = 16.0 * candy["sub"]
		_on_mouse_exited()
	else:
		pocket_item.hide()
		_on_mouse_entered()

func _on_mouse_entered() -> void:
	if item_name:
		pocket_descript_lbl.text = Text.pr(item_name)
	else:
		pocket_descript_lbl.text = Text.pr("Empty")
	modulate = Color.YELLOW
	grab_focus()

func _on_mouse_exited() -> void:
	if item_name:
		pocket_descript_lbl.text = Text.pr( item_name.left(4).to_upper() )
	else:
		pocket_descript_lbl.text = Text.pr("X")
	modulate = Color.GRAY

func _input(event: InputEvent) -> void:
	if item_name: # Do nothing if no item.
		if event is InputEventMouseButton or event is InputEventJoypadButton  or event is InputEventKey:
			if Input.is_action_just_pressed("Action") and has_focus():
				#print(self, ": Button %s pressed." % str(my_slot))
				pressed.emit()

func _on_focus_entered() -> void:
	_on_mouse_entered()

func _on_focus_exited() -> void:
	_on_mouse_exited()
