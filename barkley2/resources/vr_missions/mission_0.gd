extends B2_VR_Mission
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play( anim_name : String ) -> void:
	animation_player.play( anim_name )
