extends Control

@onready var health_progress: 	Control = $health_progress
@onready var action_progress: 	Control = $action_progress

@export var show_health := true
@export var show_action := true

var my_data 	: B2_EnemyData
var my_cbt 		#: CombatCharacter

var tween		: Tween
var parent_is_alive := true

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
	if not show_health: health_progress.queue_free()
	if not show_action: action_progress.queue_free()
	show_stats()
	
func update_stats() -> void:
	if show_health:
		health_progress.max_value 	= my_data.max_health
		health_progress.value		= my_data.curr_health
		health_progress.update_bar()
	if show_action:
		action_progress.max_value 	= my_data.max_action
		action_progress.value 		= my_data.curr_action
		action_progress.update_bar()
	
	if my_data.curr_health <= 0.0:
		parent_is_alive = false
		hide_stats()

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
		if parent_is_alive:
			update_stats()
