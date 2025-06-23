extends Control
# Check o_dnet_registration_boot

signal finished_animation

@onready var boot_title: 				Label = $boot_title
@onready var system_check: 				Label = $system_check
@onready var connection_check: 			Label = $connection_check
@onready var mem_check: 				Label = $mem_check
@onready var mem_check_complete: 		Label = $mem_check_complete
@onready var boot_exec: 				Label = $boot_exec

var t : Tween
var memory := 0

func _gui_input(event: InputEvent) -> void:
	## Quit animation
	if visible:
		if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
			if Input.is_action_just_pressed("Holster"):
				if t:
					t.kill()
					finish_animation()

func begin_animation() -> void:
	boot_title.hide()
	system_check.hide()
	connection_check.hide()
	mem_check.hide()
	mem_check_complete.hide()
	boot_exec.hide()
	
	## Laziest implementation possible!!!!
	t = create_tween()
	t.tween_interval( 0.5 )
	t.tween_callback( boot_title.show )
	t.tween_interval( 0.5 )
	
	t.tween_callback( system_check.set_text.bind( Text.pr( "System check" ) ) )
	t.tween_callback( system_check.show )
	t.tween_interval( 1.5 * randf_range(0.5, 1.5) )
	t.tween_callback( system_check.set_text.bind( Text.pr( "System check . . . . . . . . . . ok" ) ) )
	
	t.tween_interval( 0.5 )
	
	t.tween_callback( connection_check.set_text.bind( Text.pr( "Connection check" ) ) )
	t.tween_callback( connection_check.show )
	t.tween_interval( 1.0 * randf_range(0.5, 1.5) )
	t.tween_callback( connection_check.set_text.bind( Text.pr( "Connection check . . . . . . . . ok" ) ) )
	
	t.tween_interval( 1.0 )
	
	t.tween_callback( mem_check.set_text.bind( Text.pr( "Memory check - 0" ) ) )
	t.tween_callback( mem_check.show )
	t.tween_method( inc_mem,0, B2_DNET.MEMORY_CHECK_GOAL, 3.0 )
	t.tween_callback( mem_check.set_text.bind( Text.pr( "Memory check - %s bytes" % str(B2_DNET.MEMORY_CHECK_GOAL) ) ) )
	t.tween_interval( 0.25 )
	t.tween_callback( mem_check_complete.set_text.bind( Text.pr( "Check complete" ) ) )
	t.tween_callback( mem_check_complete.show )
	t.tween_interval( 1.25 )
	
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE" ) ) )
	t.tween_callback( boot_exec.show )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . . ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . . . ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . . . . ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . . . . . ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . . . . . . ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . . . . . . . ." ) ) )
	t.tween_interval( randf() )
	t.tween_callback( boot_exec.set_text.bind( Text.pr( "Boot DNETREG.EXE . . . . . . . . ok" ) ) )
	t.tween_interval( 2.0 )
	t.tween_callback( finish_animation )
	
	## TODO add "Beep" sfx
	
func inc_mem( amt : int ) -> void:
	memory = amt
	
func finish_animation() -> void:
	finished_animation.emit()
	hide()

func _process(_delta: float) -> void:
	if mem_check.visible:
		if memory != B2_DNET.MEMORY_CHECK_GOAL:
			mem_check.text = Text.pr( "Memory check - " ) + str(memory)
