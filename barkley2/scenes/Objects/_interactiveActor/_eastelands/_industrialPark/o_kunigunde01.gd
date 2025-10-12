## Kunigunde in the Industrial Park
extends B2_InteractiveActor

	#figbottomQuest
		#0 - Nothing has been done
		#1 - Heard about Figbottom Quest
		#2 - Failed Quest?
		#3 - Quest accepted
		#4 - Suresh tells you to talk to Kunigunde
		#5 - Kunigunde tells you to talk to Moriarty
		#6 - Moriartys clue about Suresh        
		#7 - Sureshs clue about Kunigunde
		#8 - Kunigunde talked to about tontine
		#9 - Someone has been arrested
		#
	#kunigundeState 
		#0 - Pre-Rant
		#1 - Post-Rant
	#
	#kunigundeArrest = 1    Kunigunde has been arrested for Figbottoms murder

@onready var timer: Timer = $timer

var bowed := false

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Playerdata.Quest("kunigundeArrest") == 1:
		queue_free()
		
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


func _on_timer_timeout() -> void:
	timer.start( randf_range(4,24) )
	ActorAnim.play("hair_bob")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is B2_PlayerCombatActor and not bowed:
		ActorAnim.play("bow")
		timer.stop()
		bowed = true # Avoid bowing every single time.

func _on_actor_anim_animation_finished() -> void:
	ActorAnim.animation = "default"
