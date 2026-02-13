extends VBoxContainer
class_name B2_Minigame_VRW_Messages

@onready var timer: Timer = $Timer

var message_array := [$message_lbl_1,$message_lbl_2,$message_lbl_3,$message_lbl_4,$message_lbl_5,]

func scr_vrw_username() -> String:
	var nam : String = ["Garth", "Wendy", "Dundit", "Perry", "Tony", "Samson", "Babs", "Zorb", "Mandy", "Paula", "Sandra"].pick_random()
	var ggg := randi_range(0,2);
	match ggg:
		0: nam = nam.to_lower()
		1: nam = nam.to_upper()

	var ali : String = ["Holy", "DoGood", "Vengeful", "Wicked"].pick_random()
	ggg = randi_range(0,2);
	match ggg:
		0: ali = ali.to_lower()
		1: ali = ali.to_upper()

	var cla : String = ["Croupier", "Jobber", "Cobbler", "Roofer"].pick_random()
	ggg = randi_range(0,2);
	match ggg:
		0: cla = cla.to_lower()
		1: cla = cla.to_upper()

	var adj : String = ["Sexual", "Wise", "Big", "Lanky", "Astute", "Groovy", "Solid", "Liquid", "Wet"].pick_random()
	ggg = randi_range(0,2);
	match ggg:
		0: adj = adj.to_lower()
		1: adj = adj.to_upper()

	var num := "";
	ggg = randi_range(0,5)
	match ggg:
		0: num = str(randi_range(0,999))
		1: num = str(randi_range(0,99))
		2: num = str(randi_range(0,9))

	# Florish
	var flo : String = ["$", "%", "_", "-", "!", ".", ":", "*"].pick_random()
	if randf() < 0.75: flo = ""

	# Choose combining method
	var fir : String = [adj, ali].pick_random()
	var sec : String = [cla, nam].pick_random()
	ggg = randi_range(0,9);
	if ggg <= 7:
		return flo + fir + sec + num + flo;
	elif ggg == 8:
		return flo + "_" + fir + "_" + sec + "_" + num + "_" + flo;
	else:
		return flo + "-" + fir + "-" + sec + "-" + num + "-" + flo;
	
func scr_vrw_message() -> String:
	## scr_vrw_message()
	# Generates a message for VRW
	var ali : String = ["Holy", "DoGood", "Vengeful", "Wicked"].pick_random()
	var cla : String = ["Croupier", "Jobber", "Cobbler", "Roofer"].pick_random()
	var tea : String = ali + " " + cla;
	var it0 : String = ["pop cream", "dig juice", "bark", "glue"].pick_random()
	var it1 : String = ["mud boot", "wap bap", "leather", "tin can"].pick_random()
	var loc : String = ["Tomb of Gorfald", "Popper's Burrow", "Mud Mountain", "Easy Street", "The Grapevine"].pick_random()
	var num : String = str( randi_range(0,50) )

	var ped_messages : String = [
		["Hi", "Hey", "Hello", "Sup", "Selam", "Greets", "Meets", "Salutations", "hell;o[", "ho", "hep", "hep ho"].pick_random(),
		["argh popper ruin my score", "i slayed " + num + " popper", "I kill Popper's with great ease.", "popper dead", "popper down", "bap popper now", "Time to Bap some Popper's..."].pick_random(),
		["where " + str( loc ).to_lower(), "how to goto " + str( loc ).to_lower(), "Where is " + str( loc ) + "?", "I found " + str( loc ) + "!"].pick_random(),
		["i hat u", "i hate you", "gor to hell", "get out of here", "Go away!", "Scram you whelp!", "I dislike you strongly."].pick_random(),
		["tx", "thx", "thnks", "thanx", "thanks", "Thanks.", "Thank you!", "Wow, thanks so much!"].pick_random(),
		["mub boot?", "ne1 hav mud boot?", "Anyone have mud boots?"].pick_random(),
		["bonus time?", "where is does bonus", "When does the bonus start?"].pick_random(),
		["trade " + str( it0 ).to_lower() + " for " + str( it1 ).to_lower() + "?", "where to get " + [it0, it1].pick_random() + "?", "Anyone have " + str( it0 ).to_lower()+ "?"].pick_random(),
		["team up " + str( tea ).to_lower() + "?", "any " + str( tea ).to_lower() + " to raid?", "Looking for a " + str( tea ) + "."],
		["milk bar = scam", "wow!!! milk bar rip me off!!!", "The Milk Bar is a rip-off!"].pick_random(),
		["GO TO ******.** AND SIGN UP", "visit my page *****.***.**", "Here's my page: ******.***"].pick_random(),
		["WHERE IS " + scr_vrw_username() + "!", "where did " + scr_vrw_username() + " go", "Hey, does anyone know " + scr_vrw_username() + "?"].pick_random(),
		["suiwrb", "4378bhfnk", "4r58hfbh2", "7ajhhagdjh", "asdfasfsagd", "wqerwerwwe", "tu8jgn a as", "bn nr089h", "gjg4jgnnb", "3tj3jgjnkjr", "gorhjito", "gjugi84h", "sdfsadfoj"].pick_random()
		].pick_random()
	
	return [ped_messages, ped_messages.to_lower(), ped_messages.to_upper()].pick_random()

#func _ready() -> void:
	### Cleanup
	#for i in message_array:
		#i.queue_free()
	#timer
