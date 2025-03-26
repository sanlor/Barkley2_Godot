extends Control

@onready var type_btn: CheckButton = $HBoxContainer/HBoxContainer/type_btn
@onready var types: OptionButton = $HBoxContainer/HBoxContainer/types
@onready var mat_btn: CheckButton = $HBoxContainer/HBoxContainer2/mat_btn
@onready var mats: OptionButton = $HBoxContainer/HBoxContainer2/mats

@onready var gun_name: Label = $HBoxContainer/HBoxContainer3/gun_name
@onready var gun_text: TextureRect = $HBoxContainer/HBoxContainer3/gun_text

@onready var accept_dialog: AcceptDialog = $AcceptDialog
@onready var details: Button = $HBoxContainer/details
@onready var detail_text: Label = $AcceptDialog/ScrollContainer/detail_text

@onready var spin: Button = $spin

@onready var timer: Timer = $Timer

@onready var o_cbt_hoopz: B2_HoopzCombatActor = $o_cbt_hoopz

@onready var playfield: Node2D = $playfield

#var my_gun : B2_Weapon

var angle := Vector2.RIGHT


func _ready() -> void:
	for t in B2_Gun.TYPE:
		types.add_item( t )
	for m in B2_Gun.MATERIAL:
		mats.add_item( m )
	
	_on_generate_pressed()

func _on_generate_pressed() -> void:
	var my_mat := B2_Gun.MATERIAL.NONE
	var my_type := B2_Gun.TYPE.GUN_TYPE_NONE
	if type_btn.button_pressed:
		my_type = B2_Gun.TYPE.get( types.get_item_text( types.get_selected_id() ) )
	if mat_btn.button_pressed:
		my_mat = B2_Gun.MATERIAL.get( mats.get_item_text( mats.get_selected_id() ) )
		
	B2_Gun.remove_gun( B2_Gun.get_current_gun() )
	B2_Gun.add_gun( true, my_type, my_mat )
	B2_Sound.play_pick( B2_Gun.get_current_gun().get_swap_sound() )
	
	#my_gun = B2_Gun.generate_gun( my_type, my_mat )
	set_texture()
	set_gun_name()
	set_details()
	print( B2_Gun.get_current_gun().get_full_name() )
	
func set_gun_name():
	gun_name.text = B2_Gun.get_current_gun().get_full_name()
	
func set_texture() :
	gun_text.texture = B2_Gun.get_current_gun().weapon_hud_sprite

func set_details():
	detail_text.text = ""
	detail_text.text += "Material: %s" % str(B2_Gun.MATERIAL.keys()[B2_Gun.get_current_gun().weapon_material])
	detail_text.text += "\n"
	detail_text.text += "Type: %s" % str(B2_Gun.TYPE.keys()[B2_Gun.get_current_gun().weapon_type])
	detail_text.text += "\n"
	detail_text.text += "\n"
	for p in B2_Gun.get_current_gun().material_data.get_property_list():
		detail_text.text += str(p["name"]) + " = " + str( B2_Gun.get_current_gun().material_data.get( p["name"] ) )
		detail_text.text += "\n"
	for p in B2_Gun.get_current_gun().type_data.get_property_list():
		detail_text.text += str(p["name"]) + " = " + str( B2_Gun.get_current_gun().type_data.get( p["name"] ) )
		detail_text.text += "\n"
	pass

func _on_details_pressed() -> void:
	accept_dialog.show()

func update_hoopz():
	o_cbt_hoopz.aim_gun( angle )

func _on_timer_timeout() -> void:
	if spin.button_pressed:
		angle = angle.rotated( TAU / 16.0 )
	update_hoopz()

func _on_shoot_da_gun_pressed() -> void:
	o_cbt_hoopz.shoot_gun()

func _on_spin_minus_pressed() -> void:
	angle = angle.rotated( -TAU / 16.0 )
	update_hoopz()

func _on_spin__pressed() -> void:
	angle = angle.rotated( TAU / 8.0 )
	update_hoopz()
