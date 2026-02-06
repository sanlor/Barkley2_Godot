@tool
extends B2_Border

@onready var list_refresh_lbl: Label = $MarginContainer/VBoxContainer/list_refresh_lbl
@onready var list_slot_1: HBoxContainer = $MarginContainer/VBoxContainer/list_slot_1
@onready var list_slot_2: HBoxContainer = $MarginContainer/VBoxContainer/list_slot_2
@onready var list_slot_3: HBoxContainer = $MarginContainer/VBoxContainer/list_slot_3
@onready var list_slot_4: HBoxContainer = $MarginContainer/VBoxContainer/list_slot_4
@onready var list_slot_5: HBoxContainer = $MarginContainer/VBoxContainer/list_slot_5

@onready var list_players_lbl_1: 	Label = $MarginContainer/VBoxContainer/list_slot_1/list_players_lbl
@onready var list_server_lbl_1: 	Label = $MarginContainer/VBoxContainer/list_slot_1/list_server_lbl
@onready var list_ping_lbl_1: 		Label = $MarginContainer/VBoxContainer/list_slot_1/list_ping_lbl

@onready var list_players_lbl_2: 	Label = $MarginContainer/VBoxContainer/list_slot_2/list_players_lbl
@onready var list_server_lbl_2: 	Label = $MarginContainer/VBoxContainer/list_slot_2/list_server_lbl
@onready var list_ping_lbl_2: 		Label = $MarginContainer/VBoxContainer/list_slot_2/list_ping_lbl

@onready var list_players_lbl_3:	Label = $MarginContainer/VBoxContainer/list_slot_3/list_players_lbl
@onready var list_server_lbl_3: 	Label = $MarginContainer/VBoxContainer/list_slot_3/list_server_lbl
@onready var list_ping_lbl_3: 		Label = $MarginContainer/VBoxContainer/list_slot_3/list_ping_lbl

@onready var list_players_lbl_4: 	Label = $MarginContainer/VBoxContainer/list_slot_4/list_players_lbl
@onready var list_server_lbl_4: 	Label = $MarginContainer/VBoxContainer/list_slot_4/list_server_lbl
@onready var list_ping_lbl_4: 		Label = $MarginContainer/VBoxContainer/list_slot_4/list_ping_lbl

@onready var list_players_lbl_5: 	Label = $MarginContainer/VBoxContainer/list_slot_5/list_players_lbl
@onready var list_server_lbl_5: 	Label = $MarginContainer/VBoxContainer/list_slot_5/list_server_lbl
@onready var list_ping_lbl_5: 		Label = $MarginContainer/VBoxContainer/list_slot_5/list_ping_lbl

@onready var o_mg_vrw_title: 		Control = $".."

var serNam := ["Archibalds_Domain",			"BappersONLY",					"Poppers_Den",				"(L) GrapestersParadise",		"TESTTESTESTTEST"]
var serPly := [2 + randi_range(0,3), 		7000, 							600 + randi_range(0,61), 	20 + randi_range(0,5), 			00]
var serMax := [16,							7000,							800,						50,								00]
var serPng := [9999,						50 + randi_range(0,20),			151 + randi_range(0,50),	20 + randi_range(0,10),			00]

var hovering_server := 0
var selected_server := 0 :
	set(s):
		selected_server = s
		if o_mg_vrw_title:
			o_mg_vrw_title.selected_server = s

func _reset_ranges() -> void:
	serPly = [2 + randi_range(0,3), 7000, 					600 + randi_range(0,61), 	20 + randi_range(0,5), 	00]
	serPng = [9999,					50 + randi_range(0,20),	151 + randi_range(0,50),	20 + randi_range(0,10),	00]

func _ready():
	super()
	list_slot_1.focus_entered.connect( _hover_server.bind(0, true) )
	list_slot_2.focus_entered.connect( _hover_server.bind(1, true) )
	list_slot_3.focus_entered.connect( _hover_server.bind(2, true) )
	list_slot_4.focus_entered.connect( _hover_server.bind(3, true) )
	list_slot_5.focus_entered.connect( _hover_server.bind(4, true) )
	
	list_slot_1.focus_exited.connect( _hover_server.bind(0, false) )
	list_slot_2.focus_exited.connect( _hover_server.bind(1, false) )
	list_slot_3.focus_exited.connect( _hover_server.bind(2, false) )
	list_slot_4.focus_exited.connect( _hover_server.bind(3, false) )
	list_slot_5.focus_exited.connect( _hover_server.bind(4, false) )
	
	list_slot_1.mouse_entered.connect( _hover_server.bind(0, true) )
	list_slot_2.mouse_entered.connect( _hover_server.bind(1, true) )
	list_slot_3.mouse_entered.connect( _hover_server.bind(2, true) )
	list_slot_4.mouse_entered.connect( _hover_server.bind(3, true) )
	list_slot_5.mouse_entered.connect( _hover_server.bind(4, true) )
	
	list_slot_1.mouse_exited.connect( _hover_server.bind(0, false) )
	list_slot_2.mouse_exited.connect( _hover_server.bind(1, false) )
	list_slot_3.mouse_exited.connect( _hover_server.bind(2, false) )
	list_slot_4.mouse_exited.connect( _hover_server.bind(3, false) )
	list_slot_5.mouse_exited.connect( _hover_server.bind(4, false) )
	
	# Chilaaaaaax
	await get_tree().process_frame
	
	_reset_ranges()
	_populate_server_list()
	_select_server(-1, true)
	
	list_refresh_lbl.show()
	list_refresh_lbl.text = Text.pr("Refresh for servers.")
	refresh_servers()
	
func refresh_servers() -> void:
	for i in 5:
		_hover_server(i, false)
		_select_server(i, false)
	list_slot_1.hide()
	list_slot_2.hide()
	list_slot_3.hide()
	list_slot_4.hide()
	list_slot_5.hide()
	
func display_server( server_id : int ) -> void:
	list_refresh_lbl.hide()
	match server_id:
		0:	list_slot_1.show()
		1:	list_slot_2.show()
		2:	list_slot_3.show()
		3:	list_slot_4.show()
		4:	list_slot_5.show()

func _populate_server_list() -> void:
	list_players_lbl_1.text = Text.pr( serNam[0] )
	list_server_lbl_1.text	= str(serPly[0]) + "/" + str(serMax[0])
	list_ping_lbl_1.text	= str(serPng[0])
	
	list_players_lbl_2.text = Text.pr( serNam[1] )
	list_server_lbl_2.text	= str(serPly[1]) + "/" + str(serMax[1])
	list_ping_lbl_2.text	= str(serPng[1])
	
	list_players_lbl_3.text = Text.pr( serNam[2] )
	list_server_lbl_3.text	= str(serPly[2]) + "/" + str(serMax[2])
	list_ping_lbl_3.text	= str(serPng[2])
	
	list_players_lbl_4.text = Text.pr( serNam[3] )
	list_server_lbl_4.text	= str(serPly[3]) + "/" + str(serMax[3])
	list_ping_lbl_4.text	= str(serPng[3])
	
	list_players_lbl_5.text = Text.pr( serNam[4] )
	list_server_lbl_5.text	= str(serPly[4]) + "/" + str(serMax[4])
	list_ping_lbl_5.text	= str(serPng[4])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventKey:
		if Input.is_action_just_pressed("Action"):
			if hovering_server >= 0:
				_select_server( hovering_server, true )

func _hover_server( server_id : int, active : bool ) -> void:
	if selected_server == server_id: return
	
	var color := Color.WHITE
	if active: 
		color = Color.YELLOW
		hovering_server = server_id
	else:
		hovering_server = -1
		
	match server_id:
		0:	list_slot_1.modulate = color
		1:	list_slot_2.modulate = color
		2:	list_slot_3.modulate = color
		3:	list_slot_4.modulate = color
		4:	list_slot_5.modulate = color
	
func _select_server( server_id : int, active : bool ) -> void:
	var color := Color.WHITE
	if active: 
		color = Color.GREEN
		selected_server = server_id
		for i in 5:
			_hover_server(i, false)
	else:
		selected_server = -1
		
	match server_id:
		0:	list_slot_1.modulate = color
		1:	list_slot_2.modulate = color
		2:	list_slot_3.modulate = color
		3:	list_slot_4.modulate = color
		4:	list_slot_5.modulate = color
	#selected_server = server_id
