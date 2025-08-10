extends B2_VR_Mission

@onready var mission_ticker: 			Timer = $mission_ticker ## Mission duration
@onready var mission_timer: 			Timer = $mission_timer	## Ticker used to check if all enemies are defeated.
@onready var mission_timer_label: 		Label = $mission_ui/screen/mission_timer_label
@onready var enemy_count_lbl: 			Label = $mission_ui/screen/enemy_hbox/enemy_count_lbl
@onready var screen: 					MarginContainer = $mission_ui/screen
@onready var o_enemy_rat_nest: 			AnimatedSprite2D = $o_enemy_ratNest
@onready var o_enemy_rat_nest_2: 		AnimatedSprite2D = $o_enemy_ratNest2

var enemy_count := 0

func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	mission_timer_label.text = convert_seconds( mission_timer.time_left )
	screen.modulate = Color.TRANSPARENT
	o_enemy_rat_nest.enable_full_auto( false )
	o_enemy_rat_nest_2.enable_full_auto( false )

func execute_event_user_0() -> void:
	var t := create_tween()
	t.tween_property(screen, "modulate", Color.WHITE, 3.0)
	await t.finished
	o_enemy_rat_nest.enable_full_auto( true )
	o_enemy_rat_nest_2.enable_full_auto( true )
	mission_timer.start()
	mission_ticker.start()

func disable_hoopz_control() -> void:
	B2_Input.player_has_control = false
	
func enable_hoopz_control() -> void:
	B2_Input.player_has_control = true

func count_enemies() -> void:
	var c := 0
	for child in get_children():
		if child is B2_EnemyCombatActor:
			if not child.is_actor_dead:
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
	o_enemy_rat_nest.enabled = false
	o_enemy_rat_nest.enable_full_auto( false )
	o_enemy_rat_nest_2.enabled = false
	o_enemy_rat_nest_2.enable_full_auto( false )

func _on_mission_ticker_timeout() -> void:
	count_enemies()
	if enemy_count == 0 and mission_timer.is_stopped():
		## Mission over, congrats!
		mission_ticker.stop()
		print("Mission 1 finished.")
		var t := create_tween()
		t.tween_callback( mission_over.emit )
		t.tween_property( self, "modulate", Color.TRANSPARENT, 1.0 )
		t.tween_callback( queue_free )
		
		B2_Screen.show_mission_complete_screen()
