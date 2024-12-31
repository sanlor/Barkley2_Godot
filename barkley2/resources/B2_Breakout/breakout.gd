extends CanvasLayer
class_name B2_Breakout

## A small textbox used to show money, resources and stuff during dialog.
## I think its also used to make choices, but im not sure.

# Icon used for Money and such
const ICON_ATLAS = preload("res://barkley2/resources/B2_Breakout/icon_atlas.tres")

# minimum breakout height
var breakoutYSpc := 42
var breakoutXSpc := 32 * 2

# icon size
var icon_size := 16

# sometimes, breakouts can show text instead of an icon.
var txt 		:= ""
var icon_id 	:= -1

# values used for the animations
var old_value 	:= 0
var new_value 	:= 0
var value 		:= old_value
var value_color := Color.WHITE

# nodes used to display information
var txt_node : Label
var icon_node : TextureRect
var value_node : Label

var breakout_size := Vector2.ZERO

# breakout position
var breakoutX := 384 - 8; #Breakout on right side
var breakoutY := 92 + 4;

# What to show on the breakout
var breakout_data := {}

var diag_box : B2_DiagBG

func _ready() -> void:
	# Make sure its on top of everything else
	layer = B2_Config.DIALOG_LAYER
	# Setup the static frame
	diag_box = B2_DiagBG.new()
	# Identify this diag box
	diag_box.name = "breakout_frame"
	#Diag box setup
	
	
	diag_box.theme = preload("res://barkley2/themes/dialogue.tres")
	add_child( diag_box, true )
	
	set_values()
	
	var hbox := HBoxContainer.new()
	diag_box.add_child( hbox )
	
	if txt == "":
		# Add Icon
		icon_node = TextureRect.new()
		icon_node.texture = ICON_ATLAS
		icon_node.texture.region.position.x *= icon_id
		icon_node.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		hbox.add_child( icon_node )
	elif icon_id >= 0 and icon_id <= 8:
		# Add id text
		txt_node = Label.new()
		txt_node.text = txt + " " # add a space to make sure it looks good.
		#txt_node.custom_minimum_size = Vector2(36, 0)
		txt_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hbox.add_child(txt_node)
	else:
		# weird situation. someone fucked up.
		# either and invalid id is set or something wans set properly.
		breakpoint
	
		# Add text value
	value_node = Label.new()
	value_node.text = str( old_value ) 
	value_node.custom_minimum_size = Vector2(36, 0)
	value_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hbox.add_child(value_node)
	
	await get_tree().process_frame # The size propriety is avaiable only after a process frame.
	breakout_size = hbox.size
	breakout_size.x += 32 # small buffer
	
	hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Diagbox sizing
	diag_box.global_position = Vector2( breakoutX - max(breakout_size.x, breakoutXSpc), breakoutY )
	diag_box.set_panel_size( max(breakout_size.x, breakoutXSpc), max(breakout_size.y, breakoutYSpc) )
	
	fancy_value_change()
	
func set_values():
	if breakout_data.has("value"):
		match breakout_data["value"]:
			"money":
				icon_id 	= 0
				old_value 	= breakout_data.get( "prev_value", 0 )
				new_value 	= B2_Playerdata.Quest( "money" )
				value 		= old_value
				
				if breakout_data.get( "modifier", 0 ) > 0:
					new_value += breakout_data.get( "modifier", 0 )
					value_color = Color.GREEN
					
				if breakout_data.get( "modifier", 0 ) < 0:
					new_value += breakout_data.get( "modifier", 0 )
					value_color = Color.RED
				
			"ducats":
				icon_id = 8
			"hp":
				icon_id = 2
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
				txt = "Dwarves:"
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
				breakpoint
		
		## Need to fix these later.
		#if (argument[1] == "money") _val = scr_money_count();
		#else if (argument[1] == "hp") _val = scr_stats_getCurrentStat(o_hoopz, STAT_CURRENT_HP);
		#else if (Item("index", argument[1]) >= 0) _val = Item("count", argument[1]); //If it's an item get item count
		#else _val = scr_quest_get_state(argument[1]); //If it's a quest get quest state
	#pass
	
func fancy_value_change():
	var tween := create_tween()
	tween.tween_interval(0.5)
	tween.tween_property( self, "value", new_value, 1.0 )
		
func _process(_delta: float) -> void:
	value_node.text = str( value  )
	value_node.modulate = value_color
