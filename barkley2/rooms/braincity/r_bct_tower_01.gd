@tool
extends B2_ROOMS

## TODO Unused cutscene.
#//scene = event_bct_startWedding01;
#//scene = event_bct_afterWedding01;
#
#/*
#// Event for wedding quest. 
#
#
#/*if (argument0 == SCRIPT_START) {
	#if (Quest("startWedding") == 1) {
		#Quest("startWedding", 0);
		#script_execute(event_bct_startWedding01, SCRIPT_INTERACT);
	#}
#}
#else if (argument0 == SCRIPT_INTERACT) {
	#// Build Event
	#var wedding = id;
	#var event = scr_event_create_main();
	#with (event) {
		#
		#scr_event_build_fade(true, .3);
		#scr_event_build_wait(2);
		#scr_event_hoopz_switch_control();
		#scr_event_build_animation_set(o_cts_hoopz, "singingStand"); 
		#scr_event_build_fade(false, .3);
		#scr_event_build_camera_move(272, 176, 10);
		#scr_event_build_wait_for_actions(); 
		#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "Beautiful... simply beautiful. My congratulations to bride and groom - may your marriage be long and happy. But enough of this wedding puck, that's not why you're here. It's time for the main course, the soup du jour, the moment everyone's been waiting for, Brain City's very own.......... JAAAAAAAAZZY RAAAAAASCAAAAAAALS!!!");
		#scr_event_build_camera_reset();
		#scr_event_build_wait_for_actions(); 
		#scr_event_build_dialogue(P_NAME, s_port_hoopz, "(Stop saying that...)");
		#scr_event_build_camera_move(272, 176, 10);
		#scr_event_build_wait_for_actions(); 
		#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "Now before the band starts playing, I'd like to take a moment to introduce everyone...");
		#
		#//Have Wayne.
		#if (scr_quest_get_state("wayneWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "He's not much of a talker, but it don't matter when he's 'doo'ing his thang! Shreddin' the keyboard is Waaaaayne!");
			#scr_event_build_camera_move(104, 152, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Wayne", s_port_wayne, "...hey.");
		#}
		#
		#//Have Poly.
		#if (scr_quest_get_state("polyWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "She may be loud and she may love to fight, but Clispaeth help me if this gal can't rock'n'roll! On drums is Pooooooly!");
			#scr_event_build_camera_move(216, 96, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Poly", s_port_poly, "Cut the cruft Stonewall, let's get this shit goin'!");
		#}
		#
		#//Have Guillaume.
		#if (scr_quest_get_state("guillaumeWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "His bizarre new age schtick may seem anachronistic, maybe even meaningless four millenia after the hippie movement, but there's nothing culturally irrelevant about his musical chops. On guitar is Guillaaaaaaaaume!");
			#scr_event_build_camera_move(256, 88, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Guillaume", s_port_guillaume, "I'm feelin' it... I'm feelin' the love, I'm feelin' the vibes! My chakras are on the fritz, maaan!");
		#}
		#
		#//Have Dinah.
		#if (scr_quest_get_state("dinahWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "This cyberdelic datapunk may be new to the performing game, but her drum programming is second to none. Rockin' the drum machines iiiiiis Diiiiiinah!");
			#scr_event_build_camera_move(360, 96, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Dinah", s_port_dinah, "Hope you guys like four on the floor rhythms because that's all I can do so far.");
		#}
		#
		#//Have Zalmoxis.
		#if (scr_quest_get_state("zalmoxisWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "One part enigmatic and two parts contemptuous, hailing from the cryptic halls of the Death Tower is the one and only cuicamancer, Zaaaaaaaalmoxis!");
			#scr_event_build_camera_move(328, 128, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Zalmoxis", s_port_zalmoxis, "Hmph. It's time to enlighten you ignoramuses to the splender of my cuica zauber.");
		#}
		#
		#//Have Cap'n Jane.
		#if (scr_quest_get_state("janeWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "She's spent her life aplunderin' booty on the high seas (my kinda woman!) but now she's here to steal our hearts with her music. On accordion is the dread pirate... Cap'n Jaaaaaaaaane!");
			#scr_event_build_camera_move(152, 128, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Cap'n Jane", s_port_capnJane, "Arrrr! Don't look at me like that, I'm only doin' this for the money!");
		#}
	#
		#
		#//Have WIZARD.
		#if (scr_quest_get_state("wizardWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "With an instrument bigger than most of his bandmates, this bull-headed bassist is as kvlt as he is gigantic! Is he even a dwarf? Iiiiiit's WIIIIIIIIZARD!");
			#scr_event_build_camera_move(128, 112, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("WIZARD", s_port_wizard, "I DEDICATE THIS WAR DIRGE TO THE UNHOLY SERPENT WHOSE BLASPHEMY DESECRATES THE SPIRITS OF IMPURE PROFLIGATES.");
			#}
			#
		#//Have Boris.
		#if (scr_quest_get_state("borisWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "To be honest, it seems like there's somethin' wrong with this guy. But whether or not he's a sex offender, he's great at that flute. Iiiiiiit's Booooooris!");
			#scr_event_build_camera_move(352, 160, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Boris", s_port_boris, "Hearken, rascals, hearken! Let us consecrate this nuptial with a melody most sensual!");
			#}
			#
		#//Have Garcia.
		#if (scr_quest_get_state("garciaWedding") == 1){
			#scr_event_build_camera_move(272, 176, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "Behind the keyboard is, uh, Jordan? Germaine? He had a song 30 years ago.");
			#scr_event_build_camera_move(304, 104, 10);
			#scr_event_build_wait_for_actions(); 
			#scr_event_build_dialogue("Garcia", s_port_garcia, "I-it's /'Garcia/', everyone. Garcia!");
		#}
		#scr_event_build_camera_move(272, 176, 10);
		#scr_event_build_wait_for_actions(); 
		#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "Last and certainly not least is the shining star of this production, the hottest new voice on the block and the jazziest rascal of them all - " + P_NAME + "!!!");
		#
		#//if you're on False Flag quest.
		#if (scr_quest_get_state("falseFlag") == 2){
			#scr_event_build_dialogue(P_NAME, s_port_hoopz, "................teny.");
			#scr_event_build_quest_state("falseFlagWedding", 1);
		#
		#//Not on False Flag quest.
		#} else {
			#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Here goes nothin'...");
		#}
		#
		#scr_event_build_dialogue("Stonewall /'Booty Daimyo/' Jackson", "s_port_daimyo", "So without further adieu... the Jazzy Rascals!");
		#scr_event_build_camera_reset();
		#
		#//-----------------------
		#//PLAY SONGS HERE
		#//-----------------------
		#
		#scr_event_build_animation_set(o_cts_hoopz, "singing"); 
		#
		#//Have Garcia.
		#if (scr_quest_get_state("garciaWedding") == 1){
		#}
		#
		#//Have Jane.
		#if (scr_quest_get_state("janeWedding") == 1){
		#}
		#
		#//Have Wayne.
		#if (scr_quest_get_state("wayneWedding") == 1){
		#}
		#
		#//Have Poly.
		#if (scr_quest_get_state("polyWedding") == 1){
		#}
		#
		#//Have Dinah.
		#if (scr_quest_get_state("dinahWedding") == 1){
		#}
		#
		#//Have Zalmoxis.
		#if (scr_quest_get_state("zalmoxisWedding") == 1){
		#}
		#
		#//Have Boris.
		#if (scr_quest_get_state("borisWedding") == 1){
		#}
		#
		#//Have Guillaume.
		#if (scr_quest_get_state("guillaumeWedding") == 1){
		#}
		#
		#//Have WIZARD.
		#if (scr_quest_get_state("wizardWedding") == 1){
		#}
		#
		#scr_event_build_wait(2);
		#scr_event_build_fade(true, 2);
		#scr_event_build_wait(2);
		#scr_event_hoopz_switch_control();
		#scr_event_build_quest_state("afterWedding", 1);
		#scr_event_build_teleport(r_bct_chapel01, 232, 160 );
		#
	#}
	#scr_event_advance(event);

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
