extends CanvasLayer

## Handles the UI for the Utility Station.
# Check ustation, Utility and o_utilitystation

signal flickered( alpha : float )

# Utility Menu Settings
const SETTINGUTILITYSMELT 			:= 50 			# How much smelt you get per gun - balance 30->50 on 031719 - bhroom
const SETTINGUTILITYTEXTALPHA 		:= 0.8 			# Alpha of all text
const SETTINGUTILITYSPRITEALPHA 	:= 0.8 			# Alpha of all sprites
const SETTINGUTILITYALPHABACK 		:= 0.05 		# Alpha of grid BG
const SETTINGUTILITYALPHAGLOW 		:= 0.075 		# Alpha of glowing (text, grid)
const SETTINGUTILITYALPHABORDER 	:= 0.15 		# Alpha of foreground grids, lines, etc
#const settingUtilityHue 			:= 80 			# Menu hue - Set in player identity by gumball
const SETTINGUTILITYMONO 			:= 0.15 		# How colorful the menu is, 0 being more B&W 1 being full color
const UTILITYALPHA 					:= 0

# Smelt data
var smeltGain 		:= SETTINGUTILITYSMELT; ## Link to Settings
var smeltEmpty 		:= "Are you sure you want to smelt all empty Gun'sbag guns?"
var smeltUnfaves 	:= "Are you sure you want to smelt all unfavorited Gun'sbag guns?"
var smeltAll 		:= "Are you sure you want to smelt all Gun'sbag guns?"
var renameError 	:= "Gun name already exists in bando."
var renameShort 	:= "Gun names must be 4 characters long."
var bandoFull 		:= "Bando is full. Smelt a bando gun to make space for promotion."

# Color of blip icons for the Bando
var gunCol := [
	Color.from_rgba8(241, 217, 95),
	Color.from_rgba8(253, 89, 100),
	Color.from_rgba8(122, 83, 10),
	Color.from_rgba8(181, 230, 29),
	Color.from_rgba8(255, 128, 64),
]
# Blackness of outer frame, to make the border stand out less
var borderBlackness 	= 0.2;
var textButtonBreed 	= "Commence"; 		# Breed - Commence
var textButtonEmpty 	= "Empty"; 			# Breed - Empty slot
var textBreedEmpty 		= "Select a gun.";
var textItemless 		= "No items.";

# Quotes
var quoTxt := [
	"A baby gun arrives.",
	"A new gun enters the fray.",
	"A mysterious gun emerges from the woods.",
	"A darling gun saunters forth.",
	]

func _init() -> void:
	B2_Screen.utility_screen = self
	B2_Screen.is_utility_open = true
	push_error("DEBUG")
	

func _process(_delta: float) -> void:
	flickered.emit( randf_range(0.06,0.12) )
