extends B2_Environ

const O_SHADOW 						= preload("res://barkley2/scenes/Objects/System/o_shadow.tscn")
const O_ENTITY_INDICATOR_GOSSIP 	= preload("res://barkley2/scenes/Objects/_interactiveActor/_pedestrians/o_entity_indicatorGossip.tscn")

@onready var gossip_detection: Area2D = $gossip_detection
@onready var gossip_timer: Timer = $GossipTimer


var gossip_pool 		:= []
var ped_can_gossip 		:= true
var gossip_area 		:= 0
var my_gossip 			:= 0
var ped_timer 			:= 55.0

func _ready() -> void:
	# Quest vars
	## Not allowed to exist during gov speech or gutter escape ##
	if B2_Playerdata.Quest("govSpeechInitiate") == 2:
		queue_free()
	if B2_Playerdata.Quest("gutterEscape") == 1:
		queue_free()
	## Disable during TNN CURFEW ##
	# Curfew not implemented TODO
	if get_parent() is B2_ROOMS:
		var room : B2_ROOMS = get_parent()
		if B2_Database.time_check("tnnCurfew") == "during" && room.get_room_area() == "tnn": queue_free()
	else:
		push_error("Issue loading Ped.")
		breakpoint
	
	## Disable randomly ##
	if randi_range(0,99) <= 40:
		queue_free()
	
	my_gossip = randi_range(0,9)
	
	change_costume()
	
	gossip_pool.resize( 8 )
	for i in gossip_pool.size():
		gossip_pool[i] = Array()
		gossip_pool[i].resize( 10)
		
	## TNN ##
	gossip_pool[0][0] = "Check out DwarfNET for tips and tricks!";
	gossip_pool[0][1] = "The Swamps are south from here...";
	gossip_pool[0][2] = "The Cyberdwarf? Ask those L.O.N.G.I.N.U.S. guys...";
	gossip_pool[0][3] = "They say a Wise Sage lives deep in the Frigid Inskirts!";
	gossip_pool[0][4] = "Be wary of Duergars...";
	gossip_pool[0][5] = "Remember to floss.";
	gossip_pool[0][6] = "Overusing Zaubers makes you tired.";
	gossip_pool[0][7] = "I'm going to join the Beach Watch!";
	gossip_pool[0][8] = "The second Otherkin War is upon us...";
	gossip_pool[0][9] = "Cuchulainn can suck my d*ck!";

	## Brain City ##
	gossip_pool[1][0] = "I'm proud to be a Braincinian";
	gossip_pool[1][1] = "Where's my son? Have you seen my baby boy?!";
	gossip_pool[1][2] = "I'm a resolute coffee drinker, full of beans";
	gossip_pool[1][3] = "A neurodeck in the head is worth ten in the belfry";
	gossip_pool[1][4] = "Cyberdwarf is a scam, don't believe the hype";
	gossip_pool[1][5] = "The tallest tower holds the deepest secrets";
	gossip_pool[1][6] = "Gilberts Peak eludes me";
	gossip_pool[1][7] = "Fortune favors the bald";
	gossip_pool[1][8] = "Search south of Castle Duffrey";
	gossip_pool[1][9] = "My next upgrade is going to be my tendons";

	## Al-akihabara ##
	gossip_pool[2][0] = "Ugh... I'm so parched...";
	gossip_pool[2][1] = "Water... I need... Water...";
	gossip_pool[2][2] = "Ungh... It's so hot in here...";
	gossip_pool[2][3] = "Please, someone, anyone... Give me nectar!";
	gossip_pool[2][4] = "If only us dwarfs wouldn't need to drink...";
	gossip_pool[2][5] = "Every word pains my parched throat";
	gossip_pool[2][6] = "My sore throat beckons for water...";
	gossip_pool[2][7] = "So thirsty...";
	gossip_pool[2][8] = "Thirst is the real enemy of us dwarfs...";
	gossip_pool[2][9] = "Hattori Temple appears only when the moon is full";

	## Ys-Kolob ## Esperanto ##
	gossip_pool[3][0] = "Ĉiuj gloro al la urbestro de la Manĝtuloj";
	gossip_pool[3][1] = "Bonvenon al Ys-Kolob, amiko";
	gossip_pool[3][2] = "Beware la fantomoj de Kastelo Duffrey";
	gossip_pool[3][3] = "Birdo en la ĉapelo valoras du en la sonorilejo";
	gossip_pool[3][4] = "Mi sentas komploto mortigi ĉiuj Manĝtuloj";
	gossip_pool[3][5] = "Pekoj de la patro neston profunde en la itala";
	gossip_pool[3][6] = "Don de la Vega estas ne kiu li ŝajnas";
	gossip_pool[3][7] = "Se nur sinjoro Passepartout estis ankoraŭ tie...";
	gossip_pool[3][8] = "La fosaĵoj teni kaŝitan trezoron";
	gossip_pool[3][9] = "La knabo faris de betulo... Ĉu li vere mortas?";

	## Triskelion
	for i in 10:
		gossip_pool[4][i] = "I like looking at the water.";

	## Triskelion Bar
	gossip_pool[5][0] = "*BURP*";
	gossip_pool[5][1] = "*SLURP*";
	gossip_pool[5][2] = "*HIC*";
	gossip_pool[5][3] = "*HORK*";
	gossip_pool[5][4] = "*HOOT*";
	gossip_pool[5][5] = "*COUGH*";
	gossip_pool[5][6] = "*HOLLER*";
	gossip_pool[5][7] = "Fuck you!";
	gossip_pool[5][8] = "*MUNCH*";
	gossip_pool[5][9] = "*CRUNCH*";

	## Triskelion ghetto
	gossip_pool[6][0] = "I ain't sayin' anythin'";
	gossip_pool[6][1] = "Please... One more grape...";
	gossip_pool[6][2] = "Do you have a noose I could borrow?";
	gossip_pool[6][3] = "The cock-sucker guards won't let me in the city";
	gossip_pool[6][4] = "I wonder where the ladders go...";
	gossip_pool[6][5] = "...What!";
	gossip_pool[6][6] = "What a load of horse patoot!";
	gossip_pool[6][7] = "They call me Il Pauper.";
	gossip_pool[6][8] = "Greetings, saahib.";
	gossip_pool[6][9] = "I'm afraid of the night.";

	## Industrial Park ##
	gossip_pool[7][0] = "Great POWER is northwest";
	gossip_pool[7][1] = "The dankest of Swamps lie south";
	gossip_pool[7][2] = "Fary's are racist";
	gossip_pool[7][3] = "Stay clear of chups";
	gossip_pool[7][4] = "Respect the rules...";
	gossip_pool[7][5] = "One man's piece of shit is another man's gold";
	gossip_pool[7][6] = "Use anesthetics to capture live enemies";
	gossip_pool[7][7] = "Cybergremlins are BULLSHIT!";
	gossip_pool[7][8] = "Knowledge is power";
	gossip_pool[7][9] = "Sepideh's machine will save us all";
	
func change_costume():
	frame = randi_range(0, sprite_frames.get_frame_count("default") - 1 )

func _on_gossip_detection_body_entered(body: Node2D) -> void:
	if gossip_timer.is_stopped():
		if body is B2_PlayerCombatActor and ped_can_gossip:
			gossip_timer.start( ped_timer / 10.0 ) ## DEBUG
			var gos = O_ENTITY_INDICATOR_GOSSIP.instantiate()
			gos.position.y -= 64.0
			gos.text = gossip_pool[gossip_area][my_gossip]
			add_child( gos, true )
