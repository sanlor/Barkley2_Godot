extends Control

const MESSAGES := ["YOU NEED MUD BOOTS","LEVEL 20+ ONLY","UNDER CONSTRUCTION","CONSULT THE PELPER"]

@onready var s_mg_vrw_quest: 		TextureRect 	= $main_border/MarginContainer/VBoxContainer/s_mg_vrw_quest
@onready var s_mg_vrw_quest_lbl: 	Label 			= $main_border/MarginContainer/VBoxContainer/s_mg_vrw_quest_lbl

var message_index := 0

func _ready() -> void:
	# Initial setup
	modulate = Color.TRANSPARENT
	s_mg_vrw_quest_lbl.text = Text.pr( MESSAGES[message_index] )
	s_mg_vrw_quest.texture.region.position.x = 19 * message_index
	
	var t := create_tween()
	t.tween_property(self, "modulate", Color.WHITE, 0.15)
	t.tween_interval(1.5)
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.15)
	t.tween_callback( queue_free )
