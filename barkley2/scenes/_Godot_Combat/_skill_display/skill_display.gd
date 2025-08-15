extends Control

@onready var skill_name_lbl: Label = $skill_name_lbl

func _ready() -> void:
	#push_warning("TODO Add SFX")
	B2_Sound.play("sn_peridoic_released01")

func set_skill_name( skill_name : String ) -> void:
	skill_name_lbl.text = skill_name

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
