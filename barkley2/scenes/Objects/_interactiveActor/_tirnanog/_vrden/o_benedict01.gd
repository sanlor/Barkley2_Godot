extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## Time based stuff
	var keep := 0 ## Weird variable. Actor need to pass a bunch of checks. if its still 0, remove it.
	
	#region Spaghetti
	## Residential District
	if B2_ClockTime.time_get() < 0.8 and get_room_name() == "r_tnn_residentialDistrict01":
		keep = 1

	## Next to Milagros Shop
	if B2_ClockTime.time_get() >= 0.8 and B2_ClockTime.time_get() < 2.1 and \
		get_room_name() == "r_tnn_marketDistrict01":
		keep = 1;
		position = Vector2(1104, 908)

	## Near the Clinic
	if B2_ClockTime.time_get() >= 2.1 and B2_ClockTime.time_get() < 2.9 and \
		get_room_name() == "r_tnn_marketDistrict01":
		keep = 1;
		position = Vector2(1016, 588)

	## Near the Sewers
	if B2_ClockTime.time_get() >= 2.9 and B2_ClockTime.time_get() < 3.8 and \
		get_room_name() == "r_tnn_marketDistrict01":
		keep = 1;
		position = Vector2(1232, 312)
	
	## In the Sewers at the Overlook
	if B2_ClockTime.time_get() >= 3.8 and B2_ClockTime.time_get() < 5.1 and \
		get_room_name() == "r_sw1_descent01":
		keep = 1;
		position = Vector2(392, 360)

	## In the Sewers at the top of the steps
	if B2_ClockTime.time_get() >= 5.1 and B2_ClockTime.time_get() < 6.2 and \
		get_room_name() == "r_sw1_descent01":
		keep = 1;
		position = Vector2(648, 304)

	## In the Sewers, leaning against the wall
	if B2_ClockTime.time_get() >= 6.2 and get_room_name() == "r_sw1_descent01":
		keep = 1;
		position = Vector2(440, 480)
#endregion
	
	if B2_Playerdata.Quest("benedictState") == 5:
		keep = 0
	if keep == 0:
		queue_free()
		
	## Bought the pole, or leaning against the wall ##
	if B2_Playerdata.Quest("benedictState") == 4 or B2_Playerdata.Quest("benedictState") == 6:
		ActorAnim.animation = "nopole"
	
	if B2_ClockTime.time_get() >= 6.2:
		ActorAnim.animation = "leaning"
		ActorAnim.flip_h = true
		
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
