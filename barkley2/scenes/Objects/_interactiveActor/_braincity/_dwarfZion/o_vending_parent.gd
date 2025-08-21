extends B2_EnvironInteractive

@export var vendingIndex := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var script := \
	"QUEST  | dwarfZion += 1
	DIALOG | Vending | Grabbing candy from this one.
	Misc   | manchurian | pZion%s" % str(vendingIndex)
	_set_new_cinemascript( script )
	
	speed_scale = randf_range(0.6,1.4)

func _set_new_cinemascript( script_text : String ) -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := script_text
	scr.original_script = my_script
	cutscene_script = scr
	
## Only enable if the right vending index
func _process(_delta: float) -> void:
	#_interactive = 0;
	#_disableOutline = 1;
	#if (Quest("dwarfZion") == 5 + vendingIndex)
	#{
	#if (abs(o_hoopz.manchurianProgress) == 1)
	#{
		#_interactive = 1;
		#_disableOutline = 0;
	#}
	#}
	pass

## Set on path
func execute_event_user_0():
	#with (o_hoopz)
	#{
	#scr_player_setStance(scr_player_stance_manchurian);
	#manchurianPath = pZion0;
	#manchurianProgress = 0;
	#x = path_get_x(manchurianPath, manchurianProgress);
	#y = path_get_y(manchurianPath, manchurianProgress);
	#}
	#o_cts_hoopz.x = o_hoopz.x;
	#o_cts_hoopz.y = o_hoopz.y;
	push_error("Manchurian not set. no idea what this is.")
	
## Standard
func execute_event_user_1():
	# with (o_hoopz) scr_player_setStance(scr_player_stance_standard);
	push_error("Manchurian not set. no idea what this is.")
