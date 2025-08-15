extends B2_VR_Mission
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	B2_CombatManager.combat_ended.connect( mission_over.emit )

func play( anim_name : String ) -> void:
	animation_player.play( anim_name )
