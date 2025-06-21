extends B2_UtilityPanel

const GUN_INFO_SLOT = preload("res://barkley2/scenes/_utilityStation/gun_info_slot.tscn")

@onready var gun_slots: VBoxContainer = $gun_slots

@onready var gunbag_value: 		Label = $gunbag/gunbag_value
@onready var smelt_value: 		Label = $smelt/smelt_panel/smelt_value
@onready var smelt_gauge: 		TextureRect = $smelt/smelt_panel/smelt_gauge

func _on_visibility_changed() -> void:
	if is_node_ready():
		_update_guns()

func _update_guns() -> void:
	for g in gun_slots.get_children():
		g.queue_free()
		
	var _guns 	:= B2_Gun.get_bandolier()
	var id := 0
	for gun in _guns:
		var gun_slot = GUN_INFO_SLOT.instantiate()
		gun_slots.add_child( gun_slot, true )
		gun_slot.id = id + 1
		gun_slot.setup( gun )
		gun_slot.show()
		id += 1
	update_smelt()
	
func update_smelt() -> void:
	##  Smelt Gauge
	var smelt : float 							= B2_Config.get_user_save_data("ustation.smelt", 0.0)
	gunbag_value.text 							= "%s (%s)" % [ str( B2_Gun.get_gunbag().size() ).pad_zeros(2), str( B2_Gun.GUNBAG_SIZE ).pad_zeros(2) ]
	smelt_value.text 							= str( int( smelt ) )
	smelt_gauge.texture.region.position.x 		= 176.0 * roundf( (smelt / 1000.0) * 45 )
