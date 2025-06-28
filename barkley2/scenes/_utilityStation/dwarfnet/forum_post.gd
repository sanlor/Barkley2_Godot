@tool
extends PanelContainer

const USERS_DATA 			:= preload("res://barkley2/resources/B2_DNET/users_data.json")
const S_DNET_AVATAR_L 		:= preload("res://barkley2/scenes/_utilityStation/dwarfnet/sDNETAvatarL.tres")
const S_DNET_AVATAR_M 		:= preload("res://barkley2/scenes/_utilityStation/dwarfnet/sDNETAvatarM.tres")
const S_DNET_MISC 			:= preload("res://barkley2/scenes/_utilityStation/dwarfnet/sDNETMisc.tres")

const POST_QUOTE = preload("res://barkley2/scenes/_utilityStation/dwarfnet/post/post_quote.tscn")
const POST_TEXT = preload("res://barkley2/scenes/_utilityStation/dwarfnet/post/post_text.tscn")

## STATUS | 0 = Regular, 1 = Primo, 2 = Mod, 3 = Banned
enum{AVATAR, SUB, POST, STATUS, SIGNATURE}

@onready var forum_post: 		PanelContainer = $"."
@onready var name_field: 		PanelContainer = $MarginContainer/VBoxContainer/name_field
@onready var photo_field: 		PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/photo_field
@onready var post_field: 		PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/post_field
@onready var post_field2: 		PanelContainer = $MarginContainer/VBoxContainer/HBoxContainer/post_field
@onready var signature_field: 	PanelContainer = $MarginContainer/VBoxContainer/signature_field


@onready var poster_name_lbl:			Label = $MarginContainer/VBoxContainer/name_field/MarginContainer/HBoxContainer/poster_name
@onready var poster_date_lbl: 			Label = $MarginContainer/VBoxContainer/name_field/MarginContainer/HBoxContainer/poster_date
@onready var avatar_texture: 			TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/photo_field/MarginContainer/avatar_texture
#@onready var post_text: 				Label = $MarginContainer/VBoxContainer/HBoxContainer/post_field/MarginContainer/post_text
@onready var signature_text: 			Label = $MarginContainer/VBoxContainer/signature_field/MarginContainer/signature_text
@onready var ban_texture: 				TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/photo_field/MarginContainer/ban_texture

@onready var post_list: VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/post_field/MarginContainer/post_list

@onready var banned_bg: ColorRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/post_field/banned_bg
@onready var post_count: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/post_field/VBoxContainer/post_count
@onready var post_pips_list: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/post_field/VBoxContainer/post_pips_list

@export var poster_name				:= "WFCompson"
@export var poster_time 			:= "12:34"
@export var message_1				:= "Farts and such."
@export var quote_1					:= "lalalala."
@export var message_2				:= "Lol what?"
@export var quote_2					:= "Mhuahaha."
@export var warning					:= "Fudeu."

@export_tool_button("Update Icon") var _update : Callable = update_button

func _ready() -> void:
	update_button()

func _get_pip_count( post : int ) -> int:
	var pips := 0
	if post < 10:			pips = 0
	elif post < 50:			pips = 1
	elif post < 100:		pips = 2
	elif post < 250:		pips = 3
	elif post < 500:		pips = 4
	elif post < 1000:		pips = 5
	elif post < 5000:		pips = 6
	else:					pips = 7
	return pips

## TODO Fix color blending issues. It does look different from the original.
func _modulate_panel( color : Color ) -> void:
	color = color.darkened(0.35)
	forum_post.self_modulate 		= color
	name_field.self_modulate 		= color
	photo_field.self_modulate 		= color
	post_field.self_modulate 		= color
	post_field2.self_modulate 		= color
	signature_field.self_modulate 	= color

func update_button() -> void:
	banned_bg.hide()
	ban_texture.hide()
	
	poster_name_lbl.text = poster_name
	
	for i in post_list.get_children():
		i.queue_free()
	
	## Set post
	if message_1:
		var t := POST_TEXT.instantiate()
		t.text = message_1.replace( "#", "\n" )
		post_list.add_child(t)
	if quote_1:
		var q := POST_QUOTE.instantiate()
		post_list.add_child(q)
		q.set_text( quote_1 )
	if message_2:
		var t := POST_TEXT.instantiate()
		t.text = message_2.replace( "#", "\n" )
		post_list.add_child(t)
	if quote_2:
		var q := POST_QUOTE.instantiate()
		post_list.add_child(q)
		q.set_text( quote_2 )
	
	
	var post_hour 		:= poster_time.get_slice(":", 0)
	var post_minute 	:= poster_time.get_slice(":", 1)
	
	var poster_status : int = USERS_DATA.data[poster_name][STATUS]
	
	## TODO Fix Time
	if warning:
		poster_date_lbl.text = warning
		poster_date_lbl.modulate = Color.RED
	else:
		if B2_DNET.get_time_hour() + int( post_hour ) >= 24: 
			@warning_ignore("integer_division")
			poster_date_lbl.text = "Posted %s day(s) ago" % str( int(post_hour) / 24 )
		else:
			var t : String = str( int(post_hour) ).pad_zeros(2) + ":" + str( int(post_minute) ).pad_zeros(2)
			poster_date_lbl.text = "Posted today at %s." % t
	
	## Post count, PRIMO status and Banned status
	match poster_status:
		0,2: ## Regular and Mods
			var post : int = USERS_DATA.data[poster_name][POST]
			post_count.text = str( post )
			var pips := _get_pip_count(post)
				
			if poster_status == 2:
				_modulate_panel( B2_DNET.dnetColorPostMod )
				poster_name_lbl.modulate = B2_DNET.dnetColorNameMod
			else:
				_modulate_panel( B2_DNET.dnetColorPostReg )
				poster_name_lbl.modulate = B2_DNET.dnetColorNameReg
				
			for i in pips:
				var text := TextureRect.new()
				text.texture = S_DNET_MISC
				text.modulate = B2_DNET.dnetColorPip[poster_status]
				post_pips_list.add_child( text )
			
		1: ## Primo (Premium users)
			var post : int = USERS_DATA.data[poster_name][POST]
			post_count.text = str( post )
			
			_modulate_panel( B2_DNET.dnetColorPostPre )
			poster_name_lbl.modulate = B2_DNET.dnetColorNamePre
			
			var pips := _get_pip_count(post)
			var label := post_count.duplicate()
			label.text = "PRIMO"
			label.modulate = B2_DNET.dnetColorNamePre.lerp( Color.GRAY, 0.5 )
			post_pips_list.add_child( label )
			
		3: ## Banned
			post_count.text 		= "BANNED"
			post_count.modulate 	= B2_DNET.dnetColorPip[poster_status]
			post_count.modulate 	= Color.RED
			
			banned_bg.show()
			ban_texture.show()
			
			_modulate_panel( B2_DNET.dnetColorPostBan )
			poster_name_lbl.modulate = B2_DNET.dnetColorNameBan
			
		_:
			breakpoint
	
	## Get poster data
	if not USERS_DATA.data.has(poster_name):
		push_error("No valid user name called %s." % poster_name)
		return
		
	if USERS_DATA.data[poster_name].has("sDNETAvatarL"):
		avatar_texture.texture = S_DNET_AVATAR_L.duplicate()
	elif USERS_DATA.data[poster_name].has("sDNETAvatarM"):
		avatar_texture.texture = S_DNET_AVATAR_M.duplicate()
	else:
		push_error("Invalid Avatar")
		return
		
	avatar_texture.texture.region.position.x = 35 * int( USERS_DATA.data[poster_name][SUB] )
	signature_text.text = USERS_DATA.data[poster_name][SIGNATURE].replace( "#", "\n" )
