extends Control
class_name B2_Breakout
## A small textbox used to show money, resources and stuff during dialog.
## I think its also used to make choices, but im not sure.
## 08/01/26 changed from Canvas Layer to Control

# Icon used for Money and such
const ICON_ATLAS 	= preload("res://barkley2/resources/B2_Breakout/icon_atlas.tres")
const FN_2 			= preload("uid://cbgm2fhhwo0ld")

# minimum breakout height
var breakoutYSpc 	:= 42
var breakoutXSpc 	:= 32 * 2

# icon size
var icon_size 		:= 16

# sometimes, breakouts can show text instead of an icon.
var txt 			:= ""
var icon_id 		:= -1

# values used for the animations
var old_value 		:= 0
var new_value 		:= 0
var value 			:= old_value
var value_color 	:= Color.WHITE

# nodes used to display information
var txt_node 		: Label
var icon_node 		: TextureRect
var value_node 		: Label

var breakout_size 	:= Vector2.ZERO # WARNING is this ever used correcly?

# breakout position
var breakoutX 		:= 384 - 8; #Breakout on right side
var breakoutY 		:= 92 + 4;

# What to show on the breakout
var breakout_data 	:= {}

var diag_box 		: B2_DiagBG
var hbox 			: HBoxContainer

var smooth_value_change := false ## Should be true with money. Smoothly decrease or increase the money count.

func _ready() -> void:
	hide() # While the box is being set up, hide itself
	
	# ID myself
	name = "breakout_box"
	
	# Setup the static frame
	diag_box = B2_DiagBG.new()
	
	# Identify this diag box
	diag_box.name = "breakout_frame"
	
	#Diag box setup
	diag_box.theme = preload("res://barkley2/themes/dialogue.tres")
	add_child( diag_box, true )
	
	set_values()
	
	hbox = HBoxContainer.new()
	var margin := MarginContainer.new()
	margin.set_anchors_preset( Control.PRESET_FULL_RECT )
	margin.add_child( hbox, true )
	diag_box.add_child( margin, true  )
	
	if txt == "" and (icon_id >= 0 and icon_id <= 8):
		# Add Icon only
		icon_node = TextureRect.new()
		icon_node.texture = ICON_ATLAS
		icon_node.custom_minimum_size.x = 16.0
		icon_node.texture.region.position.x *= icon_id
		icon_node.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		hbox.add_child( icon_node, true )
	else:
		# Add text only
		txt_node = Label.new()
		txt_node.text = txt + " " # add a space to make sure it looks good.
		txt_node.custom_minimum_size = FN_2.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT)
		txt_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		txt_node.set_anchors_preset(Control.PRESET_FULL_RECT)
		hbox.add_child( txt_node, true )
	#else:
		# weird situation. someone fucked up.
		# either and invalid id is set or something wasn't set properly.
		# breakpoint
	
	# Add text value
	value_node = Label.new()
	value_node.text = str( old_value ) 
	value_node.custom_minimum_size = Vector2(16, 0)
	value_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	hbox.add_child(value_node,true)
	
	# Diagbox sizing
	#await get_tree().process_frame
	var value_size 		:= int(value_node.custom_minimum_size.x)
	var silly_offset 	:= 28
	breakoutXSpc = int( FN_2.get_string_size(txt + " ", HORIZONTAL_ALIGNMENT_LEFT).x ) + value_size + silly_offset # silly_offset is a small buffer for the 'Border' borders.
	
	diag_box.global_position = Vector2( breakoutX - max(breakout_size.x, breakoutXSpc), breakoutY )
	diag_box.set_panel_size( max(breakout_size.x, breakoutXSpc), max(breakout_size.y, breakoutYSpc) )
	
	hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	show() # Bot setup is done. Show itself.
	if smooth_value_change:
		fancy_value_change()
	
## Does some setup for the variables.
# check Breakout line 28
func set_values():
	if breakout_data.has("value"):
		## Need to fix these later.
		## 27-03-26 neet to fix this now. Now, where can I find this piece of code...
		# Hint: https://www.youtube.com/watch?v=j65_4Yzy6xc&t=23047s
		## Its on Breakout() line 70
		
		## Pre-set the value.
		if B2_Item.have_item( breakout_data["value"] ): 	value = B2_Item.count_item( 	breakout_data["value"] ) ## If it's an item get item count
		else: 												value = B2_Playerdata.Quest( 	breakout_data["value"] ) ## If it's a quest get quest state
		
		## Change the icon id or text.
		match breakout_data["value"]:
			"money":
				smooth_value_change = true
				icon_id 	= 0
				old_value 	= breakout_data.get( "prev_value", 0 )
				new_value 	= B2_Playerdata.Quest( breakout_data["value"] )
				value 		= old_value
				
				if breakout_data.get( "modifier", 0 ) > 0:
					new_value += breakout_data.get( "modifier", 0 )
					value_color = Color.GREEN
					
				if breakout_data.get( "modifier", 0 ) < 0:
					new_value += breakout_data.get( "modifier", 0 )
					value_color = Color.RED
				
			"ducats","digiducats":
				icon_id = 8
				value = B2_Playerdata.Quest( breakout_data["value"] )
			"hp":
				icon_id = 2
				value = B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_CURRENT_HP )
			"arrows":
				icon_id = 1
			"batteries":
				icon_id = 3
			"Fiscian Gut's":
				icon_id = 7
			"chupCount":
				txt = "Chups Left:"
			"Bomb":
				icon_id = 4
			"dwarfCustody":
				smooth_value_change = true
				txt = "Dwarves:"
				old_value 	= breakout_data.get( "prev_value", 0 )
				new_value 	= B2_Playerdata.Quest( breakout_data["value"] )
				value 		= old_value
			"W Fruit":
				txt = "W Fruit:"
			"Dreadfruit":
				txt = "Dreadfruit:"
			"Chup":
				txt = "Chups:"
			"d:GLAZEr":
				txt = "d:GLAZErs:"
			"powerGlaze":
				txt = "GLAZE:"
			"govPolicyBalance":
				txt = "Political capital:"
			"Influence Ovum":
				txt = "Influence Ovums:"
			_:
				txt = "INVALID"
				value = 69
				breakpoint
		
		# fard
		# jonathron -> john-tron??? do more research.
	
# Fancily increase or decrease the value counter.
func fancy_value_change():
	var tween := create_tween()
	tween.tween_interval(0.5)
	tween.tween_property( self, "value", new_value, 1.0 )
		
func _process(_delta: float) -> void:
	value_node.text = str( value  )
	value_node.modulate = value_color
