extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

#// event_bct_brainfanTwo01
#
#
#/*if (argument0 == SCRIPT_START) {
#
#}
#if (argument0 == SCRIPT_STEP) {
#
#}
#if (argument0 == SCRIPT_INTERACT) {
	#var brainfanOne = id;
	#var event = scr_event_create_main();
	#
	#with event {
		#// brain defeated, chaiyaporn lost powers
		#if (scr_quest_get_state("chaiyapornPowers") == 1) {
			#scr_event_build_dialogue("Brainfan Two", NULL, "");
		#}
		#// chaiyaporn exploded
		#else if (scr_quest_get_state("chaiyapornExplode") == 1) {
			#scr_event_build_dialogue("Brainfan Two", NULL, "");
		#}
		#// chaiyaporn is resting
		#else if (scr_quest_get_state("chaiyapornTime") == 1) {
			#scr_event_build_dialogue("Brainfan Two", NULL, "");
		#}
		#// talked, asked question
		#else if (scr_quest_get_state("chaiyapornState") == 2) {
			#scr_event_build_dialogue("Brainfan Two", NULL, "Like I said... there's no subject on which Gehirnkind can't inform you. It's unreal!");
		#}
		#// talked, asked no questions
		#else if (scr_quest_get_state("chaiyapornState") == 1) {
			#scr_event_build_dialogue("Brainfan Two", NULL, "I thought I was smart, until I met Gehirnkind. Now I'm ashamed of my puny brain... but it's worth it. He's just so amazing!");
		#}
		#// haven't yet talked
		#if (scr_quest_get_state("chaiyapornState") == 0) {
			#scr_event_build_dialogue("Brainfan Two", NULL, "");
		#}
	#}
	#scr_event_advance(event);

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
