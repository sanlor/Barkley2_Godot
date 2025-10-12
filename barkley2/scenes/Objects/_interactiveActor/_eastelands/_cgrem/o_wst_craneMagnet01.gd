# The Crane Magnet that will fall on Hoopz to get into Cgrem Village
extends B2_Environ

# Animations
# TODO: make this sway randomly
# TODO: needs to DROP on Hoopz when he nominates to stand on it
# scr_entity_animation_define("sway", s_wst_craneMagnet01, 0, 7, ANIMATION_DEFAULT_SPEED);

@onready var s_wst_crane_chain_01: TextureRect = $s_wst_craneChain01

var t : Tween

func execute_event_user_5():
	drop_on_hoopz()

func drop_on_hoopz() -> void:
	offset.y = -51.0
	s_wst_crane_chain_01.size.y = 15.0
	if t: t.kill()
	t = create_tween()
	t.set_parallel( true )
	t.tween_property( self, "offset:y", -51.0 + 60.0, 0.25 )
	t.tween_property( s_wst_crane_chain_01, "size:y", 15.0 + 60, 0.25 )
