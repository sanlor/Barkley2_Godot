@icon("res://barkley2/assets/b2_original/images/merged/s_bull_orb.png")
extends Area2D

const S_AMMO 		= preload("res://barkley2/assets/b2_original/images/merged/sAmmo.png")
const S_AMMO_ALT 	= preload("res://barkley2/assets/b2_original/images/merged/sAmmoAlt.png")

## Ammo pickup, created by something.
# Wild Ammo - Either FULL for one gun, or 20% for BANDO
# check object oPickUpAmmo

@onready var ammo_sprite_shadow: Sprite2D = $ammo_sprite_shadow
@onready var ammo_sprite: Sprite2D = $ammo_sprite
@onready var ammo_name: Label = $ammo_name
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

enum {AMMO, AMMO_ALT}
var my_ammo := AMMO
var my_ammo_text : Texture2D

var t := 0.0
var s := 5.0 * randf_range(0.75,1.25)
var a := 4.0 * randf_range(0.75,1.25)

var arch := 0.0
var wave := false
var picked_up := false

var disapear_tween : Tween
var movement_tween : Tween

func _ready() -> void:
	if randf() * 100.0 < B2_Drop.settingAmmoRandom:
		my_ammo = AMMO
		my_ammo_text = S_AMMO
		ammo_name.text = Text.pr( "Current gun's ammo at 100%!" )
	else:
		my_ammo = AMMO_ALT
		my_ammo_text = S_AMMO_ALT
		ammo_name.text = Text.pr( "All Bandolier gun's ammo at +20%!" )
	monitoring = false
	
	ammo_name.hide()
	ammo_sprite.self_modulate 				= Color.WHITE
	ammo_sprite_shadow.self_modulate 		= Color.WHITE
	
	await get_tree().process_frame
	
	## Fade out tween
	disapear_tween = create_tween()
	disapear_tween.tween_property( ammo_sprite, 							"self_modulate", Color.TRANSPARENT, 10.0 ).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	disapear_tween.parallel().tween_property( ammo_sprite_shadow, 		"self_modulate", Color.TRANSPARENT, 10.0 ).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	
	if not Engine.is_editor_hint():
		disapear_tween.tween_callback( queue_free )
		
	## Movement and little bounce tween.
	var rand_pos := position + Vector2.RIGHT.rotated( randf_range(0, TAU) ) * randf_range(5,100)
	movement_tween = create_tween()
	movement_tween.tween_property( self, "position", rand_pos, 1.0 ).set_ease(Tween.EASE_OUT)
	movement_tween.parallel().tween_property( self, "arch", PI , 1.0 ).set_ease(Tween.EASE_OUT)
	movement_tween.tween_callback( _land_gun )

func _land_gun() -> void:
	ammo_name.set_anchors_preset( Control.PRESET_CENTER ) ## Center the text.
	monitoring = true
	wave = true
	
func _physics_process(delta: float) -> void:
	## Cool flashing effect
	if not picked_up:
		if randf() < 0.075: ammo_sprite.modulate = Color.WHITE * 1.75
		elif randf() < 0.20: ammo_sprite.modulate = Color.WHITE * 1.25
		else: ammo_sprite.modulate = Color.WHITE
	
	## Wave when on the floor
	if wave:
		t += s * delta
		ammo_sprite.offset.y = sin( t ) * a
	else:
		ammo_sprite.position.y = -8 
		ammo_sprite.position.y -= sin(arch) * 35

func _on_body_entered(body: Node2D) -> void:
	if body is B2_HoopzCombatActor or body is B2_Player:
		## TODO Reload ammo
		push_warning("Reload not setup yet.")
		_pickup_gun()

func _pickup_gun() -> void:
	collision_shape_2d.queue_free()
	if disapear_tween:
		disapear_tween.kill()
	ammo_name.show()
	picked_up = true
	var _t := create_tween()
	_t.set_parallel(true)
	_t.tween_property( ammo_sprite, "modulate", Color.TRANSPARENT, 0.25 )
	_t.tween_property( ammo_sprite_shadow, "modulate", Color.TRANSPARENT, 0.25 )
	
	ammo_name.position.y = -46.0
	ammo_name.modulate = Color.WHITE
	
	disapear_tween = create_tween()
	disapear_tween.tween_property( ammo_name, 				"position:y", 	-64, 					0.5 )
	disapear_tween.parallel().tween_property( ammo_name, 	"modulate", 	Color.TRANSPARENT, 		1.5 )
	
	if not Engine.is_editor_hint():
		disapear_tween.tween_callback( queue_free )
