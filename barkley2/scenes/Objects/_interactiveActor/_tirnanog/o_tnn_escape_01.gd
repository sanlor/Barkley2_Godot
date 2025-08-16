extends B2_Event_Step_Trigger

var lockdown := 2;

func _ready() -> void:
	if B2_Playerdata.Quest("farewellTNN") == 1 or B2_Playerdata.Quest("farewellTNN") == 3: queue_free()
		
	## vvvv TODO fix the mess below.
	## TNN Lockdown after escape // Put this also somewhere in the sewers if you can access it after the lockdown ##
	#if B2_Playerdata.Quest("escapedFromTNN") == 1 and instance_exists(o_hoopz) then 
		## If you are entering from the SOUTH side then lockdown TNN //
		#if o_hoopz.y >= y then
			#{
			#Quest("escapedFromTNN", 2);
			#with o_kim01 scr_event_interactive_deactivate();
			#with o_lucretia01 scr_event_interactive_deactivate();
			#with o_ox01 scr_event_interactive_deactivate();
			#with o_tnn_gate01
				#{
				#image_single = 1;
				#event_user(0);
			#}
