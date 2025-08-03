extends Node2D

@onready var mission_timer: Timer = $mission_timer
@onready var mission_timer_label: Label = $mission_ui/screen/mission_timer_label
@onready var enemy_count_lbl: Label = $mission_ui/screen/enemy_hbox/enemy_count_lbl

var enemy_count := 0

func _ready() -> void:
	mission_timer.start()

func count_enemies() -> void:
	var c := 0
	for child in get_children():
		if child is B2_EnemyCombatActor:
			c += 1
	enemy_count = c
	enemy_count_lbl.text = "x" + str(enemy_count).pad_zeros(2)

func convert_seconds(total_seconds: int) -> String:
	@warning_ignore("integer_division")
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func _on_child_entered_tree(node: Node) -> void:
	if node is B2_EnemyCombatActor:
		count_enemies()

func _on_child_exiting_tree(node: Node) -> void:
	if node is B2_EnemyCombatActor:
		count_enemies()

func _physics_process(_delta: float) -> void:
	@warning_ignore("narrowing_conversion")
	mission_timer_label.text = convert_seconds( mission_timer.time_left )

func _on_mission_timer_timeout() -> void:
	pass # Replace with function body.
