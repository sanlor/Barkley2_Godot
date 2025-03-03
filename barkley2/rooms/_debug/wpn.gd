extends Node2D

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	gen_gun()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_0):
			gen_gun()

func gen_gun():
	var wpn := B2_Gun.generate_gun()
	texture_rect.texture = wpn.weapon_hud_sprite
	print( wpn.get_full_name() )
	print( B2_Gun.TYPE.keys()[wpn.weapon_type] )
	print( wpn.weapon_type )
	print( B2_Gun.MATERIAL.keys()[wpn.weapon_material] )
	print( wpn.weapon_material )
	print( var_to_bytes_with_objects(wpn) )
