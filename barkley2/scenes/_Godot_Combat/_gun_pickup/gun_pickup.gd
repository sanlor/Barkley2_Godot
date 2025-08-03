@icon("res://barkley2/assets/b2_original/images/merged/s_gunsCooler01.png")
extends Area2D

## Weapon pickup, created by something.
# Add itself to the gunbag, not the bandolier.

@onready var gun_sprite: 			Sprite2D 	= $gun_sprite
@onready var gun_sprite_shadow: 	Sprite2D = $gun_sprite_shadow
@onready var gun_name: 				Label 		= $gun_name
@onready var collision_shape_2d: 	CollisionShape2D = $CollisionShape2D

var my_gun : B2_Weapon
var weapon_pickup_name := ""
var weapon_pickup_color := Color.WHITE

var dst_position := Vector2.ZERO
var force_multi := 1.0
var disapear_after_some_time := true

var t := 0.0
var s := 5.0 * randf_range(0.75,1.25)
var a := 4.0 * randf_range(0.75,1.25)

var arch := 0.0
var wave := false
var picked_up := false

var disapear_tween : Tween
var movement_tween : Tween

func setup( type : B2_Gun.TYPE ) -> void:
	my_gun = B2_Gun.generate_gun( type )
	@warning_ignore("narrowing_conversion")
	my_gun.curr_ammo = my_gun.max_ammo * B2_Drop.settingDropAmmo
	weapon_pickup_name = Text.pr( my_gun.weapon_pickup_name.capitalize() )
	weapon_pickup_color = my_gun.weapon_pickup_color
	
func setup_from_db( db_gun_name : String ) -> void:
	my_gun = B2_Gun.get_gun_from_db(db_gun_name)
	@warning_ignore("narrowing_conversion")
	my_gun.curr_ammo = my_gun.max_ammo * B2_Drop.settingDropAmmo
	weapon_pickup_name = Text.pr( my_gun.weapon_pickup_name.capitalize() )
	weapon_pickup_color = my_gun.weapon_pickup_color

func setup_from_gun( _my_gun : B2_Weapon ) -> void:
	my_gun = _my_gun
	@warning_ignore("narrowing_conversion")
	my_gun.curr_ammo = my_gun.max_ammo * B2_Drop.settingDropAmmo
	weapon_pickup_name = Text.pr( my_gun.weapon_pickup_name.capitalize() )
	weapon_pickup_color = my_gun.weapon_pickup_color

func _ready() -> void:
	## TODO Fix the pickup name color and correct name
	if not my_gun:
		push_error("Weapon drop created with random data. USE SETUP FUNCTION!")
		my_gun = B2_Gun.generate_gun()
	gun_sprite.texture = 			my_gun.get_weapon_hud_sprite()
	gun_sprite_shadow.texture = 	my_gun.get_weapon_hud_sprite()
	gun_name.text = 				weapon_pickup_name
	gun_name.self_modulate = 		weapon_pickup_color
	print( "Gun drop: ", weapon_pickup_name )
	monitoring = false
	
	gun_name.hide()
	
	gun_sprite.self_modulate 				= Color.WHITE
	gun_sprite_shadow.self_modulate 		= Color.WHITE
	
	await get_tree().process_frame
	
	if disapear_after_some_time:
		## Fade out tween
		disapear_tween = create_tween()
		disapear_tween.tween_property( gun_sprite, 							"self_modulate", Color.TRANSPARENT, 10.0 ).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
		disapear_tween.parallel().tween_property( gun_sprite_shadow, 		"self_modulate", Color.TRANSPARENT, 10.0 ).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	
		if not Engine.is_editor_hint():
			disapear_tween.tween_callback( queue_free )
		
	## Movement and little bounce tween.
	if dst_position == Vector2.ZERO:
		dst_position = position + Vector2.RIGHT.rotated( randf_range(0, TAU) ) * randf_range(5,40)
	
	movement_tween = create_tween()
	movement_tween.tween_property( self, "position", dst_position, 1.0 ).set_ease(Tween.EASE_OUT)
	movement_tween.parallel().tween_property( self, "arch", PI , 1.0 ).set_ease(Tween.EASE_OUT)
	movement_tween.tween_callback( _land_gun )

func _land_gun() -> void:
	gun_name.set_anchors_preset( Control.PRESET_CENTER ) ## Center the text.
	monitoring = true
	wave = true
	
func _physics_process(delta: float) -> void:
	## Cool flashing effect
	if not picked_up:
		if randf() < 0.075: gun_sprite.modulate = Color.WHITE * 1.35
		elif randf() < 0.20: gun_sprite.modulate = Color.WHITE * 1.15
		else: gun_sprite.modulate = Color.WHITE
	
	## Wave when on the floor
	if wave:
		t += s * delta
		gun_sprite.offset.y = sin( t ) * a
	else:
		gun_sprite.position.y = -8 
		gun_sprite.position.y -= sin(arch) * 35.0 * force_multi

func _on_body_entered(body: Node2D) -> void:
	if body is B2_Player_TurnBased or body is B2_Player_FreeRoam:
		B2_Sound.play("hoopz_pickupgun")
		B2_Gun.append_gun_to_gunbag( my_gun )
		_pickup_gun()

func _pickup_gun() -> void:
	collision_shape_2d.queue_free()
	if disapear_tween:
		disapear_tween.kill()
	gun_name.show()
	picked_up = true
	var _t := create_tween()
	_t.set_parallel(true)
	_t.tween_property( gun_sprite, "modulate", Color.TRANSPARENT, 0.25 )
	_t.tween_property( gun_sprite_shadow, "modulate", Color.TRANSPARENT, 0.25 )
	
	gun_name.position.y = -46.0
	gun_name.modulate = Color.WHITE
	
	
	disapear_tween = create_tween()
	disapear_tween.tween_property( gun_name, 				"position:y", 	-64, 					0.5 )
	disapear_tween.parallel().tween_property( gun_name, 	"modulate", 	Color.TRANSPARENT, 		1.5 )
	
	if not Engine.is_editor_hint():
		disapear_tween.tween_callback( queue_free )
