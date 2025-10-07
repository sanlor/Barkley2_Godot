extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("switchPrison0") == 1:
		is_interactive = false

# Fill all guns to 100%
func execute_event_user_0():
	for gun : B2_Weapon in B2_Gun.get_bandolier():
		gun.recover_ammo( 9999 )
	for gun : B2_Weapon in B2_Gun.get_gunbag():
		gun.recover_ammo( 9999 )

# Flip the lever
func execute_event_user_10():
	is_interactive = false
	B2_Sound.play("sn_pdt_alert01", 0.0, false, 9999)
	animation = "flipped"
	## HAHA! Im lazy.
	var all_the_shit := get_parent().get_children()
	for shit : Node in all_the_shit:
		if shit.name.begins_with("oPrisonCCTV"):
			shit.play("shutdown")
		if shit.name.begins_with("o_fct_alarmWall01"):
			shit.play("on")
		## TODO add o_effect_alarmLight
