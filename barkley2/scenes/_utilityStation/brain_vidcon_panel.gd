extends B2_UtilityPanel

const CONFIRMATION_BOX = preload("res://barkley2/scenes/_utilityStation/confirmation_box.tscn")

@export var unbox_btn : Button
@onready var v_box_container: VBoxContainer = $vidcons/ScrollContainer/VBoxContainer
@onready var description_value: Label = $description/main/description_value

@onready var gs_value: Label = $gamerscore/main/gs_value
@onready var open_value: Label = $collection/opened/open_value
@onready var sealed_value: Label = $collection/sealed/sealed_value

var selected_vidcon := 00

func _ready() -> void:
	if unbox_btn:
		unbox_btn.pressed.connect( _unbox_vidcon )
		
	for slot in v_box_container.get_children():
		slot.was_selected.connect( update_description )
		
	#update_description( selected_vidcon )
	update_vidcon_status()

func update_vidcon_status() -> void:
	gs_value.text = 		str( B2_Vidcon.get_experience() )
	open_value.text = 		str( B2_Vidcon.total_unboxed_vidcons() )
	sealed_value.text = 	str( B2_Vidcon.total_boxed_vidcons() )

func update_description( id : int ) -> void:
	print (id)
	if id == 99:
		description_value.text = ""
		if unbox_btn: unbox_btn.disabled = true
	else:
		description_value.text = Text.pr( B2_Vidcon.get_vidcon_description(id) )
		if unbox_btn: unbox_btn.disabled = bool( B2_Vidcon.is_vidcon_unboxed(id) )
		selected_vidcon = id

func _unbox_vidcon() -> void:
	if not B2_Vidcon.is_vidcon_unboxed(selected_vidcon):
		if unbox_btn: unbox_btn.disabled = true
		
		var confirm := CONFIRMATION_BOX.instantiate()
		get_tree().current_scene.add_child(confirm, true)
		confirm.setup_text( Text.pr( "Are you sure you want to unbox '%s' ?" % B2_Vidcon.get_vidcon_name(selected_vidcon) ) )
		confirm.show_panel()
		var choice : bool = await confirm.confirmation
		if choice:
			B2_Vidcon.unbox_vidcon( selected_vidcon )
			_on_visibility_changed()
	else:
		push_error("Trying to unbox an unboxed game.")

func _on_visibility_changed() -> void:
	if is_node_ready():
		update_vidcon_status()
		for c in v_box_container.get_children():
			if c:
				c.update()
