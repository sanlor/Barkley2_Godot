extends Control
## Controls how the animations plays out.

@export var selected_gun 			:							= "selected_gun_1"
@export var gun_info				: Control 					
@export var actual_gun_texture		: TextureRect 
@export var actual_gun_scan			: TextureRect

@onready var s_cinema_firepower				: Sprite2D 			= $power_panel/SCinemaFirepower
@onready var spr_breedanm_bullet_type		: AnimatedSprite2D 	= $bullet_pan/spr_breedanm_bulletType
@onready var spr_breedanm_bulletbars		: AnimatedSprite2D 	= $bullet_pan/spr_breedanm_bulletbars
@onready var spr_breedanm_typepan_type		: AnimatedSprite2D 	= $spr_breedanm_typepan_type

var my_selected_gun 	: B2_Weapon
var gun_power 			:= 0.0

func setup() -> void:
	my_selected_gun = gun_info.get(selected_gun)
	assert( my_selected_gun, "No gun selected." )
	populate_gun_data()
	
	if actual_gun_texture: ## not needed for "new_gun_data" node.
		actual_gun_texture.modulate = Color(1.0,10.0,1.0,0.0)
		
		var t := create_tween()
		t.tween_property( actual_gun_texture, 	"modulate:a", 1.0, 1.5 * randf_range(0.85,1.15) 		)
		t.tween_property( actual_gun_texture, 	"modulate", Color.WHITE, 0.5  * randf_range(0.85,1.15) 	)
		t.tween_property( actual_gun_scan, 		"modulate:a", 0.0, 0.5  * randf_range(0.85,1.15) 		)
		t.tween_callback( actual_gun_scan.hide )
	
	## Set bullet type
	spr_breedanm_bullet_type.frame 		= int( my_selected_gun.weapon_type )
	spr_breedanm_typepan_type.frame 	= int( my_selected_gun.weapon_type )
	
	## Set bullet Graph
	spr_breedanm_bulletbars.frame = 0
	var tt := create_tween()
	tt.tween_property(spr_breedanm_bulletbars, "frame", get_bullet_frame_count(), 1.5)
	tt.parallel().tween_property(self, "gun_power", my_selected_gun.get_att() / 100.0, 1.5 * randf_range(0.5,1.0) )
	
func get_bullet_frame_count() -> int:
	var bullets := my_selected_gun.max_ammo
	if bullets<4:	return 2
	elif bullets<8: return 3 
	elif bullets<16: return 4 
	elif bullets<24: return 5 
	elif bullets<32: return 6 
	elif bullets<48: return 7 
	elif bullets<64: return 8 
	elif bullets<80: return 9 
	elif bullets<120: return 10 
	elif bullets<180: return 11 
	elif bullets<240: return 12 
	elif bullets<320: return 13 
	else: return 14 
	
func populate_gun_data() -> void:
	if actual_gun_texture: ## not needed for "new_gun_data" node.
		actual_gun_texture.texture = my_selected_gun.get_weapon_hud_sprite()
	
func _physics_process(delta: float) -> void:
	if visible:
		if actual_gun_scan: ## not needed for "new_gun_data" node.
			actual_gun_scan.position.x = wrapf( actual_gun_scan.position.x - 250.0 * delta, 4.0, 56.5)
		if randf() > 0.75:
			s_cinema_firepower.material.set_shader_parameter("transform_ratio", gun_power * randf_range(0.85,1.25) )
