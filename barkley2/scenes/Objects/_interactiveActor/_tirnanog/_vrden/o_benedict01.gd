extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## Time based stuff
	## TODO actually setup time based events
	#region Spaghetti
	#//Residential District
	#if (ClockTime("get") < 0.8) && (room == r_tnn_residentialDistrict01) {
		#keep = 1
	#};
	#//Next to Milagros Shop
	#if (ClockTime("get") >= 0.8) && (ClockTime("get") < 2.1) && (room == r_tnn_marketDistrict01) {
		#keep = 1;
		#x = 1104;
		#y = 908;
	#};
	#//Near the Clinic
	#if (ClockTime("get") >= 2.1) && (ClockTime("get") < 2.9) && (room == r_tnn_marketDistrict01) {
		#keep = 1;
		#x = 1016;
		#y = 588;
	#};
	#//Near the Sewers
	#if (ClockTime("get") >= 2.9) && (ClockTime("get") < 3.8) && (room == r_tnn_marketDistrict01) {
		#keep = 1;
		#x = 1232;
		#y = 312;
	#};
	#//In the Sewers at the Overlook
	#if (ClockTime("get") >= 3.8) && (ClockTime("get") < 5.1) && (room == r_sw1_descent01) {
		#keep = 1;
		#x = 392;
		#y = 360;
	#};
	#//In the Sewers at the top of the steps
	#if (ClockTime("get") >= 5.1) && (ClockTime("get") < 6.2) && (room == r_sw1_descent01) {
		#keep = 1;
		#x = 648;
		#y = 304;
	#};
	#//In the Sewers, leaning against the wall
	#if (ClockTime("get") >= 6.2) && (room == r_sw1_descent01) {
		#keep = 1;
		#x = 440;
		#y = 480;
	#};
#
	#if Quest("benedictState") == 5 then keep = 0
#endregion
	
	if B2_Playerdata.Quest("benedictState") == 5:
		queue_free()
		
	## Bought the pole, or leaning against the wall ##
	if B2_Playerdata.Quest("benedictState") == 4 or B2_Playerdata.Quest("benedictState") == 6:
		ActorAnim.animation = "nopole"
		
	#if ClockTime("get") >= 6.2 then 
		#scr_entity_animation_set(o_benedict01, "leaning");
		#image_xscale = 1;
		
	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= "s_constantineSE"
	ANIMATION_SOUTHEAST 					= "s_constantineSE"
	ANIMATION_SOUTHWEST 					= "s_constantineSE"
	ANIMATION_WEST 							= "s_constantineSE"
	ANIMATION_NORTH 						= "s_constantineNE"
	ANIMATION_NORTHEAST 					= "s_constantineNE"
	ANIMATION_NORTHWEST 					= "s_constantineNE"
	ANIMATION_EAST 							= "s_constantineSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "default"

	#benedictState
		#0 = not talked
		#1 = talked, engages the "beneTime System"
		#2 = sits down, offers you the fishing pole for money
		#3 = you tell him good luck
		#4 = heard the story of Turald's terrible past
		#5 = ClockTime setting that has him disappear after you buy the pole or he give you it
		#6 = bought the fishing pole
