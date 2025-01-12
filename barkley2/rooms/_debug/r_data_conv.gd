extends Node2D

var items := {}

func _ready() -> void:
	## Misc items ##
	def(0, "Lock Pick", "Pick your locks with this handy device.");
	def(0, "Firaga", "Junction to a GF for extra stats.");
	def(0, "Golden Key", "A key fit for a king.");

	##Sewer Items
	def(1, "Fiscian Gut's", "Gut's from an aquatic creature.");
	def(2, "Garlics", "Exquisite veggies (to some...)");
	def(3, "Sewer Butter", "Butter from a barrel. *OFFENSIVE*");
	def(13, "Fishing Pole", "Catch gun'sfish. Pro-am Certified.");
	def(0, "Gorm-Stone", "Mystical stone oozing with holy power.");
	def(0, "Sewer Seed", "Slimy seeds you can plant in dirt.");

	## Lures ##
	def(17, "F-Lure Bayou Goopster", "Disgustingly goopy lure that sucks.");
	def(18, "F-Lure Devil's Drifter", "This lure was forged by Old Scratch himself.");
	def(19, "F-Lure Tiger Tom", "Fierce lure imbued with the soul of a tiger.");
	def(20, "F-Lure Ladybug", "Majestic lure for a majestic fisherman.");
	def(21, "F-Lure Daverdale", "Fossilized remains of the eidolon Daverdale.");
	def(22, "F-Lure Dread Wonthy", "A lure completely without mercy.");

	## TNN
	def(4, "Dragon Lord Gemstone", "The eye of the Fire Drake shines naught as bright.");
	def(5, "WristCONP2000", "Has all the latest gadgets and gizmos.");
	def(6, "Wilmer's Bones", "Soul cannot rest lest these bones are buried.");
	def(7, "Sterile Vial", "Once used by Vampyre Prince Drago.");
	def(8, "Duergar Urine", "Drago wants you to keep it.");
	def(9, "Fruit Basket", "Mangos, Mangosteens, Rambutans, et. al.");
	def(10, "Granny's Medicine", "A granny needs this.");
	def(11, "Bomb", "Military Grade Explosives: C- (passing)");
	def(12, "Bolt Cutters", "Good at cutting bolts and nards.");    

	## The Hooosegow
	def(0, "Pack of Smokes", "Smoking tobacco and feeding midlane causes caner.");
	def(0, "Military Grade M-80", "Let'er rip and pull back a stump.");
	def(0, "Pelekryte's Shiv", "Sharp and shiny, just like a star...");
	def(0, "Suresh's Shiv", "Dirty and rusty, just like garbage...");
	def(0, "Kunigunde's Shiv", "Hip and cool, just like a trend...");

	## SWAMP ##
	def(0, "Card 3", "A mysterious card covered in feces. The text 'Card 3' is printed on it.");

	## Brian City ##
	def(0, "Cuchukeycard", "Property of Cuchulainn. Wants it back.");

	## CC Items
	def(0, "Special Coin", "Lands on it's side when flipped...");
	def(0, "Tuh, Ghost of Grandpa", "A mystical rune.");
	def(0, "Nip'pon, Apparition of Anime", "A mystical rune.");
	def(0, "M'kah, Spirit of Fire", "A mystical rune.");
	def(0, "Olop, Wraith of Riceballs", "A mystical rune.");
	def(0, "Dilly Dong Dong, Kelpie of Corn Cobs", "A mystical rune.");
	def(0, "Xatar, Phantom of Vidcons", "A mystical rune.");
	def(0, "As'hak, Haunt of Dwarfs", "A mystical rune.");
	def(0, "Esh'tek, Specter of Winter", "A mystical rune.");

	## Factory / Power Plant ##
	def(15, "Empty Influence Ovum", "A mystical chicken egg, waiting to be recharged.");
	def(16, "Influence Ovum", "A mystical chicken egg, surging with energy.");

	## Other ##
	def(0, "Senator's Letter", "Letter addressed to Michael Johnson.");
	def(0, "Cyberspear Piece", "Piece of a legendary instrument.");
	def(0, "Busted Ass Tuba", "Legendary Ass Tuba. Too bad it's busted.");

	## Humanators ##
	def(0, "KOSMIChumanator", "Kosmically good humanator.");
	def(0, "BIOhumanator", "Bio-organic humanator.");
	def(0, "CYBERhumanator", "Cyberized humanator.");
	def(0, "MENTALhumanator", "Mindfreaking humanator.");
	def(0, "ZAUBERhumanator", "Zauberical humanator.");

	## Cgremlin Village ##
	def(0, "Youngster Skelly", "Biodegradeable Exoskeleton.");    
	def(0, "Iron Crown of Jackson", "Jackson wore this one.");
	def(0, "Veil of Valanciunas", "The veil is yet to be lifted.");
	def(0, "Blood of Klisp", "100% authentic.");
	def(0, "Scala Iactus", "We have no idea what this is.");
	def(0, "Mandyblue", "Ah, yes, the legendary Mandyblue.");
	def(0, "Crown of Jalapenos", "A crown fit for a king!");
	def(0, "Shroud of Ballin'", "Named after a medical condition.");
	def(0, "Grape-topped Grail", "Beaning utility.");

	## Undefined mess ##   
	def(0, "Zauber Pistol", "Zauber Pistol");

	def(0, "Guppy", "Guppy");
	def(0, "Pike", "Pike");
	def(0, "Carp", "Carp");
	def(0, "Gun", "Gun");
	def(0, "Item", "Item");
	def(0, "Item2", "Item2");
	def(0, "Useless Item", "description");

	def(0, "Camera", "description");
	def(0, "Turkey Feather", "Sacred memento from Zalatar.");
	def(0, "Tribune-Wrapped Item", "description");
	def(0, "Mystery Item", "description");
	def(0, "Derided Item", "description");
	def(0, "Esteemed Item", "description");

	def(0, "d:GLAZEr", "description");
	def(0, "B1 Visitor Badge", "description");
	def(0, "2F Visitor Badge", "description");
	def(0, "3F Visitor Badge", "description");
	def(0, "Tower Keycard", "description");
	def(0, "Guilderberg Keycard", "description");
	def(0, "Bronze Coin", "description");
	def(0, "Silver Coin", "description");
	def(0, "Gold Coin", "description");
	def(0, "Durian Gaz", "description");
	def(0, "LONGINUSFAKEITEM", "description");
	def(0, "Guilderberg Deed", "description");
	def(0, "W Seed", "description");
	def(0, "Dreadfruit", "description");
	def(0, "W Fruit", "description");
	def(0, "Kirin Horn", "description");
	def(0, "Snake Corpse", "description");
	def(0, "Dwarf Skull", "description");
	def(0, "Mandorla", "description");
	def(0, "Alms Bowl", "description");
	def(0, "Purified Alms Bowl", "description");
	def(0, "Harmonious Alms Bowl", "description");
	def(0, "Mystic Alms Bowl", "description");
	def(0, "Ablution Bowl", "description");
	def(0, "Humble Ablution Bowl", "description");
	def(0, "Harmonious Ablution Bowl", "description");
	def(0, "Mystic Ablution Bowl", "description");
	def(0, "Singing Bowl", "description");
	def(0, "Purified Singing Bowl", "description");
	def(0, "Humble Singing Bowl", "description");
	def(0, "Mystic Singing Bowl", "description");
	def(0, "Royal Gem Box", "description");
	def(0, "Magnetic Tape", "description");
	def(0, "Hardtack Small Plates", "description");
	def(0, "Hardtack Entree", "description");
	def(0, "Hardtack Special", "description");
	def(0, "Hardtack 1st Course", "description");
	def(0, "Hardtack 2nd Course", "description");
	def(0, "Hardtack 3rd Course", "description");
	def(0, "Hardtack", "description");
	def(0, "Hemalatha's Bill", "description");
	def(0, "Hemalatha's Receipt", "description");
	def(0, "advent_calendar", "description");
	def(0, "rigged_advent_calendar", "description");
	def(0, "monster_bait", "description");

	## Castle Beach
	##def(0, "Bubkis Family Heirloom", "Butter knife made from Jalapenoglass.");

	## Cyberspear ##
	def(0, "Cyber Tip", "The sharp tip of a mysterious weapon.");
	def(0, "Cyber Wing", "The majestic wing decoration of a mysterious weapon.");
	def(0, "Cyber Handle", "The sturdy handle of a mysterious weapon.");
	def(0, "Cyber Counterweight", "The precise counterweight of a mysterious weapon.");
	def(0, "Cyber Trigger", "The fierce trigger of a mysterious weapon.");    

	def(0, "Lucky Frog Amulet", "Cheap bargain bin trash.");
	def(0, "Adoption Papers", "Proceedings to procure a progeny");

	## The Social / Industrial Park
	def(0, "Chup", "Industrial strength chup. Decimates the glaucomas.");
	def(0, "Train Ticket", "Ticket for a Train.")

	## Ys-Kolob ##
	##def(0, "Letter to Don Diego", "Letter addressed to Don Diego de la Vega.");
	def(0, "Z-Codec", "Mysterious device. Shaped like an eel.");
	def(0, "Duck Organs", "A dullard mallard's innards");
	
	print( items )
	
func def( id, item_name, description):
	if items.has(item_name):
		print("error " + item_name) 
	items[item_name] = { "id" : id, "description" : description }
