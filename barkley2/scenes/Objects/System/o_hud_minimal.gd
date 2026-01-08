extends B2_Hud

## A smaller version of the o_hud.
# Used during the tutorial battles.

@onready var animation_player: 	AnimationPlayer = $AnimationPlayer
@onready var mini_tutorial: 	RichTextLabel 	= $mini_tutorial
@onready var combat_module: 	Control 		= $combat_module
@onready var attack_btn: 		TextureButton 	= $combat_module/attack_btn

@export var debug_messages := true

func _ready() -> void:
	if debug_messages: print("o_hud: debug messages is ON.")
	#layer = B2_Config.HUD_LAYER
	B2_CManager.o_hud = self
	combat_module.hide()

func get_combat_module() -> B2_HudCombat:
	return combat_module

func show_battle_ui() -> void:
	combat_module.show()
	mini_tutorial.show()
	attack_btn.grab_focus()
	animation_player.play("move_mini_hud")
	
func hide_battle_ui() -> void:
	combat_module.hide()
