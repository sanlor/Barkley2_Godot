extends B2_UtilityPanel

@onready var main_exp_value: 		Label = $exp/main_exp/main_exp_value
@onready var next_exp_value: 		Label = $next_lvl/next_lvl/next_exp_value
@onready var curr_lvl_value: 		Label = $curr_lvl/curr_lvl/curr_lvl_value
@onready var level_up_text: 		TextureRect = $curr_lvl/curr_lvl/level_up_text

@onready var helper_value: 			Label = $work_side/helper/helper_value
@onready var exp_gained_value: 		Label = $work_side/exp_gained/exp_gained_value

@onready var vidcon_owned_value: 		Label = $play_side/vidcons/vidcon_owned_value
@onready var vidcon_unboxed_value: 		Label = $play_side/vidcons/vidcon_unboxed_value
@onready var vidcon_exp_gained_value: 	Label = $play_side/exp_gained/exp_gained_value

@onready var left_brain: TextureRect = $big_brain/large_spaghetti/left_brain
@onready var right_brain: TextureRect = $big_brain/large_spaghetti/right_brain

@onready var brain_levelup_btn: Button = $"../right_panel/right_panel_vbox/brain_menu/brain_levelup_btn"

var pulse_level := false

func update_menu() -> void:
	if not is_node_ready():
		return
	if not visible:
		return
	await get_tree().process_frame
	
	@warning_ignore("narrowing_conversion")
	var to_next := maxi( 0, ( B2_Playerdata.player_stats.lvl - 11 ) * 60 ) - ( B2_Playerdata.player_stats.xp + B2_Vidcon.get_experience() )
	if to_next <= 0:
		level_up_text.show()
		level_up_text.modulate = Color.GREEN
		pulse_level = true
		brain_levelup_btn.disabled = false
	else: 
		level_up_text.hide()
		pulse_level = false
		brain_levelup_btn.disabled = true
	
	## Level stuff
	main_exp_value.text = str( int( B2_Playerdata.player_stats.xp + B2_Vidcon.get_experience() ) )
	next_exp_value.text = str( to_next )
	curr_lvl_value.text = str( int( B2_Playerdata.player_stats.lvl ) )
	
	## Work
	helper_value.text = str( B2_Config.get_user_save_data("quest.time", 0.0) - B2_ClockTime.time_get() ).pad_decimals(2) ## I have no idea how this works.
	exp_gained_value.text = str( int( B2_Playerdata.player_stats.xp) )
	
	## Play
	vidcon_owned_value.text = str( B2_Vidcon.total_boxed_vidcons() + B2_Vidcon.total_unboxed_vidcons() )
	vidcon_unboxed_value.text = str( B2_Vidcon.total_unboxed_vidcons() )
	vidcon_exp_gained_value.text = str( B2_Vidcon.get_experience() )
	
	## Brain stuff.
	@warning_ignore("integer_division")
	left_brain.material.set_shader_parameter("progress", float(B2_Playerdata.player_stats.xp) / 1440.0 ) ## Check Utility() line 415
	@warning_ignore("integer_division")
	right_brain.material.set_shader_parameter("progress", float(B2_Vidcon.total_unboxed_vidcons()) / float(B2_Vidcon.VIDCON_N) )

func _on_visibility_changed() -> void:
	update_menu()

var t := 0.0
func _process(delta: float) -> void:
	if pulse_level:
		t += 7.0 * delta
		level_up_text.modulate.a = ( sin( t ) + 1.0 ) / 2.0
