@icon("res://barkley2/assets/b2_original/images/merged/s_cabbage01.png")
## A cabbage is a candy, right?
extends Area2D

## Candy pickup, created by something.
# Candy, to be used right away
# check object oPickUpCandy

@onready var candy_sprite_shadow: Sprite2D = $candy_sprite_shadow
@onready var candy_sprite: Sprite2D = $candy_sprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var my_candy := ""

var t := 0.0
var s := 5.0 * randf_range(0.75,1.25)
var a := 4.0 * randf_range(0.75,1.25)

var arch := 0.0
var wave := false
var picked_up := false

var disapear_tween : Tween
var movement_tween : Tween

func setup( candy_name : String ) -> void:
	my_candy = candy_name

func _ready() -> void:
	if my_candy.is_empty():
		breakpoint
		return
		
	candy_sprite.texture.region.x = 16.0 * float( B2_Candy.CANDY_LIST.get(my_candy)[ 0 ] )
	
	monitoring = false
	
	candy_sprite.self_modulate 				= Color.WHITE
	candy_sprite_shadow.self_modulate 		= Color.WHITE
	
	await get_tree().process_frame
	
	## Fade out tween
	disapear_tween = create_tween()
	disapear_tween.tween_property( candy_sprite, 						"self_modulate", Color.TRANSPARENT, 10.0 ).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	disapear_tween.parallel().tween_property( candy_sprite_shadow, 		"self_modulate", Color.TRANSPARENT, 10.0 ).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	
	if not Engine.is_editor_hint():
		disapear_tween.tween_callback( queue_free )
		
	## Movement and little bounce tween.
	var rand_pos := position + Vector2.RIGHT.rotated( randf_range(0, TAU) ) * randf_range(5,100)
	movement_tween = create_tween()
	movement_tween.tween_property( self, "position", rand_pos, 1.0 ).set_ease(Tween.EASE_OUT)
	movement_tween.parallel().tween_property( self, "arch", PI , 1.0 ).set_ease(Tween.EASE_OUT)
	movement_tween.tween_callback( _land_candy )

func _land_candy() -> void:
	monitoring = true
	wave = true
	
func _physics_process(delta: float) -> void:
	## Cool flashing effect
	if not picked_up:
		if randf() < 0.075: candy_sprite.modulate = Color.WHITE * 1.75
		elif randf() < 0.20: candy_sprite.modulate = Color.WHITE * 1.25
		else: candy_sprite.modulate = Color.WHITE
	
	## Wave when on the floor
	if wave:
		t += s * delta
		candy_sprite.offset.y = sin( t ) * a
	else:
		candy_sprite.position.y = -8 
		candy_sprite.position.y -= sin(arch) * 35

func _on_body_entered(body: Node2D) -> void:
	if body is B2_HoopzCombatActor or body is B2_Player:
		B2_Candy.use_candy( my_candy )
		_pickup_gun()

func _pickup_gun() -> void:
	collision_shape_2d.queue_free()
	if disapear_tween:
		disapear_tween.kill()
	
	picked_up = true
	var _t := create_tween()
	_t.set_parallel(true)
	_t.tween_property( candy_sprite, "modulate", Color.TRANSPARENT, 0.25 )
	_t.tween_property( candy_sprite_shadow, "modulate", Color.TRANSPARENT, 0.25 )
	
	if not Engine.is_editor_hint():
		_t.tween_callback( queue_free )
