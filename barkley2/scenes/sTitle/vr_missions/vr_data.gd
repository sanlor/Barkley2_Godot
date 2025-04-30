extends Node

const MISSION_DB := {
	0 : {
		"image" :		"",
		"description" : "Simple battle with three enemies, to help you bet used to the new combat system.",
		"room_name" : 	"",
		"room_x"	: 	0.0,
		"room_y"	: 	0.0,
	},
	2 : {
		"image" :		"",
		"description" : "",
		"room_name" : 	"",
		"room_x"	: 	0.0,
		"room_y"	: 	0.0,
	},
	3 : {
		"image" :		"",
		"description" : "",
		"room_name" : 	"",
		"room_x"	: 	0.0,
		"room_y"	: 	0.0,
	},
	4 : {
		"image" :		"",
		"description" : "",
		"room_name" : 	"",
		"room_x"	: 	0.0,
		"room_y"	: 	0.0,
	},
	5 : {
		"image" :		"",
		"description" : "",
		"room_name" : 	"",
		"room_x"	: 	0.0,
		"room_y"	: 	0.0,
	},
	999 : {
		"image" :		"",
		"description" : "invalid_mission",
		"room_name" : 	"invalid_room",
		"room_x"	: 	0.0,
		"room_y"	: 	0.0,
	},
}

@export var my_mission_id := 0

static func get_description( _id : int ) -> String:
	return MISSION_DB.get(_id, 999)["description"]
	
static func get_room_string( _id : int ) -> String:
	var r := str( MISSION_DB.get(_id, 999)["room_name"] )
	var x := str( MISSION_DB.get(_id, 999)["room_x"] )
	var y := str( MISSION_DB.get(_id, 999)["room_y"] )
	return ( r + "," + x + "," + y )
