extends MarginContainer

@onready var gun_stats_lbl: RichTextLabel = $ScrollContainer/gun_stats_lbl
@onready var update_timer: Timer = $update_timer

func _on_visibility_changed() -> void:
	if is_node_ready():
		if visible:
			update_timer.start()
			update_stats()
		else:
			update_timer.stop()

func _on_update_timer_timeout() -> void:
	update_stats()

func update_stats() -> void:
	#print("asda")
	var gun := B2_Gun.get_current_gun()
	if gun:
		var gun_stats := B2_Gun.get_current_gun().weapon_stats.stat_to_dict()
		gun_stats_lbl.clear()
		gun_stats_lbl.push_table( 2 )
		gun_stats_lbl.set_table_column_expand(1, true)
		
		
		for data in gun_stats:
			gun_stats_lbl.push_cell()
			gun_stats_lbl.append_text( data )
			gun_stats_lbl.pop()
			
			var col := Color.WHITE.to_html()
			var my_data = gun_stats[data]
			if my_data is int:			col = Color.SEA_GREEN.to_html()
			elif my_data is float:		col = Color.CORAL.to_html()
			elif my_data is String:		col = Color.CADET_BLUE.to_html()
			elif my_data is bool:		col = Color.RED.to_html()
			else:						col = Color.YELLOW.to_html()
			
			gun_stats_lbl.push_cell()
			gun_stats_lbl.append_text( "[color=%s]%s[/color]" % [col, str( gun_stats[data] )] )
			gun_stats_lbl.pop()
		
		gun_stats_lbl.pop()
	else:
		gun_stats_lbl.text = "No gun :("
