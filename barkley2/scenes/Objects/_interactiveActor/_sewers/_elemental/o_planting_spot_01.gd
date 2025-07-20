extends B2_EnvironInteractive

@export var seedName := "sewerSeed0"

func _ready() -> void:
	_make_cinema_script()
	
func _make_cinema_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"IF %s == 1 | GOTO | SPROUTED
	IF @Sewer Seed@ >= 1 | GOTO | SEEDLING_SOW
	GOTO    | SEEDLING_NO

	SPROUTED
	DIALOG  | P_NAME  | Eww...

	SEEDLING_SOW
	DIALOG  | P_NAME  | Ah, a spot for me to sow a Sewer Seed. Should I do it?
	CHOICE  | Sow a Sewer Seed here? (@item_Sewer Seed@x held)
	REPLY   | SOW_YES | Yeah!
	REPLY   | SOW_NAY | Nay!

	SOW_YES
	DIALOG  | P_NAME  | Alright, here goes...
	USEAT   | o_plantingSpot01
	EVENT   | o_plantingSpot01 | 0
	WAIT    | 0.25
	PLAYSET | o_plantingSpot01 | sprout | sprouted
	SOUND   | sn_plantanspawn01
	WAIT    | 0.75
	QUEST   | %s = 1
	QUEST   | growthElementalSeedsSown += 1
	ITEM    | Sewer Seed | -1
	WAIT    | 1.0
	SET     | o_plantingSpot01 | gaze

	SOW_NAY
	DIALOG  | P_NAME  | Nay, not here, not now.

	SEEDLING_NO
	DIALOG  | P_NAME  | This looks like a good spot to sow something. But I have nothing to sow." % [seedName, seedName]
	scr.original_script = my_script
	cutscene_script = scr
	
func execute_event_user_2() -> void:
	play("gaze")

func _on_animation_changed() -> void:
	match animation:
		"default":
			offset = Vector2( -7, -7 )
		_:
			offset = Vector2( -13, -31 )
