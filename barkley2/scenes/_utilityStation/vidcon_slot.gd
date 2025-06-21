extends HBoxContainer

signal was_selected( id : int )

@onready var id_value: 			Label = $id/id_value
@onready var vidcon_value: 		Label = $name/vidcon_value
@onready var icon_text: 		TextureRect = $icon/icon_text


@export var selected := false
var my_id := 00

func _ready() -> void:
	my_id = int( name.right(2) ) - 1
	id_value.text = name.right(2)
	update()
	
func update() -> void:
	icon_text.hide()
	if B2_Vidcon.has_vidcon( my_id ):
		icon_text.show()
		vidcon_value.text = Text.pr( B2_Vidcon.get_vidcon_name(my_id) )
		
		if B2_Vidcon.is_vidcon_unboxed( my_id ):
			icon_text.texture.region.position.x = 0.0
		else:
			icon_text.texture.region.position.x = 15.0
	else:
		vidcon_value.text = ""
	
	if selected:
		_on_focus_entered()

func _on_focus_entered() -> void:
	for c in get_children():
		if c is Panel:
			c.self_modulate = Color.WHITE * 2.0
	selected = true
	
	if B2_Vidcon.has_vidcon( my_id ):
		was_selected.emit( my_id )
	else:
		was_selected.emit( 99 )
	
func _on_focus_exited() -> void:
	for c in get_children():
		if c is Panel:
			c.self_modulate = Color.WHITE * 1.0
	selected = false
