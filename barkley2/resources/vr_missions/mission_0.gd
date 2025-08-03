extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play( anim_name : String ) -> void:
	animation_player.play( anim_name )
