extends Button

@onready var popup_menu = $PopupMenu

func _on_pressed():
	if get_child_count() <= 0:
		add_child( preload("res://barkley2/scenes/sTitle/custom/about_menu.tscn").instantiate() )
