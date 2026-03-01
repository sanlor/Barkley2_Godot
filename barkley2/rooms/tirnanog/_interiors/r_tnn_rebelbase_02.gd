@tool
extends B2_ROOMS

## Script for walking into the Rebel Base in TNN

#VARIABLES
	#prisonArrested
		#0 = Not arrested
		#1 = Arrested after going to rebel HQ and selling out your comrades via Gelasio
		#2 = Arrested for trying to bomb the statue
		#3 = Lost a battle against Duergar for the first time
		#4 = Arrested for robbing the bank with Gutterhound
		#5 = Arrested for chupsale      
		#
	#escapedFromTNN
		#0 = Have not left TNN
		#1 = TNN Primed for a lockdown (won't get locked until you try to re-enter after leaving)
		#2 = TNN Lockdown in effect, can't enter TNN via gate nor through the sewers
		#3 = TNN Lockdown in effect, escaped TNN via being imprisoned 

@onready var o_dr_liu_captured_01: 		CharacterBody2D = $o_drLiuCaptured01
@onready var o_absalom_captured_01: 	CharacterBody2D = $o_absalomCaptured01
@onready var o_vikingstad_01: 			CharacterBody2D = $o_vikingstad01
@onready var o_lafferty_01: 			CharacterBody2D = $o_lafferty01

@onready var o_dr_liu_01: 				CharacterBody2D = $o_dr_liu01
@onready var o_pvtmadison_01: 			CharacterBody2D = $o_pvtmadison01
@onready var o_vanboekel_01: 			CharacterBody2D = $o_vanboekel01
@onready var o_ritkonen_01: 			CharacterBody2D = $o_ritkonen01
@onready var o_naoko_01: 				CharacterBody2D = $o_naoko01
@onready var o_gormlaith_01: 			CharacterBody2D = $o_gormlaith01
@onready var o_absalom_01: 				CharacterBody2D = $o_absalom01

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	# Only turn on if you have foolishly sold out the Rebels to the Duergars
	if B2_Playerdata.Quest("duergarInfoLonginus") == 0:
		o_dr_liu_captured_01.queue_free()
		o_absalom_captured_01.queue_free()
		o_vikingstad_01.queue_free()
		o_lafferty_01.queue_free()
	else:
		o_dr_liu_01.queue_free()
		o_pvtmadison_01.queue_free()
		o_vanboekel_01.queue_free()
		o_ritkonen_01.queue_free()
		o_naoko_01.queue_free()
		o_gormlaith_01.queue_free()
		o_absalom_01.queue_free()
	
	_set_region()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
	
	# Bodyswaps #
	if B2_Playerdata.Quest("govTransfer") == 2:
		B2_CManager.BodySwap("governor");
	if B2_Playerdata.Quest("govFinishInitiate") == 1:
		B2_CManager.BodySwap("hoopz");
