extends Button

func _on_pressed():
	if get_child_count() <= 0:
		add_child( load("res://barkley2/scenes/sTitle/custom/about_menu.tscn").instantiate() )

func _physics_process(delta: float) -> void:
	var wave := ( sin( 0.25 * Time.get_ticks_msec() * delta )  + PI / 2 ) / PI
	modulate.a = wave
