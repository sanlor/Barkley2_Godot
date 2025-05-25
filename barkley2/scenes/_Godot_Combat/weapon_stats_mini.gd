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

var alpha 	:= 0.25
var pulse 	:= 0.00
var t		:= 0.00

func _physics_process(_delta: float) -> void:
	t += 0.1
	pulse = ( sin( t ) / 2.0) + 1.00 ## 0.5 to 1.0

func gun_1_update( loadout : Array[B2_Weapon] ) -> void:
	gun_1.texture 		= loadout[0].weapon_hud_sprite
	g_1_bar.value 		= loadout[0].curr_action
	g_1_bar.max_value 	= loadout[0].max_action
	g_1_bar.modulate = Color( Color.WHITE, alpha )
	
	if loadout[0].is_overheating():
		percent1.text = Text.pr("Over\nheat!")
		percent1.modulate = Color( Color.RED * pulse, alpha )
	else:
		if not loadout[0].is_at_max_action():
			percent1.text = "%s" % str( int(loadout[0].curr_action) ) + "%"
			if B2_Playerdata.selected_gun == 0:
				g_1_bar.modulate = Color( Color.DARK_GREEN, alpha )
			percent1.modulate = Color.GRAY
		else:
			percent1.text = Text.pr("Ready!")
			if B2_Playerdata.selected_gun == 0:
				g_1_bar.modulate = Color( Color.GREEN * pulse, alpha )
			percent1.modulate = Color.WHITE
	
	if B2_Playerdata.selected_gun == 0:
		wpn_name.text = loadout[0].get_full_name()
		
func gun_2_update( loadout : Array[B2_Weapon] ) -> void:
	gun_2.texture 		= loadout[1].weapon_hud_sprite
	g_2_bar.value 		= loadout[1].curr_action
	g_2_bar.max_value 	= loadout[1].max_action
	g_2_bar.modulate = Color( Color.WHITE, alpha )
	
	if loadout[1].is_overheating():
		percent2.text = Text.pr("Over\nheat!")
		percent2.modulate = Color( Color.RED * pulse, alpha )
	else:
		if not loadout[1].is_at_max_action():
			percent2.text = "%s" % str( int(loadout[1].curr_action) ) + "%"
			if B2_Playerdata.selected_gun == 1:
				g_2_bar.modulate = Color( Color.DARK_GREEN * pulse, alpha )
			percent2.modulate = Color.GRAY
		else:
			percent2.text = Text.pr("Ready!")
			if B2_Playerdata.selected_gun == 1:
				g_2_bar.modulate = Color( Color.GREEN * pulse, alpha )
			percent2.modulate = Color.WHITE
		
	if B2_Playerdata.selected_gun == 1:
		wpn_name.text = loadout[1].get_full_name()
		
func gun_3_update( loadout : Array[B2_Weapon] ) -> void:
	gun_3.texture 		= loadout[2].weapon_hud_sprite
	g_3_bar.value 		= loadout[2].curr_action
	g_3_bar.max_value 	= loadout[2].max_action
	g_3_bar.modulate = Color( Color.WHITE, alpha )
	
	if loadout[2].is_overheating():
		percent3.text = Text.pr("Over\nheat!")
		percent3.modulate = Color( Color.RED * pulse, alpha )
	else:
		if not loadout[2].is_at_max_action():
			percent3.text = "%s" % str( int(loadout[2].curr_action) ) + "%"
			if B2_Playerdata.selected_gun == 2:
				g_3_bar.modulate = Color( Color.DARK_GREEN, alpha )
			percent3.modulate = Color.GRAY
		else:
			percent3.text = Text.pr("Ready!")
			if B2_Playerdata.selected_gun == 2:
				g_3_bar.modulate = Color( Color.GREEN * pulse, alpha )
			percent3.modulate = Color.WHITE
			
	if B2_Playerdata.selected_gun == 2:
		wpn_name.text = loadout[2].get_full_name()
		
func tick_combat() -> void:
	## PLACEHOLDER Quick hack
	var loadout : Array[B2_Weapon]
	if B2_Playerdata.gunbag_open:
		loadout = B2_Playerdata.gun_bag
		if loadout.size() == 0:
			gun_1.hide()
		else:
			gun_1_update( loadout )
				
		gun_2.hide()
		gun_3.hide()
	else:
		loadout = B2_Playerdata.bandolier
		if loadout.size() == 0:
			gun_1.hide()
			gun_2.hide()
			gun_3.hide()
			wpn_name.text = Text.pr("You have no guns... :(")
			
		if loadout.size() == 1:
			gun_2.hide()
			gun_3.hide()
			
		if loadout.size() == 2:
			gun_3.hide()
			
		## Update UI ## TODO Improve this mess of a code.
		if B2_Playerdata.bandolier.size() >= 1:
			gun_1.show()
			gun_1_update( loadout )
				
		if B2_Playerdata.bandolier.size() >= 2:
			gun_2.show()
			gun_2_update( loadout )
				
		if B2_Playerdata.bandolier.size() >= 3:
			gun_3.show()
			gun_3_update( loadout )
