#@icon("res://barkley2/assets/b2_original/images/merged/icon_parent.png")
@icon("res://barkley2/assets/b2_original/images/merged/icon_camera.png")
extends CanvasLayer
class_name B2_Cinema

## DEBUG
@export var debug_dialog 		:= false
@export var debug_wait 			:= false
@export var debug_sound 		:= false
@export var debug_moveto 		:= false
@export var debug_unhandled 	:= false

@export var cutscene_script : B2_Script

# used for the "CREATE" event
var object_map := {
	"o_tutorial_popups01" : null,
}

@export var camera				: Camera2D
var all_nodes					:= []

func _ready() -> void:
	all_nodes = get_parent().get_children()
	
func play_cutscene():
	if cutscene_script is B2_Script_Legacy:
		# Split the script into separate lines
		var split_script : PackedStringArray = cutscene_script.original_script.split( "\n", false )
		
		for line : String in split_script:
			var parsed_line : PackedStringArray = line.split( "|", false )
			
			# Cleanup
			for i in range( parsed_line.size() ):
				parsed_line[i] = parsed_line[i].strip_edges( true, true )
			
			match parsed_line[0].to_upper():
				"REPLY":
					pass
				"CHOICE":
					pass
				"WAIT":
					await get_tree().create_timer( float( parsed_line[1] ) ).timeout
					if debug_wait: print("Wait: ", float( parsed_line[1] ) )
				"EXIT":
					print("EXIT")
					break # exit the loop
				"DIALOG", "MYSTERY":
					if debug_dialog: print( parsed_line[1], " ", parsed_line[2])
					var dialogue := B2_Dialogue.new()
					add_child(dialogue)
					# parse talker´s name
					if parsed_line[1].contains("="):
						var talker_split = parsed_line[1].split("=")
						var talker_name := talker_split[0].strip_edges(true,true)
						var talker_port := talker_split[1].strip_edges(true,true)
						dialogue.set_portrait(talker_port, false)
						dialogue.set_text( parsed_line[2].strip_edges(true,true), talker_name )
					else:
						dialogue.set_portrait( parsed_line[1].strip_edges(true,true), true )
						dialogue.set_text( parsed_line[2].strip_edges(true,true) )
						
					await dialogue.display_dialog()
					dialogue.queue_free()
				"SHAKE":
					pass
				"ITEM":
					pass
				"NOTIFY":
					pass
				"NOTIFYALT":
					pass
				"PLAYSET":
					pass
				"SET":
					pass
				"GOTO":
					pass
				"QUEST":
					pass
				"BREAKOUT":
					pass
				"FADE":
					pass
				"SOUND":
					if parsed_line.size() > 2:
						# Loops
						B2_Sound.play( parsed_line[1], 0.0, false, int( parsed_line[2] ) )
						if debug_sound: print(parsed_line[1], " with %s loops" % parsed_line[2])
					else:
						B2_Sound.play( parsed_line[1], 0.0, false )
						if debug_sound: print(parsed_line[1])
				"EVENT":
					pass
				"NOTE":
					pass
				"SHOP":
					pass
				"LOCKPICK":
					pass
				"CHATROULETTE":
					pass
				"CREATE":
					pass
				"CREATE_WAIT":
					pass
				"FRAME":
					var move_points := parsed_line.size() - 2 # first 2 are the action and speed.
					var move_array : Array[Node2D] = []
					
					for point in move_points:
						var dest := get_node_from_name( all_nodes, parsed_line[ 2 + point ] )
						if dest == null:
							if debug_moveto: print("FRAME: destination_object is invalid: ", dest, " - ", parsed_line[ 2 + point ] )
						move_array.append( dest )
					
					if not move_array.is_empty():
						# if debug_moveto: print("FRAME: destination_object is valid: ", move_array )
						var speed 					= parsed_line[1]
						await camera.cinema_moveto( move_array, speed )
					else:
						if debug_moveto: print("FRAME: destination_object is invalid: ", move_array )
				"LOOKAT":
					pass
				"LOOK":
					pass
				"MOVETO":
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] )
					var destination_object 		= get_node_from_name( all_nodes, 	parsed_line[2] )
					# Make sure that the actors and cinemaspots exists
					if actor != null:
						# if debug_moveto: print("MOVETO: actor is valid: ",parsed_line[1])
						if destination_object != null:
							# if debug_moveto: print("MOVETO: destination_object is valid: ",parsed_line[2])
							var speed 					= parsed_line[3]
							await actor.cinema_moveto( destination_object, speed )
						else:
							if debug_moveto: print("MOVETO: destination_object is invalid: ",parsed_line[2])
					else:
						if debug_moveto: print("MOVETO: actor is invalid: ",parsed_line[1])
				"MOVE":
					pass
				_:
					if debug_unhandled: print( "Unhandled text: ", parsed_line[0] )
		
		print( "Finished Animation" )

func get_node_from_name( _array, _name ) -> Node2D:
	var node : Node2D
	for item in _array:
		if item is Node2D:
			if item.name == _name:
				node = item
	return node
