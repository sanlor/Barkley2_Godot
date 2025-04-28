extends VBoxContainer

@onready var gun_1: TextureRect = $wpn_list/gun_1
@onready var gun_2: TextureRect = $wpn_list/gun_2
@onready var gun_3: TextureRect = $wpn_list/gun_3
@onready var wpn_name: Label = $wpn_name

@onready var g_1_bar: ProgressBar = $wpn_list/gun_1/g1_bar
@onready var g_2_bar: ProgressBar = $wpn_list/gun_2/g2_bar
@onready var g_3_bar: ProgressBar = $wpn_list/gun_3/g3_bar

@onready var percent1: Label = $wpn_list/gun_1/percent
@onready var percent2: Label = $wpn_list/gun_2/percent
@onready var percent3: Label = $wpn_list/gun_3/percent

var pulse := 0.0
var t		:= 0.0

func _physics_process(_delta: float) -> void:
	t += 0.1
	pulse = ( sin( t ) / 2.0) + 0.5 ## 0.5 to 1.0

func tick_combat() -> void:
	## PLACEHOLDER Quick hack
	if B2_Playerdata.bandolier.size() == 0:
		gun_1.hide()
		gun_2.hide()
		gun_3.hide()
		wpn_name.text = Text.pr("You have no guns... :(")
		
	if B2_Playerdata.bandolier.size() == 1:
		gun_2.hide()
		gun_3.hide()
		
	if B2_Playerdata.bandolier.size() == 2:
		gun_3.hide()
		
	## Update UI ## TODO Improve this mess of a code.
	if B2_Playerdata.bandolier.size() >= 1:
		gun_1.texture 		= B2_Playerdata.bandolier[0].weapon_hud_sprite
		g_1_bar.value 		= B2_Playerdata.bandolier[0].curr_action
		g_1_bar.max_value 	= B2_Playerdata.bandolier[0].max_action
		g_1_bar.modulate = Color( Color.WHITE, 0.5 )
		
		if B2_Playerdata.bandolier[0].is_overheating():
			percent1.text = Text.pr("Overheat!")
			percent1.modulate = Color.RED
		else:
			if not B2_Playerdata.bandolier[0].is_at_max_action():
				percent1.text = "%s" % str( int(B2_Playerdata.bandolier[0].curr_action) ) + "%"
				percent1.modulate = Color.GRAY
			else:
				percent1.text = Text.pr("Ready!")
				percent1.modulate = Color.WHITE
		
		if B2_Playerdata.selected_gun == 0:
			wpn_name.text = B2_Playerdata.bandolier[0].get_full_name()
			g_1_bar.modulate = Color( Color.GREEN * pulse, 0.5 )
			
	if B2_Playerdata.bandolier.size() >= 2:
		gun_2.texture = B2_Playerdata.bandolier[1].weapon_hud_sprite
		g_2_bar.value 		= B2_Playerdata.bandolier[1].curr_action
		g_2_bar.max_value 	= B2_Playerdata.bandolier[1].max_action
		g_2_bar.modulate = Color( Color.WHITE, 0.5 )
		
		if B2_Playerdata.bandolier[1].is_overheating():
			percent2.text = Text.pr("Overheat!")
			percent2.modulate = Color.RED
		else:
			if not B2_Playerdata.bandolier[1].is_at_max_action():
				percent2.text = "%s" % str( int(B2_Playerdata.bandolier[1].curr_action) ) + "%"
				percent2.modulate = Color.GRAY
			else:
				percent2.text = Text.pr("Ready!")
				percent2.modulate = Color.WHITE
			
		if B2_Playerdata.selected_gun == 1:
			wpn_name.text = B2_Playerdata.bandolier[1].get_full_name()
			g_2_bar.modulate = Color( Color.GREEN * pulse, 0.5 )
			
	if B2_Playerdata.bandolier.size() >= 3:
		gun_3.texture = B2_Playerdata.bandolier[2].weapon_hud_sprite
		g_3_bar.value 		= B2_Playerdata.bandolier[2].curr_action
		g_3_bar.max_value 	= B2_Playerdata.bandolier[2].max_action
		g_3_bar.modulate = Color( Color.WHITE, 0.5 )
		
		if B2_Playerdata.bandolier[2].is_overheating():
			percent3.text = Text.pr("Overheat!")
			percent3.modulate = Color.RED
		else:
			if not B2_Playerdata.bandolier[2].is_at_max_action():
				percent3.text = "%s" % str( int(B2_Playerdata.bandolier[2].curr_action) ) + "%"
				percent3.modulate = Color.GRAY
			else:
				percent3.text = Text.pr("Ready!")
				percent3.modulate = Color.WHITE
			
		if B2_Playerdata.selected_gun == 2:
			wpn_name.text = B2_Playerdata.bandolier[2].get_full_name()
			g_3_bar.modulate = Color( Color.GREEN * pulse, 0.5 )
