extends B2_UtilityPanel

@onready var gun_1: Control = $gun_1
@onready var gun_2: Control = $gun_2
@onready var gun_3: Control = $gun_3


@onready var gunbag_value: 		Label = $gunbag/gunbag_value
@onready var smelt_value: 		Label = $smelt/smelt_panel/smelt_value
@onready var smelt_gauge: 		TextureRect = $smelt/smelt_panel/smelt_gauge

func _on_visibility_changed() -> void:
	if is_node_ready():
		_update_guns()

func _update_guns() -> void:
	gun_1.hide()
	gun_2.hide()
	gun_3.hide()
	
	var guns 	:= [gun_1, gun_2, gun_3]
	var _guns 	:= B2_Gun.get_bandolier()
	var id := 0
	for gun in _guns:
		guns[id].id = id + 1
		guns[id].setup( gun )
		guns[id].show()
		id += 1
		
	var smelt : float 							= B2_Config.get_user_save_data("ustation.smelt", 0.0)
	gunbag_value.text 							= "%s (%s)" % [ str( B2_Gun.get_gunbag().size() ).pad_zeros(2), str( B2_Gun.GUNBAG_SIZE ).pad_zeros(2) ]
	smelt_value.text 							= str( int( smelt ) ) #str( int( smelt / 1000.0) )
	print(176.0 * (smelt / 1000.0) * 45)
	smelt_gauge.texture.region.position.x 		= 176.0 * roundf( (smelt / 1000.0) * 45 )
