@tool
extends B2_EnvironInteractive
## https://youtu.be/SQKRnzWSW0M?t=16445

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var qst := "draw_" + get_room_area()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	modulate.s = 0.40
	_make_cinema_script()

## Activate homing particles.
func execute_event_user_0():
	# with o_effect_drawing_point_particle homing = true;
	push_warning("Particle effect not set yet.")

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if B2_Playerdata.Quest(qst) == 0:
		var inc := 0.25 * delta
		modulate.h = wrapf(modulate.h + inc, 0.0, 1.0)
		gpu_particles_2d.emitting = true
	else:
		modulate = Color.WHITE
		gpu_particles_2d.emitting = false

func _make_cinema_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"IF %s == 0         | GOTO | DRAW
	IF @Firaga@ >= 100          | GOTO | JUNCTION
	IF junctionGuts == 1        | GOTO | SWAP
	IF junctionLuck == 1        | GOTO | SWAP
	IF junctionAcrobatics == 1  | GOTO | SWAP
	IF junctionMight == 1       | GOTO | SWAP
	IF junctionPiety == 1       | GOTO | SWAP
	GOTO | EMPTY

	DRAW
	DIALOG | | Found a draw point!#Firaga found
	CHOICE | Who will draw?
	REPLY  | DONT  | Don't draw
	REPLY  | HOOPZ | P_NAME

	DONT
	DIALOG | | No one drew.

	HOOPZ
	MOVETO | o_cts_hoopz | o_gbl_drawing_point | MOVE_NORMAL
	WAIT   | 0
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | SOUTH
	WAIT   | 0.5
	SET    | o_cts_hoopz | firaga
	WAIT   | 0.5
	EVENT  | o_gbl_drawing_point | 0
	WAIT   | 0.25
	SOUND  | sn_pearlgunshot01
	QUEST  | %s = 1
	ITEM   | Firaga | 5
	WAIT   | 2
	DIALOG | | P_NAME stocked 5 Firagas.
	WAIT   | 0.5
	IF @Firaga@ >= 100 | GOTO | JUNCTION_CHOICE

	EMPTY
	DIALOG | P_NAME | I think this draw point is empty...

	SWAP
	MOVETO | o_cts_hoopz | o_gbl_drawing_point | MOVE_NORMAL
	WAIT   | 0
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | SOUTH
	WAIT   | 0.5
	SET    | o_cts_hoopz | firaga
	WAIT   | 0.5
	DIALOG | | Change your Junctioning of Firaga?
	CHOICE | Who will Junction Firaga?
	REPLY  | JUNCTION_NO  | Don't Junction
	REPLY  | JUNCTION_YES | P_NAME

	JUNCTION
	MOVETO | o_cts_hoopz | o_gbl_drawing_point | MOVE_NORMAL
	WAIT   | 0
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | SOUTH
	WAIT   | 0.5
	SET    | o_cts_hoopz | firaga
	WAIT   | 0.5
	GOTO   | JUNCTION_CHOICE

	JUNCTION_CHOICE
	DIALOG | | You have the required amount of Firaga. Would you like to Junction them?
	CHOICE | Who will Junction Firaga?
	REPLY  | JUNCTION_NO  | Don't junction
	REPLY  | JUNCTION_YES | P_NAME

	JUNCTION_NO
	DIALOG | | Firaga was not junctioned.

	JUNCTION_YES
	CHOICE | Junction Firaga to what attribute?
	REPLY  | JG | Guts
	REPLY  | JL | Luck
	REPLY  | JA | Acrobatics
	REPLY  | JM | Might
	REPLY  | JP | Piety
	REPLY  | CANCEL | Cancel Junction

	JG
	SOUND     | sn_pearlgunshot03
	NOTIFY    | Firaga was junctioned to Guts!
	NOTIFYALT | Guts increased by 10 points.
	IF junctionGuts = 1         | GLAMP | guts | -10
	IF junctionLuck = 1         | GLAMP | luck | -10
	IF junctionAcrobatics = 1   | GLAMP | acrobatics | -10
	IF junctionMight = 1        | GLAMP | might | -10
	IF junctionPiety = 1        | GLAMP | piety | -10
	QUEST | junctionGuts = 1
	QUEST | junctionLuck = 0
	QUEST | junctionAcrobatics = 0
	QUEST | junctionMight = 0
	QUEST | junctionPiety = 0
	GLAMP | guts | 10

	JL
	SOUND     | sn_pearlgunshot03
	NOTIFY    | Firaga was junctioned to Luck!
	NOTIFYALT | Luck increased by 10 points.
	IF junctionGuts = 1         | GLAMP | guts | -10
	IF junctionLuck = 1         | GLAMP | luck | -10
	IF junctionAcrobatics = 1   | GLAMP | acrobatics | -10
	IF junctionMight = 1        | GLAMP | might | -10
	IF junctionPiety = 1        | GLAMP | piety | -10
	QUEST | junctionGuts = 0
	QUEST | junctionLuck = 1
	QUEST | junctionAcrobatics = 0
	QUEST | junctionMight = 0
	QUEST | junctionPiety = 0
	GLAMP | luck | 10

	JA
	SOUND     | sn_pearlgunshot03
	NOTIFY    | Firaga was junctioned to Acrobatics!
	NOTIFYALT | Acrobatics increased by 10 points.
	IF junctionGuts = 1         | GLAMP | guts | -10
	IF junctionLuck = 1         | GLAMP | luck | -10
	IF junctionAcrobatics = 1   | GLAMP | acrobatics | -10
	IF junctionMight = 1        | GLAMP | might | -10
	IF junctionPiety = 1        | GLAMP | piety | -10
	QUEST | junctionGuts = 0
	QUEST | junctionLuck = 0
	QUEST | junctionAcrobatics = 1
	QUEST | junctionMight = 0
	QUEST | junctionPiety = 0
	GLAMP | acrobatics | 10

	JM
	SOUND     | sn_pearlgunshot03
	NOTIFY    | Firaga was junctioned to Might!
	NOTIFYALT | Might increased by 10 points.
	IF junctionGuts = 1         | GLAMP | guts | -10
	IF junctionLuck = 1         | GLAMP | luck | -10
	IF junctionAcrobatics = 1   | GLAMP | acrobatics | -10
	IF junctionMight = 1        | GLAMP | might | -10
	IF junctionPiety = 1        | GLAMP | piety | -10
	QUEST | junctionGuts = 0
	QUEST | junctionLuck = 0
	QUEST | junctionAcrobatics = 0
	QUEST | junctionMight = 1
	QUEST | junctionPiety = 0
	GLAMP | might | 10

	JP
	SOUND     | sn_pearlgunshot03
	NOTIFY    | Firaga was junctioned to Piety!
	NOTIFYALT | Piety increased by 10 points.
	IF junctionGuts = 1         | GLAMP | guts | -10
	IF junctionLuck = 1         | GLAMP | luck | -10
	IF junctionAcrobatics = 1   | GLAMP | acrobatics | -10
	IF junctionMight = 1        | GLAMP | might | -10
	IF junctionPiety = 1        | GLAMP | piety | -10
	QUEST | junctionGuts = 0
	QUEST | junctionLuck = 0
	QUEST | junctionAcrobatics = 0
	QUEST | junctionMight = 0
	QUEST | junctionPiety = 1
	GLAMP | piety | 10

	CANCEL
	DIALOG | | Junction did not occur." % [qst, qst]
	scr.original_script = my_script
	cutscene_script = scr
