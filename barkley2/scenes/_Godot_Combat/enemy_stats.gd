extends Control

@onready var health_progress: 	Control = $health_progress
@onready var action_progress: 	Control = $action_progress

var my_data 	: B2_EnemyData
var my_cbt 		#: CombatCharacter

var tween		: Tween

func _ready() -> void:
	## Setup myself
	if get_parent() is B2_EnemyCombatActor:
		my_cbt = get_parent()
		if my_cbt.enemy_data:
			my_data = my_cbt.enemy_data
			#my_cbt.begun_action.connect( hide_stats )
			#my_cbt.finished_action.connect( show_stats )
		
	if my_data:
		update_stats()
		
	modulate = Color.TRANSPARENT
	show_stats()
	
func update_stats() -> void:
	health_progress.max_value 	= my_data.max_health
	health_progress.value		= my_data.curr_health
	action_progress.max_value 	= my_data.max_action
	action_progress.value 		= my_data.curr_action
	
	health_progress.update_bar()
	action_progress.update_bar()

func hide_stats() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.1)

func show_stats() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

func _physics_process(_delta: float) -> void:
	if my_data:
		update_stats()
