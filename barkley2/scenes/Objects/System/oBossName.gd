@icon("uid://bku22hq88cmu2")
extends Control
@onready var zone_container: 	PanelContainer = $boss_name/zone_container
@onready var zone_label: 		Label = $boss_name/zone_container/zone_label
@onready var bossname_label: 	Label = $boss_name/bossname_label

var zone 		:= ""
var flavor 		:= ""
var color 		:= Color.WHITE

func _ready() -> void:
	zone 	= B2_Playerdata.Quest("bossName", null, 			"Undefined");
	flavor 	= B2_Playerdata.Quest("bossDescription", null, 		"Undefined");
	color 	= B2_Playerdata.Quest("bossColor", null, 			Color.WHITE);
	
	# Set texts
	zone_label.text = zone
	bossname_label.text = flavor
	
	# align
	zone_container.set_anchors_preset(Control.PRESET_CENTER_TOP)
	bossname_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	zone_container.position.y = 16.0
	bossname_label.position.y = 44.0
	
	# get ready for tweening
	zone_label.modulate 		= color
	zone_container.modulate.a 	= 0.0
	bossname_label.modulate.a 	= 0.0
	show_boss_name()

func show_boss_name():
	var tween := create_tween()
	
	tween.tween_property(bossname_label, "modulate:a", 1.0, 0.5)
	tween.tween_interval( 1.0 )
	tween.tween_property(zone_container, "modulate:a", 1.0, 1.0)
	tween.tween_interval( 4.5 )
	tween.tween_property(bossname_label, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(zone_container, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback( queue_free )
