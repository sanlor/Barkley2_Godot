extends Node

## WARNING This is a big mess. maybe move this to B2_PlayerData?

## NOTE OFCOURSE THIS STUPID FEATURE ALSO USES SOME WEIRD ASS LOGIC. WHY WHY WHY?
## Maps used the path "quest.maps" to store map data. THIS BS SCRIPT uses "quest.vars" along with all other quest variables. all notes uses note_ prefixes.
## Fuck that, im coding my own solution.
## ATTENTION This might break compatibility with the original game´s save file. What to do....?

## NOTE Original Text contains the escape character "\n". replaced it with "#". check NOTE() line 448

var event_placeholder = null

var notes 		:= {}
var persons 	:= {}
var arts 		:= {}

func _ready() -> void:
	init_setup()
	B2_Note.take_note( "Wilmer's Amortization Schedule" ) ## DEBUG
	
func init_setup() -> void:
	## NOTES - add_note( subimage, name, sound)
	## Baldomero
	add_note( 0, "Blank Paper", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|0");
	add_note( 2, "Suicide Note", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|2~STR|To whoever finds this note:\nforget about me, and forget\nyou saw this, my last missive\nto a cruel world. This isn't\nwhat I expected, and\ncertainly not what I asked\nfor. This is it... the end! I mean\nit! No more living from this\npoint on. I'm all done, it's over\nforever! That's it.|-77|-85|1|8600940|1");
	add_note( 2, "Augustino's Letter", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|2~STR|Hello. Good morning.\nThis is your dear friend who\nis very much alive, Augustino.\nI am currently engaged in  a\nleisurely sewer junket and\nwill return shortly.  Don't\ncome looking for me as my\nschedule is capricious.\nCordially yours, A.|-74|-82|1|8600940|1");
	## Joad
	add_note( 3, "Tattered Paper", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|4~STR|0501 - commence sortie|-134|-63|6|10092545|1~STR|0613 - waypoint BRAVO rea- \n       hostiles neutralized|-134|-49|6|10027013|1~STR|0735 - waypoint DEBRA, \n       McGillycuddy took\n       shrapnel to the hams|-133|-25|6|10223620|1~STR|0747 - EVAC requested|-135|9|6|10223620|1~STR|0756 - unknown entity appro|-134|24|6|10223620|1");
	add_note( 3, "Ancient Scroll", "sn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|4~STR|01000010011001010110111001100101011\n00001011101000110100000100000011101\n00011010000110010100100000010100110\n11001010111011001100101011011100111\n01000110100000100000010110100110100\n10110011101100111011101010111001001\n10000101110100001000000110110001101\n00101100101001000000111010001101000\n01100101001000000100001101101000011\n01001011011000110010001110010011001\n01011011100010000001101111011001100\n01000000111010001101000011001010010\n00000100001001100101011011000110111\n10111001001101011001000000101000001\n10100001100101011011100110111101101\n10101100101011011100110111101101110|-49|-60|3|2595772|1~STR|      <0>\n       _\n     _[ ]_\n   _[     ]_\n _[         ]_\n[_____________]|-125|-48|9|0|1");
	add_note( 3, "Dead Soldier's Note (reused)", "sn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|3~STR|MISSION COMPRIMISED|-105|-33|1|254|1~STR|BAINSHEE ATTACK|-92|-11|1|435|1~STR|REPORTING: SGT. -|-50|50|1|65716|1~STR|WAYPOINT DEBRA SEALED\nCASUALTIES 80%|-108|9|1|65716|1~STR|W-W-T-B?|52|-57|0|254|1");
	add_note( 3, "Joad's Note (reused)", "ssn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|3~STR|MISSION COMPRIMISED|-105|-33|1|254|1~STR|BAINSHEE ATTACK|-92|-11|1|435|1~STR|REPORTING: SGT. -|-50|50|1|65716|1~STR|WAYPOINT DEBRA SEALED\nCASUALTIES 80%|-108|9|1|65716|1~STR|W-W-T-B?|52|-57|0|254|1~STR|REPORTING: SGT. JOAD, LONGINUS|-50|50|1|65716|1~STR|--- 100%|-39|27|1|254|1");
	add_note( 4, "Dead Soldier's Note", "sn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|4~STR|0501 - commence sortie|-133|-63|6|10092545|0.27~STR|0613 - waypoint BRAVO rea- \n       hostiles neutralized|-135|-49|6|10027013|0.34~STR|0735 - waypoint DEBRA, \n       McGillycuddy took\n       shrapnel to the hams|-134|-25|6|10223620|0.23~STR|0747 - EVAC requested|-135|9|6|10223620|0.30~STR|0756 - unknown entity appro|-134|23|6|10223620|0.42~STR|MISSION COMPRIMISED|-105|-33|1|254|1~STR|BAINSHEE ATTACK|-92|-11|1|435|1~STR|REPORTING: SGT. -|-50|50|1|65716|1~STR|WAYPOINT DEBRA SEALED\nCASUALTIES 80%|-108|9|1|65716|1~STR|W-W-T-B?|52|-57|0|254|1");
	add_note( 4, "Joad's Note", "ssn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|4~STR|0501 - commence sortie|-133|-63|6|10092545|0.27~STR|0613 - waypoint BRAVO rea- \n       hostiles neutralized|-135|-49|6|10027013|0.34~STR|0735 - waypoint DEBRA, \n       McGillycuddy took\n       shrapnel to the hams|-134|-25|6|10223620|0.23~STR|0747 - EVAC requested|-135|9|6|10223620|0.30~STR|0756 - unknown entity appro|-134|23|6|10223620|0.42~STR|MISSION COMPRIMISED|-105|-33|1|254|1~STR|BAINSHEE ATTACK|-92|-11|1|435|1~STR|REPORTING: SGT. -|-50|50|1|65716|1~STR|WAYPOINT DEBRA SEALED\nCASUALTIES 80%|-108|9|1|65716|1~STR|W-W-T-B?|52|-57|0|254|1~STR|REPORTING: SGT. JOAD, LONGINUS|-50|50|1|65716|1~STR|--- 100%|-39|27|1|254|1");
	add_note( 5, "Bloody Paper", "sn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|5~STR|     - commence sortie|-133|-63|6|16475493|1~STR|       way   nt BRAVO rea- \n       ho   les neu     zed|-133|-49|6|16777027|0.31~STR|   5 -    poi   DEBRA, \n       Mc illy  ddy     \n       shrapnel t   h|-132|-24|6|10223620|1~STR|0747 - EVAC requested|-135|10|6|16672102|0.17~STR|07   - unknown en   y|-135|24|6|10223620|0.27");
	## Anxo
	add_note( 6, "Sealed Letter", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|6");
	add_note( 7, "Love Letter", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|7~STR|My dearest,|-11|-88|9|13657769|1~STR| I wade through the muck and|-3|-55|8|16672102|1~STR| sludge for thee, guided not by|-17|-42|8|16672102|1~STR|the light of my torch, but by the |-15|-28|8|13657701|1~STR|internal compass of our love.|-13|-13|8|10249959|1~STR|Mine heart longs for your gentle|-14|1|8|16672102|1~STR|touch, and I also yearn for your|-14|15|8|16672102|1~STR|prize-winning chicken salad.|-14|30|8|16672102|1~STR|Prepare yourself, and some salad,|-13|46|8|13788773|1~STR|for my return.|-12|60|8|16672102|1~STR|You'res truly,|-7|74|9|13657769|1~STR|- A|110|85|9|13657769|1");
	## Eric
	add_note( -1, "Pet Shop Application", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|9");
	add_note( -2, "Completed Application", "sn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|9");
	add_note( 11, "Pet Manifesto", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|11~STR|Pet Manifesto|-43|-4|7|16777215|1");
	add_note( 11, "Pet Apocrypha", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|11~STR|Pet Apocrypha|-43|-4|7|16777215|1");
	## Standalone notes
	add_note( 8, "Gamesmasterjasper's Vidcon Almanac", "sn_debug_one", "BAK|s_tnn_papers|8"); ## VR Chair
	add_note( 11, "Cornrow's Plea", "sn_mnu_noteFlipLight01", " BAK|s_tnn_papers|11~STR|X1, this is an emergency.\nWe've been captured by \nWe need you to break us out!\nI need to keep this short\n'cuz they're getting suspicious\nabout us running Choco-mallows\nthrough the undersewers.\nI've left a gun for you under\nthis crate. Take it and get to\n                        for the love\nof Clispaeth! I can hear\nthem torturing Juicebox!\nHis screams are terrible!\nCome save us, we're part\nof the community!|-91|-87|13|16776516|1~STR|MR Z|35|-70|2|3355344|1~STR|Al Akihabara|-87|32|2|3355344|1");
	add_note( 12, "Clandestine Courts Baller Zine", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|12"); ## Baller Zine
	add_note( 13, "Wilmer's Amortization Schedule", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|15~STR|By Holy Supreme\nand Regnant Decree\nof Lord Emperor\nCuchulainn|-23|-84|3|3355344|1~STR|It is hereby known to\nDwarfkin and Duergar alike\n\nThat        \n\nof         ,\nis duly charged with\nremittance to The\nResplendent Coffers of\nPresident Cuchulainn,\nthe value of\n\n      Cuchu-Bucks\nor current equivalent\nneuroshekels.\n\nDue upon the reading\nof this decree.|-69|-48|3|0|1~STR|Mr. Wilmer|-41|-27|3|509|1~STR|Tir na nOg|-54|-13|3|254|1~STR|180,348|-68|36|3|509|1");
	add_note( 8, "Aelfleda's Eviction", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|15~STR|By Holy Supreme\nand Regnant Decree\nof Lord Emperor\nCuchulainn|-23|-83|3|3355344|1~STR|As your first and final\nnotice, The Tir na nOg\nDepartment of Population\nand Housing hereby evicts\nyour sorry ass and\nsentences you to a miser-\nable existence in the Sewer\nin Accordance with\nSection 1 Article 3 of the\nDwarf Codes.\n\n|-68|-27|3|0|1~STR|Eviction can be postponed\nwith a payment of |-67|47|3|0|1~STR|Aelfleda (homeowner),|-53|-42|3|11940402|1~STR|10,560|38|54|3|11940402|1~STR|Cuchu-Bucks.|-67|62|3|0|1");
	## Pravda Tir na nOg
	add_note( 14, "Pravda Tír na nÓg", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|14~STR|Yesterday's News for the forward-thinking dwarf.|-131|-89|3|0|1~STR|Find us online.|-146|-43|3|0|1~STR|YEAR: 666X, Day:|70|-42|3|0|1~STR|TIR NA NOG, N7 – The stage  is  set\nat  the  Governor's  Mansion  as\ncowering  dwarfs  welcome  the  Tir\nna nOg Governor Decree, Elagabalus.\nGovernor Elagabalus, our fair city's\nseventh, who  served with distinction\nas the Mountain Hoosegow Operational\nWarden, claims  he /'watches  city\nbudgets  like [he] monitors jailbirds\nrotting in their cells”, adding he's\nalso proud to /'bleeds blue for\nCuchulainn./' Polls witch show men,\nwomen and pets find his policies\nterrifying on a fundamental level\nare expected to be quelled in time\nfor the inauguration.|-143|-13|3|0|1~STR|THE GUBERNATORIAL IRON FIST|-143|-32|1|0|1");
	add_note( 14, "Decoded Pravda", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|14~STR|Yesterday's News for the forward-thinking dwarf.|-131|-89|3|0|1~STR|Find us online.|-146|-43|3|0|1~STR|YEAR: 666X, Day:|70|-42|3|0|1~STR|TIR NA NOG, N7 – The stage  is  set\nat  the  Governor's  Mansion  as\ncowering  dwarfs  welcome  the  Tir\nna nOg Governor Decree, Elagabalus.\nGovernor Elagabalus, our fair city's\nseventh,      served with distinction\nas the Mountain Hoosegow Operational\nWarden, claims  he /'         city\nbudgets  like [he] monitors jailbirds\nrotting in their cells”, adding he's\nalso proud to /'bleeds      for\nCuchulainn./' Polls witch show    ,\nwomen and pets find his policies\nterrifying on a fundamental level\nare expected to be quelled in time\nfor the inauguration.|-144|-13|3|0|1~STR|THE GUBERNATORIAL IRON FIST|-143|-32|1|0|1~STR|who|-91|20|4|254|1~STR|watches|-22|34|2|509|1~STR|blue|-13|55|2|254|1~STR|Men|18|62|2|509|1");
	##MAPS
	add_note( 16, "Sewers, Floor One", "sn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|16");
	add_note( 17, "Sewers, Floor Two", "sn_mnu_noteFlipMedium01", "BAK|s_tnn_papers|17");
	##Operation: Reverse Dunkirk
	add_note( 18, "Sealed Secret Dossier", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|18");
	add_note( 19, "Resealed Secret Dossier", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|19");
	add_note( 20, "Re-resealed Secret Dossier", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|20");
	add_note( 21, "Re-re-resealed Secret Dossier", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|21");
	add_note( 22, "Cuchu Cashier's Cheque", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|22");

	## Forged Document for Melqart    
	add_note( 19, "Forged Document", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|0~STR|The Duergar know as Melqart\nis hereby ordered to report\nback to the hoosegow and await\nfor further instructions.|-74|-75|8|6021631|1~STR|The Duergar in possession of this\ndocument shall take over the duties\nof the Duergar Melqart until\nfurther notice. The orders detailed\nin this document are to be\ncarried out immediately.\n\nFailing to follow these orders is\npunishable by death and torture.|-78|-19|8|5955838|1~STR|- Warden|16|89|9|130816|1");
	##Gaming Klatch
	add_note( 10, "Printed Invitation", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|10~STR|Wrist-CONP\n\n   2054|-53|-72|5|0|1~STR|PRESENT THIS AT\nTHE GAMERS DOOR\nAT 12:00 TODAY\nBRING WITH YOU\nNOONE\n\nIN YOUR WILDEST\nGAMER DREAMS YOU\nCAN NOT IMAGINE\nTHE DANKNESS OF\nTHE SURPRISES\nTHAT AWAIT YOU|-84|-21|5|0|1");
	add_note( 10, "D'archimedes Invitation", "sn_mnu_noteFlipLight01", "BAK|s_tnn_papers|10~STR|Wrist-CONP\n\n   2054|-53|-72|5|0|1~STR|PRESENT THIS AT\nTHE GAMERS DOOR\nAT 12:00 TODAY\nBRING WITH YOU\nNOONE\n\nIN YOUR WILDEST\nGAMER DREAMS YOU\nCAN NOT IMAGINE\nTHE DANKNESS OF\nTHE SURPRISES\nTHAT AWAIT YOU|-84|-21|5|0|1");

	## Pocahontas' letter to Don Diego ##
	add_note( 23, "Pocahontas' Letter", "sn_mnu_noteFlipHeavy01", "BAK|s_tnn_papers|23");

	## PEOPLE YOU CAN GIVE NOTES TO, USE THEIR NAME TO INVOKE THEM WITH Note("select", characters name")
	add_person( "Timelord", "TIMELORD NOTE", event_placeholder);
	add_person( "Milagros", "Hand Over What Scoop...?", event_placeholder);
	add_person( "Gelasio", "Got any clues?", event_placeholder);
	add_person( "Sviatoslav", "Any cyphers in your pocket?", event_placeholder);
	add_person( "Cuthbert Resume", "What should I submit...?", event_placeholder);
	add_person( "Cuthbert Cover", "What should I submit...?", event_placeholder);
	add_person( "Absalom", "Turn In What Intel...?", event_placeholder);
	add_person( "Vikingstad", "Give Which Paperwork...?", event_placeholder);
	add_person( "Dying Dwarf", "A piece of paper for him?", event_placeholder);
	add_person( "Melqart", "Duergar document for Melqart...?", event_placeholder);
	add_person( "Terlet", "You're gonna need to use something.", event_placeholder);
	add_person( "Cpl. Lafayette", "Operation: Reverse Dunkirk- what was it again?", event_placeholder);
	add_person( "Cherlindria", "She probably only wants the Dossier.", event_placeholder);
	add_person( "Slag", "Slag knows what to do... do you?", event_placeholder);
	add_person( "Carol", "Carol can help with your notes.", event_placeholder);
	add_person( "Don Diego de la Vega", "Letter designated to Don Diego de la Vega...", event_placeholder);
				
	## ART GALLERY - add_art( subimage, name, description)
	add_art( 0, "Goofster", "Goofsters are tall and slender creatures most well known for their supernatural hardy constitution. ##While Goofsters are considered to be benevolent, social creatures, they are rarely, if ever, seen among their kin. Instead they prefer the company of sentient mallards and rats. ##Goofsters live and thrive in ancient subterranean ruins but are highly susceptible to microwave tunnels.");
	add_art( 1, "Slender Man", "Slender Men are the cursed offspring of a forgotten Mesopotamian King. They are born without a face and as such are forever plagued by an unsatiable hunger. ##The dark magicks that run in their veins makes them immortal, which rather than being a divine blessing only serves to prolong their suffering. These conditions make the Slender Men weak and malnourished, hence their name.");
	add_art( 2, "Drakescorned", "The Drakescorned are a noble subgenus of orc who shun the use of all nunchucks. ##Versed in asceticism, the Drakescorned live in secluded mountain monasteries where they train their minds and bodies to deflect bows and arrows. ##As their name implies, they recieve a -2 penalty to all drake-based skill checks but more than make up for it with high level juggling. ##The Drakescorned are known for their elaborate wicker baskets.");
	add_art( 3, "Sergal", "Sergals are the mystical offspring of highborne elves and werewolves. They are worshipped in many cultures almost exclusively as benevolent deities protecting the realm. ##All Sergals have a pathological fear of ghosts, and they try to avoid ancient ruins and graveyards any way they can.");
	add_art( 4, "Geldrach", "Geldrachs are a very common barnyard animal found on many traditional farms. They are a genetically engineered species that are bred for the sole purpose of being cattle, and on some more rare occasions, for their milk. ##They are easily identifiable by their mixture of black and brown fur.");
	add_art( 5, "Dire Juggler", "Dire Juggler are distant cousins of more well known species, Jugglers. Isolated and imprisoned onto a distant island during the events of The Second Cudgel War the Firstborne Jugglers slowly changed to a more dire existence. ##To this day not much else is known about the Dire Jugglers, but their recent resurgence aligns with the prophecy of the end times.");
	add_art( 6, "Hellmonster", "Hellmonster are considered to be one of the most formidable demons of Hell, and their high position in the demon hierarchy supports this viewpoint. They use devastating Hell Magicks to battle their foes and have the ability to conjure Illiorchs Infernal Worms without spending any magicpoints. ##Hellmonsters are archenemies with Sporelips and Elder Stardusters.");
	##add_art( 7, "Mujahoudini", "The Mujahoudini are desert dwelling mystics who live solely to entertain people with their crazy stunts and daring feats. ##Not much is known about their day to day existence, but many rumours suggest that the Mujahoudini do not eat, drink or sleep, but rather spend every waking moment honing their art and protecting their oil.");
	## NOTE cool, unused art? try to enable it later.
	
func add_note( note_id : int, note_title : String, note_sfx : String, note_data : String) -> void:
	notes[note_title] = {
			"note_id" 		: note_id,
			#"note_title" 	: note_title,
			"note_sfx" 		: note_sfx,
			"note_data" 	: note_data,
		}
func add_person( person_name : String, person_title : String, person_event ) -> void:
	# NOTE No idea what 'person_event' does
	persons[person_name] = {
		"person_title" : person_title,
		"person_event" : person_event,
	}
func add_art( art_id : int, art_title : String, art_text : String ) -> void:
	arts[art_id] = {
		"art_title" : art_title,
		"art_text" : art_text,
	}

# Return all the notes that the player have.
func get_all() -> Array:
	# an array with the names of all the players maps.
	var my_notes = B2_Config.get_user_save_data("quest.notes", [] )
	
	# Aditional check. during initial load, this value is an dictionary for some reason. This part of the code should "convert" it to an array.
	if my_notes is not Array:
		my_notes = []
	
	if my_notes.is_empty():
		return []
		
	#else: ## WARNING maybe unneed? Just pass the array with the strings.
		#var id_array := [] # an array with all ids.
		#for i in my_notes:
			#id_array.append( notes.find_key(i) )
		#return id_array
		
	return my_notes
		
func clear_notes() -> void:
	B2_Config.set_user_save_data("quest.notes", Array() )
	
func take_note( note_title : String ): # as in, hoopz receives the note
	var my_notes = B2_Config.get_user_save_data("quest.notes")
		
	# Aditional check. during initial load, this value is an dictionary for some reason. This part of the code should "convert" it to an array.
	if my_notes is not Array:
		my_notes = []
			
	if notes.has( note_title ): # check ifg the actual note exists
		if not my_notes.has(note_title): # check if the players has the note
			my_notes.append( note_title )
			B2_Config.set_user_save_data("quest.notes", my_notes)
			return
		
		push_error("WARNING: You are taking a note you already have.")
	else:
		push_error("WARNING: You are taking a note that doesn't exist.")
	
func give_note( note_title : String ): # as in, hoopz gives the note away
	var my_notes = B2_Config.get_user_save_data("quest.notes")
		
	# Aditional check. during initial load, this value is an dictionary for some reason. This part of the code should "convert" it to an array.
	if my_notes is not Array:
		my_notes = []
			
	if notes.has( note_title ): # check ifg the actual note exists
		if my_notes.has(note_title): # check if the players has the note
			my_notes.append( note_title )
			B2_Config.set_user_save_data("quest.notes", my_notes)
			return
		
		push_error("WARNING: You are giving away a note you don't have.")
	else:
		push_error("WARNING: You are giving away a note that doesn't exist.")
