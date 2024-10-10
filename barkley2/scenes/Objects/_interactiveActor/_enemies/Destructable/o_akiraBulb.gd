extends B2_DestructibleCombatActor

const O_AKIRA_BULB_BROKEN = preload("res://barkley2/scenes/Objects/_interactiveActor/_enemies/Destructable/o_akira_bulb_broken.tscn")

func destroy_entity():
	remove_child( collision ) # .disabled = true
	# add broken sprite
	var broken = O_AKIRA_BULB_BROKEN.instantiate()
	add_sibling(broken)
	broken.position = position
	
	anim.hide()
	if smoke_emiter.emitting:
		await smoke_emiter.finished
	queue_free()

func _on_col_predictor_body_entered(body: Node2D) -> void:
	if body is B2_Player:
		if body.curr_STATE == B2_Player.STATE.ROLL:
			smoke_up()
			play_sound()
			destroy_entity()
			
func _physics_process(delta: float) -> void:
	anim.modulate.a = randf_range(0.75, 2.75) # Fuck shaders.
