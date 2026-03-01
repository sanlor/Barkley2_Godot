extends B2_InteractiveActor

@onready var drink_emote: AnimatedSprite2D = $drink_emote

var t 			: Tween

var time 		:= 0.0
var time2 		:= 0.0
var wobble 		:= true

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"
	
	if B2_Playerdata.Quest("neneKnock") == 1:
		ActorAnim.animation = "sleep"
		wobble = false
	if B2_Playerdata.Quest("mainQuest") >= 6:
		queue_free()
		
	drink_emote.hide()
	
# Drink ON
func execute_event_user_0():
	drink_emote.show()
	drink_emote.modulate = Color.TRANSPARENT
	drink_emote.position = Vector2.ZERO
	drink_emote.scale = Vector2(0.25,0.25)
	
	if t: t.kill()
	t = create_tween()
	t.set_parallel(true)
	t.tween_property( drink_emote, "modulate", 	Color.WHITE, 		0.5 )
	t.tween_property( drink_emote, "position", 	Vector2(0,-14), 	0.5 )
	t.tween_property( drink_emote, "scale", 	Vector2(1,1), 		0.5)
	
# Drink OFF
func execute_event_user_1():
	drink_emote.show()
	drink_emote.modulate = Color.WHITE
	
	if t: t.kill()
	t = create_tween()
	t.tween_property( drink_emote, "modulate", 	Color.TRANSPARENT,	0.5 )
	t.tween_callback( drink_emote.hide )

func _physics_process( _delta: float ) -> void:
	if wobble:
		time += 0.05
		time2 += 0.002
		if randf() > 0.5:
			time += 0.01
			time2 += 0.01
		ActorAnim.rotation = sin( time ) * 0.1
		ActorAnim.offset.x = -13.0 + sin( time2 ) * 2.0

# Stop wobbling
func _on_actor_anim_animation_changed() -> void:
	if ActorAnim.animation == "sleep":
		wobble = false
		rotation = 0
