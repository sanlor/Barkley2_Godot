@tool
extends PanelContainer

const USERS_DATA 			:= preload("res://barkley2/resources/B2_DNET/users_data.json")
const S_DNET_AVATAR_L 		:= preload("res://barkley2/scenes/_utilityStation/dwarfnet/sDNETAvatarL.tres")
const S_DNET_AVATAR_M 		:= preload("res://barkley2/scenes/_utilityStation/dwarfnet/sDNETAvatarM.tres")

enum{AVATAR, SUB, POST, BANNED, SIGNATURE}

@onready var poster_name_lbl:			Label = $MarginContainer/VBoxContainer/name_field/MarginContainer/HBoxContainer/poster_name
@onready var poster_date_lbl: 			Label = $MarginContainer/VBoxContainer/name_field/MarginContainer/HBoxContainer/poster_date
@onready var avatar_texture: 			TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/photo_field/MarginContainer/avatar_texture
@onready var post_text: 				Label = $MarginContainer/VBoxContainer/HBoxContainer/post_field/MarginContainer/post_text
@onready var signature_text: 			Label = $MarginContainer/VBoxContainer/signature_field/MarginContainer/signature_text
@onready var ban_texture: 				TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/photo_field/MarginContainer/ban_texture

@export var poster_name				:= "WFCompson"
@export var poster_time 			:= "12:34"
@export var message					:= "Farts and such."

@export_tool_button("Update Icon") var _update : Callable = update_button

func _ready() -> void:
	update_button()

func update_button() -> void:
	post_text.text = message.replace( "#", "\n" )
	poster_name_lbl.text = poster_name
	
	var post_hour 		:= poster_time.get_slice(":", 0)
	var post_minute 	:= poster_time.get_slice(":", 1)
	
	## TODO Fix Time
	if USERS_DATA.data[poster_name][BANNED]:
		ban_texture.show()
		pass
	else:
		ban_texture.hide()
		if B2_DNET.get_time_hour() - int(post_hour)  > 24: poster_date_lbl.text = "Posted %s day(s) ago" % str( ( B2_DNET.get_time_hour() - int(post_hour)  ) / 24 )
		else: poster_date_lbl.text = "Posted today at %s" % str( int(post_hour) + B2_DNET.get_time_hour() ).pad_zeros(2) + ":" + str( int(post_minute) + B2_DNET.get_time_minute() ).pad_zeros(2) + "."
	
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
