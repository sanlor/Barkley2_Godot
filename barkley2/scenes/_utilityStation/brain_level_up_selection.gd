@tool
extends HBoxContainer

@onready var stat_name_lbl: 		Label = $stat_panel/stat_name_lbl
@onready var stat_point_lbl: 		Label = $stat_points_panel/stat_point_lbl
@onready var stat_oc_lbl: 			Label = $stat_OC_panel/stat_OC_lbl

@onready var stat_wave: Panel = $stat_wave
@onready var t : Tween

@export var stat_name := "FARTS"

func _ready() -> void:
	stat_name_lbl.text = stat_name.to_upper()
	set_points( 0 )
	
func set_points( points : int ) -> void:
	if points > 3 or points < 0:
		breakpoint
	
	if points != 0:
		stat_name_lbl.modulate = Color.WHITE
		stat_point_lbl.modulate = Color.WHITE
		stat_oc_lbl.modulate = Color.WHITE
		stat_wave.modulate = Color.WHITE
	else:
		stat_name_lbl.modulate = Color.GRAY
		stat_point_lbl.modulate = Color.GRAY
		stat_oc_lbl.modulate = Color.GRAY
		stat_wave.modulate = Color.GRAY
		
	if t: t.kill()
	t = create_tween()
	t.set_parallel(true)
	t.tween_property(stat_wave, "aplitude", 	float(points) * 2.5, 0.5)
	t.tween_property(stat_wave, "freq", 		float(points), 0.5)
	
	stat_point_lbl.text = str( points )
