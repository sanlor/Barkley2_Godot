@tool
extends Control

@onready var tarot_table = $tarot_table
@onready var s_cc_tarot_candle_0 = $SCcTarotCandle0
@onready var s_cc_tarot_candle_1 = $SCcTarotCandle1
@onready var s_cc_tarot_candle_2 = $SCcTarotCandle2
@onready var s_cc_tarot_candle_3 = $SCcTarotCandle3

@onready var s_cc_gumball_machine_0 = $SCcGumballMachine0
@onready var s_cc_gumball_machine_1 = $SCcGumballMachine1
@onready var s_cc_gumball_machine_2 = $SCcGumballMachine2
@onready var s_cc_gumball_machine_3 = $SCcGumballMachine3
@onready var s_cc_gumball_machine_4 = $SCcGumballMachine4
@onready var s_cc_gumball_machine_5 = $SCcGumballMachine5

var gumNam : Array[String]
var gumExt : Array[String]

var candle_offset := Vector2(0,-50)

func _ready():
#region Setup
	gumNam.resize(13)
	gumExt.resize(16)
	
	gumNam[0] = "Butterscotch";
	gumNam[1] = "Foul";
	gumNam[2] = "Transparent";
	gumNam[3] = "Winner";
	gumNam[4] = "Steel";
	gumNam[5] = "Red";
	gumNam[6] = "Yellow";
	gumNam[7] = "Blue";
	gumNam[8] = "White";
	gumNam[9] = "Green";
	gumNam[10] = "Orange";
	gumNam[11] = "Black";
	gumNam[12] = "Grape";
	gumExt[0] = "Foul - Destroy";
	gumExt[1] = "Foul - Keep";
	gumExt[2] = "Red - Strawberry";
	gumExt[3] = "Red - Cherry";
	gumExt[4] = "Yellow - Banana";
	gumExt[5] = "Yellow - Lemon";
	gumExt[6] = "Blue - Blueberries";
	gumExt[7] = "Blue - Raspberries";
	gumExt[8] = "White - Flavorless";
	gumExt[9] = "White - Flavorful";
	gumExt[10] = "Green - Apple";
	gumExt[11] = "Green - Watermelon";
	gumExt[12] = "Orange - Fruit";
	gumExt[13] = "Orange - Color";
	gumExt[14] = "Black - Liquorice";
	gumExt[15] = "Black - Coffee";
	
#endregion
	var dry = 30 + 240 * 0.20
	tarot_table.position = Vector2(384 / 2, dry + 120)
	
	s_cc_tarot_candle_2.position = Vector2(60, dry + 105) + candle_offset
	s_cc_tarot_candle_2.scale = Vector2(0.75,0.75)
	s_cc_tarot_candle_3.position = Vector2(324, dry + 105) + candle_offset
	s_cc_tarot_candle_3.scale = Vector2(0.75,0.75)
	s_cc_tarot_candle_0.position = Vector2(40, dry + 120) + candle_offset
	s_cc_tarot_candle_1.position = Vector2(344, dry + 120) + candle_offset
	
func gumball_populate():
	pass
