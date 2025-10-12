@tool
extends B2_ROOMS

const R_TNN_MAINGATE_02_BRANDING 	= preload("uid://d2pn7plugdgns")
const R_TNN_MAINGATE_02_SPEECH 		= preload("uid://b7vrvv1av5r20")

## 05/09/25 - OH SHIT, I SURE LOVE WHEN THERE ARE HIDDEN SCRIPTS THAT DO IMPORTANT STUFF INSIDE OTHER OBJECTS!!!!!!!!!!!
# These "filler actors" are removed from the map unless its the governor speech.
@onready var o_elrond_01: 		CharacterBody2D = $o_elrond01
@onready var o_gulpster_01: 	CharacterBody2D = $o_gulpster01
@onready var o_xorg_01: 		CharacterBody2D = $o_xorg01

@onready var o_hapsburg_01: 	CharacterBody2D = $o_hapsburg01
@onready var o_flipboy_01: 		CharacterBody2D = $o_flipboy01
@onready var o_gubbe_01: 		CharacterBody2D = $o_gubbe01
@onready var o_urdok_01: 		CharacterBody2D = $o_urdok01
@onready var o_ilyich_01: 		CharacterBody2D = $o_ilyich01
@onready var o_vikingstad_01: 	CharacterBody2D = $o_vikingstad01
@onready var o_lafferty_01: 	CharacterBody2D = $o_lafferty01

# and this one is for the actors during the branding scene.
@onready var o_dwarf_6: 		CharacterBody2D = $o_dwarf6
@onready var o_dwarf_4: 		CharacterBody2D = $o_dwarf4
@onready var o_dwarf_3: 		CharacterBody2D = $o_dwarf3
@onready var o_dwarf_1: 		CharacterBody2D = $o_dwarf1
@onready var o_dragline_01: 	CharacterBody2D = $o_dragline01
@onready var o_babalugats_01: 	CharacterBody2D = $o_babalugats01


func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame

	if B2_Playerdata.Quest("govSpeechInitiate") == 2:
		cutscene_script = R_TNN_MAINGATE_02_SPEECH
		B2_CManager.play_cutscene( cutscene_script, self, [] )
		return
	else:
		o_elrond_01.queue_free()
		o_xorg_01.queue_free()
		o_gulpster_01.queue_free()
		o_flipboy_01.queue_free()
		o_hapsburg_01.queue_free()
		o_gubbe_01.queue_free()
		o_urdok_01.queue_free()
		o_ilyich_01.queue_free()
		o_vikingstad_01.queue_free()
		o_lafferty_01.queue_free()
		
	## The Branding Scene at the beginning of the game/after the into/tutorial sequence
	if B2_Playerdata.Quest("sceneBrandingStart") == 1:
		cutscene_script = R_TNN_MAINGATE_02_BRANDING
		B2_CManager.play_cutscene( cutscene_script, self, [] )
		return
	else:
		o_dwarf_6.queue_free()
		o_dwarf_4.queue_free()
		o_dwarf_3.queue_free()
		o_dwarf_1.queue_free()
		o_dragline_01.queue_free()
		o_babalugats_01.queue_free()
			
	#else: ## Need to find a better way to deal with this
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )


## CRITICAL
#A lot of stuff is missing, like pedestrians and such. Im ignoring them to be able to finish the tutorial quickly.
