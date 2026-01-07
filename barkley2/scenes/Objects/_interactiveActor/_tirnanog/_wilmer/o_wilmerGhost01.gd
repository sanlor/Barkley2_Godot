extends B2_InteractiveActor

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ghost_emiter: GPUParticles2D = $"ghost emiter"
var flyaway := false

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	var t := create_tween()
	self_modulate.a = 0.0
	t.tween_property(self, "self_modulate:a", 1.0, 1.0)

func execute_event_user_4():
	flyaway = true
	animation_player.play("fly_away")
	animation_player.animation_finished.connect( queue_free )

func _on_actor_anim_animation_changed() -> void:
	ghost_emiter.texture = ActorAnim.sprite_frames.get_frame_texture("default", ActorAnim.frame)

func _physics_process( _delta: float ) -> void:
	if ActorAnim and not flyaway:
		ActorAnim.modulate.a = randf_range(0.50,0.75)
