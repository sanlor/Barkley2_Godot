extends Control

signal menu_closed

@onready var bg_1: TextureRect = $bg1
@onready var gun_map: 				TextureRect = $bg1/VBoxContainer/gun_lineage/gun_map
@onready var gun_marker_bottom: 	TextureRect = $bg1/VBoxContainer/gun_lineage/gun_map/gun_marker_bottom
@onready var gun_marker_top: 		TextureRect = $bg1/VBoxContainer/gun_lineage/gun_map/gun_marker_top
@onready var gun_marker_occupied: 	TextureRect = $bg1/VBoxContainer/gun_lineage/gun_map/gun_marker_occupied

@onready var gun_name: 			Label = $bg1/VBoxContainer/gun_summary/VBoxContainer/gun_name
@onready var gun_texture: 		TextureRect = $bg1/VBoxContainer/gun_summary/VBoxContainer/gun_texture

@onready var prefix_1_name: 			Label = $bg1/VBoxContainer/gun_summary/VBoxContainer2/prefix1/prefix1_name
@onready var prefix_1_description: 		Label = $bg1/VBoxContainer/gun_summary/VBoxContainer2/prefix1/prefix1_description
@onready var prefix_2_name: 			Label = $bg1/VBoxContainer/gun_summary/VBoxContainer2/prefix2/prefix2_name
@onready var prefix_2_description: 		Label = $bg1/VBoxContainer/gun_summary/VBoxContainer2/prefix2/prefix2_description
@onready var suffix_name: 				Label = $bg1/VBoxContainer/gun_summary/VBoxContainer2/suffix/suffix_name
@onready var suffix_description: 		Label = $bg1/VBoxContainer/gun_summary/VBoxContainer2/suffix/suffix_description

@onready var dmg_value: Label = $bg1/VBoxContainer/gun_stats/dmg/dmg_value
@onready var rte_value: Label = $bg1/VBoxContainer/gun_stats/rte/rte_value
@onready var cap_value: Label = $bg1/VBoxContainer/gun_stats/cap/cap_value
@onready var afx_value: Label = $bg1/VBoxContainer/gun_stats/afx/afx_value
@onready var wgt_value: Label = $bg1/VBoxContainer/gun_stats/wgt/wgt_value

## Lineage
@onready var d_prefix_1_label: 	Label = $bg1/VBoxContainer/gun_lineage/lineage/daddy_cont/prefix_1_label
@onready var d_prefix_2_label: 	Label = $bg1/VBoxContainer/gun_lineage/lineage/daddy_cont/prefix_2_label
@onready var d_name_label: 		Label = $bg1/VBoxContainer/gun_lineage/lineage/daddy_cont/name_label
@onready var d_suffix_label: 	Label = $bg1/VBoxContainer/gun_lineage/lineage/daddy_cont/suffix_label
@onready var m_prefix_1_label: 	Label = $bg1/VBoxContainer/gun_lineage/lineage/mommy_cont/prefix_1_label
@onready var m_prefix_2_label: 	Label = $bg1/VBoxContainer/gun_lineage/lineage/mommy_cont/prefix_2_label
@onready var m_name_label: 		Label = $bg1/VBoxContainer/gun_lineage/lineage/mommy_cont/name_label
@onready var m_suffix_label: 	Label = $bg1/VBoxContainer/gun_lineage/lineage/mommy_cont/suffix_label


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var my_gun : B2_Weapon

var t := 0.0

func _setup_menu() -> void:
	if not my_gun:
		push_error("Gun not loaded.")
		return
		
	prefix_1_name.modulate 			= Color.YELLOW
	prefix_1_description.modulate 	= Color.WHITE
	prefix_2_name.modulate 			= Color.YELLOW
	prefix_2_description.modulate 	= Color.WHITE
	suffix_name.modulate 			= Color.YELLOW
	suffix_description.modulate 	= Color.WHITE
		
	gun_texture.texture 	= my_gun.get_weapon_hud_sprite()
	gun_name.text 			= Text.pr( my_gun.weapon_name )
	
	dmg_value.text 		= str( int( my_gun.get_att() ) )
	rte_value.text		= str( int( my_gun.get_spd() ) ) ## THIS IS WRONG
	cap_value.text		= str( my_gun.max_ammo )
	afx_value.text		= str( my_gun.afx_count() )
	wgt_value.text		= str( my_gun.wgt ) + "ç"
	
	gun_map.texture 				= 	B2_Gunmap.get_gun_map()
	gun_marker_bottom.position 		= B2_Gunmap.get_gun_map_position( 0, my_gun.weapon_name )
	gun_marker_top.position 		= B2_Gunmap.get_gun_map_position( 1, my_gun.weapon_name )
	gun_marker_occupied.position 	= B2_Gunmap.get_gun_map_position( 2, my_gun.weapon_name )
	
	if my_gun.prefix1:
		prefix_1_name.text = Text.pr( my_gun.prefix1 )
		prefix_1_description.text = Text.pr( B2_Gun.prefix1[my_gun.prefix1][2] )
	else:
		prefix_1_name.modulate = Color.TRANSPARENT
		prefix_1_description.modulate = Color.TRANSPARENT
		
	if my_gun.prefix2:
		prefix_2_name.text = Text.pr( my_gun.prefix2 )
		prefix_2_description.text = Text.pr( B2_Gun.prefix2[my_gun.prefix2][3] )
	else:
		prefix_2_name.modulate = Color.TRANSPARENT
		prefix_2_description.modulate = Color.TRANSPARENT
		
	if my_gun.suffix:
		suffix_name.text = Text.pr( my_gun.suffix )
		suffix_description.text = Text.pr( B2_Gun.suffix[my_gun.suffix][3] )
	else:
		suffix_name.modulate = Color.TRANSPARENT
		suffix_description.modulate = Color.TRANSPARENT
	
func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
			if Input.is_action_just_pressed("Action") or Input.is_action_just_pressed("Holster"):
				hide_menu()

func show_panel( _my_gun : B2_Weapon ) -> void:
	my_gun = _my_gun
	_setup_menu()
	animation_player.play("show")
	grab_focus()

func hide_menu() -> void:
	if not animation_player.is_playing():
		animation_player.play("hide")
		await animation_player.animation_finished
		menu_closed.emit()

## Cool effect
var n_prev_rect := 5
var prev_rect : Array[Rect2] = []
func _draw() -> void:
	prev_rect.append( Rect2(bg_1.position, bg_1.size) )
	for rect in prev_rect:
		draw_rect( rect, Color.GREEN * randf_range(0.55,1.55), false )
	if prev_rect.size() > n_prev_rect:
		prev_rect.pop_front()

func _physics_process(_delta: float) -> void:
	if visible:
		queue_redraw()

func _process(delta: float) -> void:
	t += 3.0 * delta
	var c := Color.WHITE * ( 1.0 + sin( t ) )
	gun_marker_bottom.modulate 		= c
	gun_marker_top.modulate 		= c
	gun_marker_occupied.modulate 	= c
