@tool
extends B2_EnvironInteractive

@export var switchName := "sewerSwitch4";
@export var oBridge : Control
@export_tool_button("Get SwitchName") var _s : Callable = _get_switch_name

func _get_switch_name() -> void:
	var n : String = get_meta("code")
	var p_name := n.get_slice('"', 1)
	switchName = p_name

func _ready() -> void:
	if Engine.is_editor_hint():
		animation = "default"
		is_interactive = true
		return
		
	## Sometimes, bidges can take a while to load, causing some issues with unloadd collisions.
	await get_tree().process_frame
	
	if B2_Playerdata.Quest(switchName) == 1:
		execute_event_user_2()
	else:
		animation = "default"
		is_interactive = true
		execute_event_user_1()
	
func execute_event_user_1() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"MOVETO  | o_cts_hoopz | %s | MOVE_NORMAL
	WAIT    | 0
	USEAT   | NORTH
	SOUND   | sn_mg_puzzlelock_open1
	WAIT    | 0.2
	EVENT   | %s | 2
	SOUND   | sn_sewerBridge01
	WAIT    | 0.2
	QUEST   | %s = 1" % ["cinema_0", name, switchName]
	scr.original_script = my_script
	cutscene_script = scr
		
func execute_event_user_2():
	if oBridge:
		oBridge.execute_event_user_1()
		animation = "flipped"
		is_interactive = false
		
func execute_event_user_10() -> void:
	pass
