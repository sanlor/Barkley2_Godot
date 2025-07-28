extends ScrollContainer

@onready var data: Label = $choices/VBoxContainer/data

func _on_visibility_changed() -> void:
	if visible and is_node_ready():
		data.text = "Money:\n"
		data.text += JSON.stringify( B2_Config.get_user_save_data("player.shekels"), "\t" ) + "\n" + "\n"
		data.text += "Jerkin (Equipd):\n"
		data.text += JSON.stringify( B2_Config.get_user_save_data("player.jerkins.current"), "\t" ) + "\n" + "\n"
		data.text += "Jerkin (All):\n"
		data.text += JSON.stringify( B2_Config.get_user_save_data("player.jerkins.has"), "\t" ) + "\n" + "\n"
		data.text += "Candy:\n"
		data.text += JSON.stringify( B2_Config.get_user_save_data("player.items.has"), "\t" ) + "\n" + "\n"
		data.text += "Quests: \n"
		data.text += JSON.stringify( B2_Config.get_user_save_data("quest.vars"), "\t" ) + "\n" + "\n"
		data.text += "Base Stats: \n"
		data.text += JSON.stringify( B2_Config.get_user_save_data("player.stats.base"), "\t" ) + "\n" + "\n"
		data.text += "Effective Stats: \n"
		data.text += JSON.stringify( B2_Config.get_user_save_data("player.stats.effective"), "\t" ) + "\n" + "\n"
