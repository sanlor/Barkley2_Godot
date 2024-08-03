@tool
extends AnimatedSprite2D

signal mouse_hovering(int, bool)
signal mouse_clicked(int)

@onready var rune_top = $rune_top
@onready var mouse_detector = $mouse_detector

var my_id := 0
var my_color := Color.GREEN
var can_be_clicked := false # avoid the player clicking it during the animation
var can_hover := true
var is_hovering := false

var cookie_sound : Array[ PackedStringArray ] # Cookie? what is this?

func _ready():
	cookie_sound.resize(8)
	for i in 8:
		cookie_sound[i] = PackedStringArray()
		cookie_sound[i].resize( 6 )
		
	cookie_sound[0] [0] = "sn_cc_fire_hover01";
	cookie_sound[0] [1] = "sn_cc_fire_hover02";
	cookie_sound[0] [2] = "sn_cc_fire_hover03";
	cookie_sound[0] [3] = "sn_cc_fire_select01";
	cookie_sound[0] [4] = "sn_cc_fire_select02";
	cookie_sound[0] [5] = "sn_cc_fire_select03";

	cookie_sound[1] [0] = "sn_cc_grandpa_hover1";
	cookie_sound[1] [1] = "sn_cc_grandpa_hover2";
	cookie_sound[1] [2] = "sn_cc_grandpa_hover3";
	cookie_sound[1] [3] = "sn_cc_grandpa_select1";
	cookie_sound[1] [4] = "sn_cc_grandpa_select2";
	cookie_sound[1] [5] = "sn_cc_grandpa_select3";

	cookie_sound[2] [0] = "sn_cc_winter_hover01";
	cookie_sound[2] [1] = "sn_cc_winter_hover02";
	cookie_sound[2] [2] = "sn_cc_winter_hover03";
	cookie_sound[2] [3] = "sn_cc_winter_select01";
	cookie_sound[2] [4] = "sn_cc_winter_select02";
	cookie_sound[2] [5] = "sn_cc_winter_select03";

	cookie_sound[3] [0] = "sn_cc_riceballs_hover01;"
	cookie_sound[3] [1] = "sn_cc_riceballs_hover02";
	cookie_sound[3] [2] = "sn_cc_riceballs_hover03";
	cookie_sound[3] [3] = "sn_cc_riceballs_select01";
	cookie_sound[3] [4] = "sn_cc_riceballs_select01";
	cookie_sound[3] [5] = "sn_cc_riceballs_select03";

	cookie_sound[4] [0] = "sn_cc_anime_hover01";
	cookie_sound[4] [1] = "sn_cc_anime_hover01";
	cookie_sound[4] [2] = "sn_cc_anime_hover01";
	cookie_sound[4] [3] = "sn_cc_anime_select01";
	cookie_sound[4] [4] = "sn_cc_anime_select01";
	cookie_sound[4] [5] = "sn_cc_anime_select01";

	cookie_sound[5] [0] = "sn_cc_vidcon_hover01";
	cookie_sound[5] [1] = "sn_cc_vidcon_hover01";
	cookie_sound[5] [2] = "sn_cc_vidcon_hover01";
	cookie_sound[5] [3] = "sn_cc_vidcon_select01";
	cookie_sound[5] [4] = "sn_cc_vidcon_select01";
	cookie_sound[5] [5] = "sn_cc_vidcon_select01";

	cookie_sound[6] [0] = "sn_cc_corncobs_hover01";
	cookie_sound[6] [1] = "sn_cc_corncobs_hover02";
	cookie_sound[6] [2] = "sn_cc_corncobs_hover03";
	cookie_sound[6] [3] = "sn_cc_corncobs_select01";
	cookie_sound[6] [4] = "sn_cc_corncobs_select02";
	cookie_sound[6] [5] = "sn_cc_corncobs_select03";

	cookie_sound[7] [0] = "sn_cc_dwarf_hover01";
	cookie_sound[7] [1] = "sn_cc_dwarf_hover02";
	cookie_sound[7] [2] = "sn_cc_dwarf_hover03";
	cookie_sound[7] [3] = "sn_cc_dwarf_select01";
	cookie_sound[7] [4] = "sn_cc_dwarf_select02";
	cookie_sound[7] [5] = "sn_cc_dwarf_select03";

func set_rune_id( id : int ):
	frame = id
	rune_top.frame = id
	my_id = id
	
func set_rune_color( color : Color ):
	my_color = color
	material.set_deferred( "shader_parameter/outline_color", Color( color, 0.125 ) );

func _physics_process(_delta):
	if is_hovering and can_be_clicked:
		if Input.is_action_just_pressed("Action"):
			B2_Sound.play( cookie_sound[ my_id ] [ randi_range(3, 5) ] )
			mouse_clicked.emit( my_id )
			can_be_clicked = false
			can_hover = false
			material.set_deferred( "shader_parameter/is_enabled", true );
			mouse_hovering.emit(my_id, false)

func _on_mouse_detector_mouse_entered():
	if can_hover:
		is_hovering = true
		B2_Sound.play( cookie_sound[ my_id ] [ randi_range(0, 2) ] )
		material.set_deferred( "shader_parameter/is_enabled", is_hovering );
		mouse_hovering.emit(my_id, is_hovering)

func _on_mouse_detector_mouse_exited():
	if can_hover:
		is_hovering = false
		material.set_deferred( "shader_parameter/is_enabled", is_hovering );
		mouse_hovering.emit(my_id, is_hovering)
