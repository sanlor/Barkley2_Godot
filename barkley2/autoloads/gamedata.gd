extends Node

# This is a helper autoload that holds some "static data" : like portrait maps.

const PORTRAIT_PATH := "res://barkley2/assets/b2_original/portraits/"

var portrait_map := {
	
}
# check Portrait("db")
var portrait_from_name := {
	"Zane" : "s_port_zane",
	"Zane Brain" : "s_port_zaneBrain",
	"Egg Drone" : "s_port_eggDrone",
	"Mysteriouse Youngster" : "s_port_hoopzDiaper",

	# Hoopz Names
	"Forlorn Youngster" : "s_port_hoopz",
	"Determined Youngster" : "s_port_hoopz",

	# Global
	"Mekhanes" : "s_port_mekhanes",

	# Swamps #
	"Frog Kid" : "s_port_frogkid",
	"King Gatoraid" : "s_port_gatoraid",

	# Mountain Pass Rebels
	"Cpl. Lafayette" : "s_port_lafayette",
	"Cpt. Compson" : "s_port_compson",
	"QM Meinhardt" : "s_port_meinhardt",
	"Lt. Florian" : "s_port_florian",

	# Brain City Proper
	"Govinda" : "s_port_govinda",
	"Dr. Pelekryte" : "s_port_pelekryte",    
	"Frampton" : "s_port_frampton",
	"Cosette" : "s_port_cosette",
	"Heimdal" : "s_port_heimdal",

	#Brain City LONGINUS
	"Chandragupta" : "s_port_chandragupta",
	"Husky Voice" : "s_port_longDoor",
	"Cunning Voice" : "s_port_longDoor",
	"Lft. Wiglaf" : "s_port_wiglaf",
	"Jhodfrey" : "s_port_jhodfrey",
	"Variable" : "s_port_variable",

	#Guilderbergs
	"Gald" : "s_port_guilderGald",
	"Von Miser" : "s_port_guilderVonMiser",
	"Gothbard" : "s_port_guilderGothbard",

	# Bhroom
	"Bhroom" : "s_port_bhroom01",
	"Carol" : "s_port_carol",

	# BodySwap
	"Governor Elagabalus" : "s_port_governor",
	"Matthias" : "s_port_matthias",

	# Global
	"Cyberdwarf" : "s_port_cd",
	"The Cyberdwarf" : "s_port_cd",
	"Slag" : "s_port_slag",
	"Ooze" : "s_port_ooze",
	"Kelpstein" : "s_port_kelpster", 

	# Rebels - TnN
	"Private Madison" : "s_port_madison",
	"Pvt. Madison" : "s_port_madison",
	"Dr. Liu" : "s_port_drliu",

	# Ballers
	"Katsu" : "s_port_katsu",
	"Uschi" : "s_port_uschi",

	# Proboscis Dwarfs #  
	"Biscuit" : "s_port_biscuit",
	"Flinn" : "s_port_flinn",
	"Gloves" : "s_port_gloves",
	"Luigi" : "s_port_luigi",
	"Penny" : "s_port_penny",
	"Pommen" : "s_port_pommen",
	"Rexx" : "s_port_rexx",
	"Scoot" : "s_port_scoot",
	"Bumbbo" : "s_port_bumbbo",

	# TNN
	"Abdul-Gafur" : "s_port_abdulGafur",
	"Absalom" : "s_port_absalom",
	"Aelfleda" : "s_port_aelfleda",
	"Amalberga" : "s_port_hildeburge",
	"Dick Necker" : "s_port_dickNecker",
	"Babalugats" : "s_port_babalugats",
	"Benedict" : "s_port_benedict",
	"Cornrow" : "s_port_cornrow",
	"Cuthbert" : "s_port_cuthbert",
	"Dragline" : "s_port_dragline",
	"Dolvolund" : "s_port_dolvolund",
	"Doris" : "s_port_doris",
	"Dr. Tatijana" : "s_port_tatijana",
	"Dubre" : "s_port_dubre",
	"Dubuque" : "s_port_dubuque",        
	"Egidius" : "s_port_egidius",
	"Emilio" : "s_port_emilio",     
	"Eric" : "s_port_gamer",   
	"Nick Decker" : "s_port_nickDecker",
	"Evander" : "s_port_evander",           
	"Fede" : "s_port_fede",        
	"Gelasio" : "s_port_gelasio",
	"Golmaal" : "s_port_golmaal",
	"Gutterhound" : "s_port_gutterhound",
	"Hildeburge" : "s_port_amalberga",
	"Father Giuseppe" : "s_port_giuseppe",
	"Vicar Giuseppe" : "s_port_giuseppeGarish",
	"Guillaume" : "s_port_guillaume",
	"Jindrich" : "s_port_jindrich",
	"Juicebox" : "s_port_juicebox",        
	"Kalevi" : "s_port_kalevi",    
	"Kelpster" : "s_port_kelpster",           
	"Ludwig" : "s_port_ludwig",
	"Marina" : "s_port_marina",
	"Mortimer" : "s_port_mortimer_norm",
	"Milagros" : "s_port_milagros",       
	"Redfield" : "s_port_redfield",        
	"Sviatoslav" : "s_port_sviatoslav",   
	"Vivian" : "s_port_vivian",
	"Wilcy" : "s_port_wilcy",
	"Wilhelmina" : "s_port_wilhelmina",
	"Wilmer" : "s_port_wilmer",
	"Ghostic Wilm" : "s_port_wilmerGhost",
	"Zhang" : "s_port_zhang",
	"Zola" : "s_port_zola",

	#Booty Bass
	'Stonewall "Booty Daimyo" Jackson' : "s_port_daimyo",
	"The Anime Bulldog" : "s_port_animebulldog",
	"DJ Booty Slayer" : "s_port_bootyslayer",

	#Sewers
	"Dying Dwarf" : "s_port_joadTalk",
	"Turald" : "s_port_turald",
	"Chanticleer" : "s_port_chanticleer",
	"Fallen Gordo" : "s_port_fallengordo",
	"Baldomero" : "s_port_baldomero",
	"Archibald" : "s_port_archibald",

	# Plantation
	"Eten-Lijm" : "s_port_etenLijm",
	"Gruft" : "s_port_gruft",
	"Putty" : "s_port_putty",
	"Stahl" : "s_port_stahl",

	# Wasteland
	"Sepideh" : "s_port_sepideh",    
	"Boris" : "s_port_boris",
	"Clive" : "s_port_clive",
	"Moriarty" : "s_port_moriarty",
	"Kunigunde" : "s_port_kunigunde",
	"Obadiah" : "s_port_obadiah",
	"Deacon Brimble" : "s_port_deaconBrimble",
	"Sister Irmingard" : "s_port_irmingard",
	"Waldo" : "s_port_waldo",
	"Suresh" : "s_port_suresh",
	"Filip" : "s_port_filip",
	"Grieg" : "s_port_grieg",
	"Marshal Masego" : "s_port_masego",
	"The Dark Draker" : "s_port_darkDrakerWIP",

	# Cybergremlins
	"Elder Zenobia" : "s_port_zenobia",
	"Rumi" : "s_port_rumi",

	# Brain City
	"Dinah" : "s_port_dinah",
	"Poly" : "s_port_poly",

	#Oligarchy Online
	"Forlorn Avatar" : "s_port_untamo",
	"Klaaust Mitsugiri" : "s_port_untamo",
	"Nene" : "s_port_nene",
	"MARIO" : "s_port_mario",

	# Quantum Atwoody
	"Doppel Kuwanger" : "s_port_doppel_kuwanger",
	"Running Mantis" : "s_port_running_mantis",
	"Kassler" : "s_port_kassler",

	# Duergars
	"R.F. Archambeau" : "s_port_archambeau",
	"Astyages" : "s_port_astyages",
	"Burglecut" : "s_port_burglecut",
	"Constantine" : "s_port_constantine",
	"Dane-Dufresne" : "s_port_danedufresne",
	"Deveraux" : "s_port_deveraux",
	"Dozier" : "s_port_dozier",
	"Gandalf Junior" : "s_port_gandalfJunior",
	"Garth" : "s_port_garth",
	"Gottler" : "s_port_gottler",
	"Guildenstern" : "s_port_guildenstern",
	"Haile" : "s_port_haile",
	"Hasdrubal" : "s_port_hasdrubal",
	"Honus" : "s_port_honus",
	"Iptehar" : "s_port_iptehar",
	"Janos" : "s_port_janos",
	"Jean-Marc" : "s_port_jeanmarc",
	"Jeltsje" : "s_port_jeltsje",
	"Kim" : "s_port_kim",
	"Lafferty" : "s_port_lafferty",
	"Lucretia" : "s_port_lucretia",
	"Lugner" : "s_port_lugner",
	"Lumis" : "s_port_lumis",
	"Melqart" : "s_port_melqart",
	"Ng" : "s_port_ng",
	"Onslow" : "s_port_onslow",
	"Oolon" : "s_port_oolon",
	"Osiris" : "s_port_osiris",
	"Ox" : "s_port_ox",
	"Perry" : "s_port_perry",
	"Puannum" : "s_port_puannum",
	"Roethlisbuergar" : "s_port_roethlisbuergar",
	"Rosencrantz" : "s_port_rosencrantz",
	"Schatzeder" : "s_port_schatzeder",
	"Socrates" : "s_port_socrates",
	"Thrax" : "s_port_thrax",
	"Typhoid Larry" : "s_port_typhoidlarry",
	"Van Cleef" : "s_port_vancleef",
	"Vikingstad" : "s_port_vikingstad",
	"Wendela" : "s_port_wendela",
	"Yordano" : "s_port_yordano",

	# PDT
	"Benjamin-Hur" : "s_port_benhur",
	"Babby Hubert" : "s_port_babbyhubert",
	"Card Soldier" : "s_port_cardsoldier",
	"Carmilla" : "s_port_carmilla",
	"Cowardly Lion" : "s_port_cowardlylion",
	"Donald Quixote" : "s_port_quixote",
	"Don Diego de la Vega" : "s_port_dondiego",
	"Dracula" : "s_port_dracula",
	"El Zorro" : "s_port_zorro",
	"Fantomas" : "s_port_fantomas",
	"Fritz Katzenjammer" : "s_port_fritzkatzen",
	"Geppetto" : "s_port_geppetto",
	"Hans Katzenjammer" : "s_port_hanskatzen",
	"Nick Carter" : "s_port_nick",    
	"Paulin Birquet" : "s_port_paulin",
	"Phileass Fog" : "s_port_phileass",
	"Pocahontas" : "s_port_pocahontas",
	"Oliver Twist" : "s_port_oliver",
	"Red Kid" : "s_port_redkid",
	"Yellow Kid" : "s_port_yellowkid",
	"Zigomar the Eelskin" : "s_port_zigomar",
	"Zigomar" : "s_port_zigomar",

	# Robinson crew #
	"Jack Robinson" : "s_port_sfr_jack",
	"Nip Robinson" : "s_port_sfr_nip",
	"Emily Jenny Montrose Robinson" : "s_port_sfr_emily",
	"Fangs Robinson" : "s_port_sfr_fangs",
	"Elizabeth Robinson" : "s_port_sfr_elizabeth",
	"Ernest Robinson" : "s_port_sfr_ernest",
	"Franz Robinson" : "s_port_sfr_franz",
	"William Robinson" : "s_port_sfr_william",
	"Yellow Robinson" : "s_port_sfr_yellowkid",
	"Pocahontas Robinson" : "s_port_sfr_pocahontas",

	# Gamer's Tabernacle
	"Crestfallen Gamer" : "s_port_crestfallenGamer",

	# Icefields and Dojo
	"Senpai Stevesamasanchan" : "s_port_stevesamasanchan",
	"Dojo Dad" : "s_port_dojodad",
	"Master Miller" : "s_port_mastermiller",

	# Prisoners
	"Bolthios" : "s_port_bolthios",
	"D'archimedes" : "s_port_darchimedes",
	"Inmate Pelekryte" : "s_port_pelekryteJail",
	"Cherlindria" : "s_port_cherlindria",
	"Inmate Absalom" : "s_port_absalomInmate",
	}

func _ready() -> void:
	_load_portrait_data()

# check Portrait("init")
func _load_portrait_data():
	var time := Time.get_ticks_msec()
	for file : String in DirAccess.get_files_at( PORTRAIT_PATH ):
		if file.find(".import"): ## Godot stuff.
			if file.find("_strip"):
				
				portrait_map[ file.rsplit("_", false, 1)[ 0 ] ] = file.trim_suffix(".import")
	print("_load_portrait_data() - Added " + str( portrait_map.size() ) + " portraits in %s msecs." % str( Time.get_ticks_msec() - time ) )