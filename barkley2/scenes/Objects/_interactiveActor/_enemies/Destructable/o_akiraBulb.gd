extends B2_DestructibleCombatActor

const O_AKIRA_BULB_BROKEN = preload("res://barkley2/scenes/Objects/_interactiveActor/_enemies/Destructable/o_akira_bulb_broken.tscn")

func _ready() -> void:
	anim.play()
	anim.speed_scale = randf_range(0.8,1.2)
	
	if B2_Playerdata.Quest("tutorialCollision", null, 0) >= 1:
		destroy_entity()

func destroy_entity():
	if collision:
		# add broken sprite
		var broken = O_AKIRA_BULB_BROKEN.instantiate()
		add_sibling.call_deferred(broken)
		broken.position = position
		#remove_child( collision ) # .disabled = true
		collision.queue_free()
		
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
			
func _physics_process(_delta: float) -> void:
	anim.modulate.a = randf_range(0.75, 2.75) # Fuck shaders.
