@tool
extends Control

## The original code is VERY complex. It does a lot of stuff related to the gunball population, generation and stuff like that.
## Im only keeping the important stuff and translating the rest do godot.

signal quarter_anim_finished
signal gumball_anim_finished( ball_chosen )

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

@onready var quarter_anim = $quarter_anim
@onready var quarter_anim_text = $quarter_anim_text

@onready var balls = $balls

@onready var gumball_expand = $gumball_expand

const S_CC_GUMBALL_SMALL_0 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_small_0.png")
const S_CC_GUMBALL_SMALL_1 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_small_1.png")
const S_CC_GUMBALL_SMALL_2 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_small_2.png")
const S_CC_GUMBALL_SMALL_3 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_small_3.png")
const S_CC_GUMBALL_SMALL_4 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_small_4.png")

const S_CC_GUMBALL_LARGE_0 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_large_0.png")
const S_CC_GUMBALL_LARGE_1 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_large_1.png")
const S_CC_GUMBALL_LARGE_2 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_large_2.png")
const S_CC_GUMBALL_LARGE_3 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_large_3.png")
const S_CC_GUMBALL_LARGE_4 = preload("res://barkley2/assets/b2_original/images/cc/s_cc_gumball_large_4.png")
var S_CC_GUMBALL_LARGE := [ S_CC_GUMBALL_LARGE_0, S_CC_GUMBALL_LARGE_1, S_CC_GUMBALL_LARGE_2, S_CC_GUMBALL_LARGE_3, S_CC_GUMBALL_LARGE_4 ]

@onready var machineX = size.x / 2;
@onready var machineY = (size.y / 2) + 52;

var gumNam : Array[String] ## Array of Gumball names
var gumExt : Array[String] ## Array of Gumball Descriptions
var gumCol : Array[Color] ## Array of Gumball Colors
var gumSub : Array[CompressedTexture2D] ## Array of Gumball Textures

var candle_offset := Vector2(0,-50)

var chosen_gumball := 0

func _ready():
#region Setup
	gumNam.resize(13)
	gumCol.resize(13)
	gumSub.resize(13)
	gumExt.resize(16)
	
#region gunNam
	
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
	
#endregion
#region gunExt
	
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
#region gunCol
	
	gumCol[0] = Color8(196, 128, 0)
	gumCol[1] = Color.WHITE
	gumCol[2] = Color.WHITE
	gumCol[3] = Color.WHITE
	gumCol[4] = Color.WHITE
	gumCol[5] = Color8(255, 0, 0)
	gumCol[6] = Color8(255, 255, 0)
	gumCol[7] = Color8(0, 0, 255)
	gumCol[8] = Color8(255, 255, 255)
	gumCol[9] = Color8(0, 224, 0)
	gumCol[10] = Color8(255, 128, 0)
	gumCol[11] = Color8(32, 32, 32)
	gumCol[12] = Color8(128, 0, 255)
	
#endregion
#region gumSub
	gumSub[0] = S_CC_GUMBALL_SMALL_0
	gumSub[1] = S_CC_GUMBALL_SMALL_1
	gumSub[2] = S_CC_GUMBALL_SMALL_2
	gumSub[3] = S_CC_GUMBALL_SMALL_3
	gumSub[4] = S_CC_GUMBALL_SMALL_4
	gumSub[5] = S_CC_GUMBALL_SMALL_0
	gumSub[6] = S_CC_GUMBALL_SMALL_0
	gumSub[7] = S_CC_GUMBALL_SMALL_0
	gumSub[8] = S_CC_GUMBALL_SMALL_0
	gumSub[9] = S_CC_GUMBALL_SMALL_0
	gumSub[10] = S_CC_GUMBALL_SMALL_0
	gumSub[11] = S_CC_GUMBALL_SMALL_0
	gumSub[12] = S_CC_GUMBALL_SMALL_0
	

#endregion

#endregion
	var drx := 0.0
	var dry := 30.0 + 240.0 * 0.20
	tarot_table.position 				= Vector2(384.0 / 2.0, dry + 120.0)
	
	s_cc_tarot_candle_2.position 		= Vector2(60, dry + 105) + candle_offset
	s_cc_tarot_candle_2.scale 			= Vector2(0.75,0.75)
	s_cc_tarot_candle_3.position 		= Vector2(324, dry + 105) + candle_offset
	s_cc_tarot_candle_3.scale 			= Vector2(0.75,0.75)
	s_cc_tarot_candle_0.position 		= Vector2(40, dry + 120) + candle_offset
	s_cc_tarot_candle_1.position 		= Vector2(344, dry + 120) + candle_offset
	
	gumball_expand.hide()
	gumball_expand.scale = Vector2.ZERO
	gumball_expand.position = Vector2( 192, 167 )
	
func gumball_populate():
	pass

func show_quarter():
	quarter_anim.show()
	quarter_anim_text.show()
	quarter_anim.scale = Vector2.ZERO
	quarter_anim_text.scale = Vector2.ZERO
	
	var scale_tween := create_tween()
	scale_tween.tween_property( quarter_anim, "scale", Vector2.ONE, 0.5 )
	scale_tween.parallel().tween_property( quarter_anim_text, "scale", Vector2.ONE, 0.5 )
	
	scale_tween.tween_callback( B2_Sound.play.bind("sn_cc_gumball_coin_jingle") )
	scale_tween.tween_interval( 3.0 )
	
	scale_tween.tween_property( quarter_anim, "scale", Vector2.ZERO, 0.5 )
	scale_tween.parallel().tween_property( quarter_anim_text, "scale", Vector2.ZERO, 0.5 )
	
	await scale_tween.finished
	quarter_anim_finished.emit()
	
	quarter_anim.hide()
	quarter_anim_text.hide()
	
func drop_gumball():
	# pick gumball
	chosen_gumball = randi_range(0, 12)  ## DEBUG
	var gumball_anim = $gunball_animation/gumball_path/gumball
	var gumball_expand_sprite = $gumball_expand/gumball_sprite
	# add texture to sprites
	gumball_anim.texture 				= gumSub[ chosen_gumball ]
	gumball_anim.modulate 				= gumCol[ chosen_gumball ]
	gumball_expand_sprite.texture 		= S_CC_GUMBALL_LARGE[ chosen_gumball ] # gumSub[ chosen_gumball ]
	gumball_expand_sprite.modulate 		= gumCol[ chosen_gumball ]
	print( "gummball: ", chosen_gumball, " - ", gumNam[ chosen_gumball ] )
	
	await balls.nudge() # Nudge the ball a bit downward
	var gumball_path = $gunball_animation/gumball_path
	gumball_path.progress_ratio = 0.0
	
	var tween_gumball := create_tween()
	# tween gumball movement
	tween_gumball.tween_property( gumball_path, "progress_ratio", 1.0, 2.0 )
	tween_gumball.tween_callback( gumball_path.hide )
	# gumball reached the slot, exmand it.
	tween_gumball.tween_callback( gumball_expand.show )
	tween_gumball.tween_property( gumball_expand, "scale", Vector2.ONE, 1.0 )
	tween_gumball.parallel().tween_property( gumball_expand, "position", Vector2( 192, 72 ), 1.0 )
	tween_gumball.tween_interval( 1.0 )
	tween_gumball.tween_callback( emit_signal.bind("gumball_anim_finished", chosen_gumball) ) ## let the cc_wizard knwo that the anim is finished
	
