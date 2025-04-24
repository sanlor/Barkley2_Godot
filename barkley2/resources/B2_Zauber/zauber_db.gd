extends Node
class_name B2_Zauber

## NOTE Unfinished.

const c_bio		:= Color8(27, 255, 1)
const c_cosmic	:= Color8(207, 83, 0)
const c_cyber	:= Color8(84, 186, 254)
const c_mental	:= Color8(226, 154, 138)
const c_zauber	:= Color8(211, 42, 222)

enum {REF,SCRIPT,NAME,COLOR,SUB}
const ZAUBER_LIST := {
	## Zauber HUD icon is in s_item_16
##  Ref        Script              		Name                       Color      		Sub
	"bio0":    ["ZauberPozzosPrison", 	"Pozzo's Prison",          c_bio,    		 4],
	"kosmik0": ["ZauberPush",         	"Duffery's Flagrant Foul", c_cosmic, 		 7],
	"zauber0": ["ZauberStarlight",    	"Summon Some Fary's",      c_zauber, 		 8],
	"mental0": ["ZauberBallSucker",   	"Ball Sucker",             c_mental, 		 6],
	"cyber0":  ["ZauberFeeber",       	"MaxFeeber.EXE",           c_cyber,  		 5],
	"clown0":  ["ZauberClown",        	"Confetti Brast",          Color.FUCHSIA,	 12],
	}
	
static func ZauberPozzosPrison() -> void:
	pass
	
static func ZauberPush() -> void:
	pass
	
static func ZauberStarlight() -> void:
	pass
	
static func ZauberBallSucker() -> void:
	pass
	
static func ZauberFeeber() -> void:
	pass
	
static func ZauberClown() -> void:
	pass
