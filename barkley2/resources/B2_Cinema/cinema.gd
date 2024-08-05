#@icon("res://barkley2/assets/b2_original/images/merged/icon_parent.png")
@icon("res://barkley2/assets/b2_original/images/merged/icon_camera.png")
extends CanvasLayer
class_name B2_Cinema

@export var cutscene_script : B2_Script

# used for the "CREATE" event
var object_map := {
	"o_tutorial_popups01" : null,
}

func _ready() -> void:
	pass
	
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
					print("Wait: ", float( parsed_line[1] ) )
				"EXIT":
					print("EXIT")
					break # exit the loop
				"DIALOG", "MYSTERY":
					print( parsed_line[1], " ", parsed_line[2])
					var dialogue := B2_Dialogue.new()
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
					else:
						B2_Sound.play( parsed_line[1], 0.0, false )
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
					pass
				"LOOKAT":
					pass
				"LOOK":
					pass
				"MOVETO":
					pass
				"MOVE":
					pass
				_:
					print( "Unhandled text: ", parsed_line[0] )
		
		print( "Finished Animation" )
