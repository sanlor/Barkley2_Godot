extends Resource
class_name B2_Gun
## Static data for Guns.
# Check scr_gun_db(), Drop() and Gun()
# Also HUD line 25 for gunsheet shit.
# also scr_combat_weapons_generate for material an gun generation.

## Skills
enum SKILL{NONE,PRECISION_SHOT,FULL_AUTO,BURST_FIRE}
const SKILL_LIST : Dictionary[SKILL,B2_WeaponSkill] = {
	SKILL.NONE 				: null,
	SKILL.PRECISION_SHOT 	: preload("res://barkley2/resources/B2_Weapon/B2_WeaponSkill/precision_shot.tres"),
	SKILL.FULL_AUTO 		: preload("res://barkley2/resources/B2_Weapon/B2_WeaponSkill/full_auto.tres"),
	SKILL.BURST_FIRE 		: preload("res://barkley2/resources/B2_Weapon/B2_WeaponSkill/burst_fire.tres"),
}
const GUNWIDTH 		= 49;
const GUNHEIGHT 	= 24;
const GUNPERSHEET 	= 9; 	## Number of guns to put per sheet. If loading a sheet takes too long, lower this number. ## NOTE Number of gun material per "FrankieGuns" texture
const GUNMATERIALS 	= 81; 	## Maximum number of gun materials in game
const GUNTYPES 		= 26;	## Maximum number of types of guns we'll have

const BANDOLIER_SIZE 	:= 3
const GUNBAG_SIZE 		:= 14

enum TYPE{ ## List of guntypes. check Gun("init")
	GUN_TYPE_PISTOL,
	GUN_TYPE_FLINTLOCK,
	GUN_TYPE_SUBMACHINEGUN,
	GUN_TYPE_REVOLVER,
	GUN_TYPE_MAGNUM,
	GUN_TYPE_FLAREGUN,
	GUN_TYPE_RIFLE,
	GUN_TYPE_MUSKET,
	GUN_TYPE_HUNTINGRIFLE,
	GUN_TYPE_TRANQRIFLE,
	GUN_TYPE_SNIPERRIFLE,
	GUN_TYPE_ASSAULTRIFLE,
	GUN_TYPE_MACHINEPISTOL,
	GUN_TYPE_HEAVYMACHINEGUN,
	GUN_TYPE_GATLINGGUN,
	GUN_TYPE_MINIGUN,
	GUN_TYPE_MITRAILLEUSE,
	GUN_TYPE_SHOTGUN,
	GUN_TYPE_DOUBLESHOTGUN,
	GUN_TYPE_REVOLVERSHOTGUN,
	GUN_TYPE_ELEPHANTGUN,
	GUN_TYPE_CROSSBOW,
	GUN_TYPE_FLAMETHROWER,
	GUN_TYPE_ROCKET,
	GUN_TYPE_BFG,
	## DEBUG
	GUN_TYPE_NONE,
	}
# So here is halfass balance for gun's drops while we wait for Enemy and Area specific drops coming up soon. ## NOTE yeah... soon...
enum MATERIAL{
	## Special
	CANDY,PRINTED,
	## Poor Materials Row 2
	SOILED, ROTTEN, BROKEN, CARBON, MYTHRIL, RUSTY, JUNK, NEON,
	## Weak materials Row 3
	SALT, WOOD, ALUMINUM, GLASS, PLASTIC, LEATHER,
	## Special 2
	STUDDED, DUAL, PLANTAIN,
	## Elemental Materials Row 4
	BONE, ALUMINIUM, TITANIUM, STONE, CHROME, FRANKINCENSE, IRON, COBALT, NICKEL, COPPER, ZINC, FIBERGLASS, GRASS, SOY, STEEL, BRASS,
	## Special 3
	ORICHALCUM, NAPALM, ORIGAMI, OFFAL, CRYSTAL, ADAMANTIUM, SILK, MARBLE, RUBBER, FOIL, BLOOD, SILVER,
	## Testing a super rare 1 in 100 drop of a 5th Row - bhroom 
	CHITIN, SINEW, TIN, OBSIDIAN, FUNGUS,
	## Special 4
	DAMASCUS, ANALOG, DIGITAL, BRAIN, CHOBHAM, BRONZE, BLASTER, TUNGSTEN, ITANO, PEARL, MYRRH, PLATINUM, GOLD, MERCURY, IMAGINARY,
	LEAD, DIAMOND, POLENTA, YGGDRASIL, PINATA, FRANCIUM, ORB, NANOTUBE, TAXIDERMY, PORCELAIN, ANTI_MATTER, AEROGEL, DENIM, UNTAMONIUM,
	## DEBUG
	NONE,
	}
	
## Weapon groups. no idea how its used.
## 22-04-25 I have some idea how its used. It kinda defines how the gun behaves, like a shotgun spreads bullets while an automatic fires directly multiple times.
enum GROUP{ 
	AUTOMATIC,
	MOUNTED,
	PISTOLS,
	PROJECTILE,
	RIFLES,
	SHOTGUNS,
	## DEBUG
	NONE
	}
enum RARITY{
	TRASH,
	MEH,
	RARE,
	GODAM
	}
const RARITY_TYPE := {
	RARITY.TRASH: 	[ TYPE.GUN_TYPE_PISTOL,TYPE.GUN_TYPE_RIFLE,TYPE.GUN_TYPE_HUNTINGRIFLE,TYPE.GUN_TYPE_MACHINEPISTOL,TYPE.GUN_TYPE_SUBMACHINEGUN,TYPE.GUN_TYPE_SHOTGUN,TYPE.GUN_TYPE_MUSKET,TYPE.GUN_TYPE_FLINTLOCK ],
	RARITY.MEH: 	[ TYPE.GUN_TYPE_REVOLVER,TYPE.GUN_TYPE_TRANQRIFLE,TYPE.GUN_TYPE_GATLINGGUN,TYPE.GUN_TYPE_DOUBLESHOTGUN,TYPE.GUN_TYPE_REVOLVERSHOTGUN,TYPE.GUN_TYPE_HEAVYMACHINEGUN,TYPE.GUN_TYPE_MITRAILLEUSE,TYPE.GUN_TYPE_ASSAULTRIFLE,TYPE.GUN_TYPE_CROSSBOW ],
	RARITY.RARE: 	[ TYPE.GUN_TYPE_MINIGUN,TYPE.GUN_TYPE_ELEPHANTGUN,TYPE.GUN_TYPE_MAGNUM,TYPE.GUN_TYPE_SNIPERRIFLE,TYPE.GUN_TYPE_FLAREGUN ]
	}
const RARITY_MATERIAL := {
	RARITY.TRASH: 	[ MATERIAL.SOILED, MATERIAL.ROTTEN, MATERIAL.BROKEN, MATERIAL.CARBON, MATERIAL.MYTHRIL, MATERIAL.RUSTY, MATERIAL.JUNK, MATERIAL.NEON ],
	RARITY.MEH: 	[ MATERIAL.SALT, MATERIAL.WOOD, MATERIAL.ALUMINUM, MATERIAL.GLASS, MATERIAL.PLASTIC, MATERIAL.LEATHER ],
	RARITY.RARE: 	[ MATERIAL.BONE, MATERIAL.ALUMINIUM, MATERIAL.TITANIUM, MATERIAL.CHROME, MATERIAL.IRON, MATERIAL.COBALT, MATERIAL.NICKEL, MATERIAL.COPPER, MATERIAL.ZINC, MATERIAL.GRASS, MATERIAL.BRASS ],
	RARITY.GODAM: 	[ MATERIAL.TIN, MATERIAL.CRYSTAL, MATERIAL.BLOOD, MATERIAL.CHITIN, MATERIAL.SINEW, MATERIAL.OBSIDIAN, MATERIAL.FUNGUS ],
	}

## The "raw" name for each gun, before affixing affixes.
const gun_names := {
	TYPE.GUN_TYPE_ASSAULTRIFLE:			"Assault Rifle",
	TYPE.GUN_TYPE_BFG:					"BFG",
	TYPE.GUN_TYPE_CROSSBOW:				"Crossbow",
	TYPE.GUN_TYPE_DOUBLESHOTGUN:		"Scattergun",
	TYPE.GUN_TYPE_ELEPHANTGUN:			"Elephant Gun",
	TYPE.GUN_TYPE_FLAMETHROWER:			"Flame",
	TYPE.GUN_TYPE_FLAREGUN:				"Flare Gun",
	TYPE.GUN_TYPE_FLINTLOCK:			"Flintlock",
	TYPE.GUN_TYPE_GATLINGGUN:			"Gatling Gun",
	TYPE.GUN_TYPE_HEAVYMACHINEGUN:		"Machinegun",
	TYPE.GUN_TYPE_HUNTINGRIFLE:			"Hunting Rifle",
	TYPE.GUN_TYPE_MACHINEPISTOL:		"Uzi",
	TYPE.GUN_TYPE_MAGNUM:				"Magnum",
	TYPE.GUN_TYPE_MINIGUN:				"Minigun",
	TYPE.GUN_TYPE_MITRAILLEUSE:			"Mitrailleuse",
	TYPE.GUN_TYPE_MUSKET:				"Musket",
	TYPE.GUN_TYPE_PISTOL:				"Pistol",
	TYPE.GUN_TYPE_REVOLVER:				"Revolver",
	TYPE.GUN_TYPE_REVOLVERSHOTGUN:		"Autoshotgun",
	TYPE.GUN_TYPE_RIFLE:				"Rifle",
	TYPE.GUN_TYPE_ROCKET:				"Bazooka",
	TYPE.GUN_TYPE_SHOTGUN:				"Shotgun",
	TYPE.GUN_TYPE_SNIPERRIFLE:			"Sniper",
	TYPE.GUN_TYPE_SUBMACHINEGUN:		"SMG",
	TYPE.GUN_TYPE_TRANQRIFLE:			"Tranquilizer",
}

const gun_db := {
	##             			GD  Ge Bi Cy Me Ko Za Au Mo Pi Pr Ri Sh
	"generic automatic": 	[56, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
	"generic mounted": 		[56, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	"generic pistol": 		[56, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
	"generic projectile": 	[56, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
	"generic rifle": 		[56, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
	"generic shotgun": 		[56, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],

	## Quest guns
	"wilmers gun": 			[56, 3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0],
	"esthers gun": 			[56, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3],
	"bio shotgun": 			[56, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
	"bio rifle": 			[56, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
	"cyber pistol": 		[56, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
	"cyber projectile": 	[56, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0],
	"mental rifle": 		[56, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0],

	## Gun sales
	"kosmic pistol": 		[56, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0],
	"kosmic rifle": 		[56, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
	"kosmic shotgun": 		[56, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
	"kosmic projectile": 	[56, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0],
	"kosmic mounted": 		[56, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0],

	"zauber pistol": 		[64, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
	"zauber rifle": 		[64, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0],
	"zauber shotgun": 		[64, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
	"zauber projectile": 	[64, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
	"zauber mounted": 		[64, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0],

	## Turald      			GD  Ge Bi Cy Me Ko Za Au Mo Pi Pr Ri Sh
	"turald free": 			[56, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1],
	"turald weak": 			[59, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1],
	"turald good":			[64, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1],
	"turald best": 			[69, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],

	## TEST - for cgrem
	"fixed test": 			[56, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],

	## Destructs   			GD  Ge Bi Cy Me Ko Za Au Mo Pi Pr Ri Sh "name"
	"ds_gau_regular": 		[70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], ## Gauntlet - Random Catchall
	"ds_sw1_regular": 		[59, 1, 1, 0, 0, 0, 0, 1, 1, 2, 1, 1, 1], ## Sewers 1 - Bio + Pistol
	"ds_sw2_regular": 		[68, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1], ## Sewers 2 - Bio - Rifle
	"ds_est_regular": 		[83, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 2, 1], ## Easteland - Cyber + Rifle
	"ds_est_cyber": 		[83, 0, 0, 3, 0, 0, 0, 2, 0, 1, 0, 1, 0], ## Easteland - Cyber + Automatic
	"ds_pea_regular": 		[92, 1, 1, 0, 0, 3, 0, 1, 1, 1, 3, 2, 1], ## Mountain Pass - Kosmic + Projectile
	"ds_min_regular": 		[92, 1, 1, 0, 3, 1, 3, 1, 1, 2, 1, 1, 3], ## Mines - Mental + Shotgun
	"ds_swp_regular": 		[101, 1, 1, 0, 0, 0, 3, 1, 1, 1, 1, 1, 2], ## Swamp - Zauber + Shotgun
	"ds_fct_regular": 		[106, 1, 1, 1, 1, 2, 2, 1, 3, 1, 1, 1, 2], ## Factory - Zauber + Mounted
	"ds_usw_regular": 		[113, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], ## Undersewers - RANDOM
	"ds_air_regular": 		[129, 1, 1, 3, 0, 2, 1, 1, 1, 2, 1, 1, 1], ## AI Ruins - Cyber + Pistol
	"ds_wst_regular": 		[137, 0, 1, 0, 0, 0, 1, 0, 1, 1, 2, 1, 1], ## Westeland - Cyber + Rifle
	#"ds_est_cyber": 		[137, 0, 0, 3, 0, 0, 0, 2, 0, 1, 0, 1, 0], ## Westeland - Cyber + Automatic NOTE a duplicate?
	"ds_ice_regular": 		[143, 1, 1, 0, 3, 0, 0, 1, 3, 1, 1, 1, 1], ## Iceland - Mental + Mounted
	"ds_dth_regular": 		[149, 1, 1, 0, 0, 1, 3, 1, 1, 1, 5, 1, 1], ## Death Tower - Zauber + Projectile
	"ds_chu_regular": 		[155, 1, 1, 1, 1, 3, 2, 3, 1, 2, 1, 1, 1], ## Cuchu's Lair - Kosmic + Automatic
	"ds_swp_corpse": 		[180, 1, 1, 1, 1, 3, 2, 3, 1, 2, 1, 1, 1], ## Corpse Blossom
	"ds_gau_maxxx": 		[200, 1, 1, 1, 1, 3, 2, 3, 1, 2, 1, 1, 1], ## Full Max Build

	## Gun in the Stone ## Redfield's Memorial
	"gun stone": 			[69, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
}

## List of affixes. Add modifiers to guns
#region Old data
#const prefix1 : Array[Dictionary] = [
	#{ "description": "Shots fire into random directions. N00bs only.", "gene1": "minus", "gene2": "random", "name": "NoScope360" },
	#{ "description": "Shots avoid enemies.", "gene1": "minus", "gene2": "homing", "name": "Polarized" },
	#{ "description": "Shots return to the shooter.", "gene1": "minus", "gene2": "bounce", "name": "Fetching" },
	#{ "description": "Shots lob into the air.", "gene1": "minus", "gene2": "curved", "name": "Lobbing" },
	#{ "description": "Shots slow down after being fired.", "gene1": "minus", "gene2": "firing", "name": "Pensioner\'s" },
	#{ "description": "Shots fire from behind the braster.", "gene1": "minus", "gene2": "linear", "name": "Afterburner" },
	#{ "description": "Shots fire from around the player.", "gene1": "plus", "gene2": "random", "name": "Magician\'s" },
	#{ "description": "Shots seek the nearest enemy.", "gene1": "plus", "gene2": "homing", "name": "Gravitational" },
	#{ "description": "Shots ricochet off solid surfaces.", "gene1": "plus", "gene2": "bounce", "name": "Ricocheting" },
	#{ "description": "Shots move in a wave pattern.", "gene1": "plus", "gene2": "curved", "name": "Surfing" },
	#{ "description": "Gun\'s fires multiple, wasteful shots at once.", "gene1": "plus", "gene2": "firing", "name": "Flooding" },
	#{ "description": "Shots pierce through enemies.", "gene1": "plus", "gene2": "linear", "name": "Ghostic" },
	#{ "description": "Shots are out of control.", "gene1": "pound", "gene2": "random", "name": "Goofed" },
	#{ "description": "Shots fire towards nearest enemy.", "gene1": "pound", "gene2": "homing", "name": "Proximity" },
	#{ "description": "Shots chain to multiple enemies.", "gene1": "pound", "gene2": "bounce", "name": "Chaining" },
	#{ "description": "Shots circle around the braster.", "gene1": "pound", "gene2": "curved", "name": "Orbiting" },
	#{ "description": "Gun\'s has anger issues.", "gene1": "pound", "gene2": "firing", "name": "Berzerk\'d" },
	#{ "description": "Shots turn periodically.", "gene1": "pound", "gene2": "linear", "name": "Dotline" },
	#]
#const prefix2 : Array[Dictionary] = [
	#{ "action": null, "description": "hp", "gene1": "top", "gene2": "cosmic", "name": "Pachinkode\'d" },
	#{ "action": null, "description": "hp", "gene1": "top", "gene2": "mental", "name": "Klisp\'d" },
	#{ "action": null, "description": "hp", "gene1": "top", "gene2": "bio", "name": "Juice\'d" },
	#{ "action": null, "description": "hp", "gene1": "top", "gene2": "cyber", "name": "Parkour\'d" },
	#{ "action": null, "description": "hp", "gene1": "top", "gene2": "zauber", "name": "Impose\'d" },
	#{ "action": null, "description": "hp", "gene1": "charm", "gene2": "cosmic", "name": "Gambling" },
	#{ "action": null, "description": "hp", "gene1": "charm", "gene2": "mental", "name": "Agonizing" },
	#{ "action": null, "description": "hp", "gene1": "charm", "gene2": "bio", "name": "Thorny" },
	#{ "action": null, "description": "hp", "gene1": "charm", "gene2": "cyber", "name": "Deathbound" },
	#{ "action": null, "description": "hp", "gene1": "charm", "gene2": "zauber", "name": "Radiating" },
	#{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "cosmic", "name": "Galactic" },
	#{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "mental", "name": "Migraining" },
	#{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "bio", "name": "Gooping" },
	#{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "cyber", "name": "Overloading" },
	#{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "zauber", "name": "Zaubering" },
	#{ "action": null, "description": "capability", "gene1": "top", "gene2": "cosmic", "name": "KosmicBoost" },
	#{ "action": null, "description": "capability", "gene1": "top", "gene2": "mental", "name": "MentalBoost" },
	#{ "action": null, "description": "capability", "gene1": "top", "gene2": "bio", "name": "BioBoost" },
	#{ "action": null, "description": "capability", "gene1": "top", "gene2": "cyber", "name": "CyberBoost" },
	#{ "action": null, "description": "capability", "gene1": "top", "gene2": "zauber", "name": "ZauberBoost" },
	#{ "action": null, "description": "capability", "gene1": "charm", "gene2": "cosmic", "name": "ResistRespec" },
	#{ "action": null, "description": "capability", "gene1": "charm", "gene2": "mental", "name": "ResistLower" },
	#{ "action": null, "description": "capability", "gene1": "charm", "gene2": "bio", "name": "Milkdrop" },
	#{ "action": null, "description": "capability", "gene1": "charm", "gene2": "cyber", "name": "ResistSwap" },
	#{ "action": null, "description": "capability", "gene1": "charm", "gene2": "zauber", "name": "ResistEqual" },
	#{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "cosmic", "name": "KosmicFallen" },
	#{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "mental", "name": "MentalFallen" },
	#{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "bio", "name": "BioFallen" },
	#{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "cyber", "name": "CyberFallen" },
	#{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "zauber", "name": "ZauberFallen" },
	#{ "action": null, "description": "properties", "gene1": "top", "gene2": "cosmic", "name": "LuckBoost" },
	#{ "action": null, "description": "properties", "gene1": "top", "gene2": "mental", "name": "PietyBoost" },
	#{ "action": null, "description": "properties", "gene1": "top", "gene2": "bio", "name": "MightBoost" },
	#{ "action": null, "description": "properties", "gene1": "top", "gene2": "cyber", "name": "AcroBoost" },
	#{ "action": null, "description": "properties", "gene1": "top", "gene2": "zauber", "name": "GutsBoost" },
	#{ "action": null, "description": "properties", "gene1": "charm", "gene2": "cosmic", "name": "Respeccing" },
	#{ "action": null, "description": "properties", "gene1": "charm", "gene2": "mental", "name": "Withering" },
	#{ "action": null, "description": "properties", "gene1": "charm", "gene2": "bio", "name": "Dyslexic" },
	#{ "action": null, "description": "properties", "gene1": "charm", "gene2": "cyber", "name": "Hotswapping" },
	#{ "action": null, "description": "properties", "gene1": "charm", "gene2": "zauber", "name": "Equalizing" },
	#{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "cosmic", "name": "LuckFallen" },
	#{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "mental", "name": "PietyFallen" },
	#{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "bio", "name": "MightFallen" },
	#{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "cyber", "name": "AcroFallen" },
	#{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "zauber", "name": "GutsFallen" },
	#{ "action": null, "description": "weight", "gene1": "top", "gene2": "cosmic", "name": "WeightLower" },
	#{ "action": null, "description": "weight", "gene1": "top", "gene2": "mental", "name": "BrainGain" },
	#{ "action": null, "description": "weight", "gene1": "top", "gene2": "bio", "name": "DefenseGain" },
	#{ "action": null, "description": "weight", "gene1": "top", "gene2": "cyber", "name": "KnockGain" },
	#{ "action": null, "description": "weight", "gene1": "top", "gene2": "zauber", "name": "StaggerGain" },
	#{ "action": null, "description": "weight", "gene1": "charm", "gene2": "cosmic", "name": "Pilfering" },
	#{ "action": null, "description": "weight", "gene1": "charm", "gene2": "mental", "name": "Adhesive" },
	#{ "action": null, "description": "weight", "gene1": "charm", "gene2": "bio", "name": "Smelting" },
	#{ "action": null, "description": "weight", "gene1": "charm", "gene2": "cyber", "name": "Busting" },
	#{ "action": null, "description": "weight", "gene1": "charm", "gene2": "zauber", "name": "Blinking" },
	#{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "cosmic", "name": "Heavy" },
	#{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "mental", "name": "Foggy" },
	#{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "bio", "name": "Risky" },
	#{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "cyber", "name": "Slippery" },
	#{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "zauber", "name": "Goofy" },
	#]
#const suffix : Array[Dictionary] = [
	#{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "bio", "name": "of the Dracula" },
	#{ "action": null, "description": "passive", "gene1": "down", "gene2": "bio", "name": "of the Healthy Youth" },
	#{ "action": null, "description": "reactive", "gene1": "down", "gene2": "bio", "name": "of Flicker" },
	#{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "cosmic", "name": "of the Circus" },
	#{ "action": null, "description": "passive", "gene1": "down", "gene2": "cosmic", "name": "of the Dying Youth" },
	#{ "action": null, "description": "reactive", "gene1": "down", "gene2": "cosmic", "name": "of the Bad Aim" },
	#{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "cyber", "name": "of the Clock" },
	#{ "action": null, "description": "passive", "gene1": "down", "gene2": "cyber", "name": "of the Today\'s Youth" },
	#{ "action": null, "description": "reactive", "gene1": "down", "gene2": "cyber", "name": "of the Paintball" },
	#{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "mental", "name": "of Muramasa" },
	#{ "action": null, "description": "passive", "gene1": "down", "gene2": "mental", "name": "of Masamune" },
	#{ "action": null, "description": "reactive", "gene1": "down", "gene2": "mental", "name": "of Murasame" },
	#{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "zauber", "name": "cursed by a Wicca Hex" },
	#{ "action": null, "description": "passive", "gene1": "down", "gene2": "zauber", "name": "of the Lich" },
	#{ "action": null, "description": "reactive", "gene1": "down", "gene2": "zauber", "name": "of the Elements" },
	#{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "bio", "name": "of Leper\'s Digest" },
	#{ "action": null, "description": "passive", "gene1": "strange", "gene2": "bio", "name": "of Chaining" },
	#{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "bio", "name": "of the Bazinga" },
	#{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "cosmic", "name": "of Jeeper\'s Digest" },
	#{ "action": null, "description": "passive", "gene1": "strange", "gene2": "cosmic", "name": "of Dotlining" },
	#{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "cosmic", "name": "of Sacrifice" },
	#{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "cyber", "name": "with Nanomachines" },
	#{ "action": null, "description": "passive", "gene1": "strange", "gene2": "cyber", "name": "of Ghosting" },
	#{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "cyber", "name": "of Lets Play" },
	#{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "mental", "name": "with a Battery Charger" },
	#{ "action": null, "description": "passive", "gene1": "strange", "gene2": "mental", "name": "of Magicing" },
	#{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "mental", "name": "of the Pacifist" },
	#{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "zauber", "name": "of Reaper\'s Digest" },
	#{ "action": null, "description": "passive", "gene1": "strange", "gene2": "zauber", "name": "of Surfing" },
	#{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "zauber", "name": "of Triskelion" },
	#{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "bio", "name": "of the Entlord" },
	#{ "action": null, "description": "passive", "gene1": "up", "gene2": "bio", "name": "of the Iceman" },
	#{ "action": null, "description": "reactive", "gene1": "up", "gene2": "bio", "name": "with a hole in the Pocket" },
	#{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "cosmic", "name": "of the Quasar" },
	#{ "action": null, "description": "passive", "gene1": "up", "gene2": "cosmic", "name": "of the Perfectionist" },
	#{ "action": null, "description": "reactive", "gene1": "up", "gene2": "cosmic", "name": "of Eternity" },
	#{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "cyber", "name": "of the Doxxer" },
	#{ "action": null, "description": "passive", "gene1": "up", "gene2": "cyber", "name": "of the Metallic Muscle" },
	#{ "action": null, "description": "reactive", "gene1": "up", "gene2": "cyber", "name": "of the Planet of Vapes" },
	#{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "mental", "name": "of the Encephalon" },
	#{ "action": null, "description": "passive", "gene1": "up", "gene2": "mental", "name": "from Heck" },
	#{ "action": null, "description": "reactive", "gene1": "up", "gene2": "mental", "name": "of Deep Welling" },
	#{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "zauber", "name": "of the Ps. Pocus" },
	#{ "action": null, "description": "passive", "gene1": "up", "gene2": "zauber", "name": "of the Becker" },
	#{ "action": null, "description": "reactive", "gene1": "up", "gene2": "zauber", "name": "of the Forever Man" },
	#{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "cyber", "name": "of the Doxxer" },
	#{ "action": null, "description": "passive", "gene1": "up", "gene2": "cyber", "name": "of Perpetual War" },
	#{ "action": null, "description": "reactive", "gene1": "up", "gene2": "cyber", "name": "of Caltropix" },
	#{ "action": null, "description": "passive", "gene1": "up", "gene2": "mental", "name": "with a hole in the pocket" },
	#{ "action": null, "description": "reactive", "gene1": "up", "gene2": "mental", "name": "of Fight or Flight" },
	#{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "cyber", "name": "of the Let\'s Plays" },
	#{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "mental", "name": "of Bailing Out" },
	#]
#endregion

const prefix1 : Dictionary = { 
		"empty": ["empty", "empty", ""], 
		"NoScope360": ["minus", "random", "Shots fire into random directions. N00bs only."], 
		"Polarized": ["minus", "homing", "Shots avoid enemies."], 
		"Fetching": ["minus", "bounce", "Shots return to the shooter."], 
		"Lobbing": ["minus", "curved", "Shots lob into the air."], 
		"Pensioner\'s": ["minus", "firing", "Shots slow down after being fired."], 
		"Afterburner": ["minus", "linear", "Shots fire from behind the braster."], 
		"Magician\'s": ["plus", "random", "Shots fire from around the player."], 
		"Gravitational": ["plus", "homing", "Shots seek the nearest enemy."], 
		"Ricocheting": ["plus", "bounce", "Shots ricochet off solid surfaces."], 
		"Surfing": ["plus", "curved", "Shots move in a wave pattern."], 
		"Flooding": ["plus", "firing", "Gun\'s fires multiple, wasteful shots at once."], 
		"Ghostic": ["plus", "linear", "Shots pierce through enemies."], 
		"Goofed": ["pound", "random", "Shots are out of control."], 
		"Proximity": ["pound", "homing", "Shots fire towards nearest enemy."], 
		"Chaining": ["pound", "bounce", "Shots chain to multiple enemies."], 
		"Orbiting": ["pound", "curved", "Shots circle around the braster."], 
		"Berzerk\'d": ["pound", "firing", "Gun\'s has anger issues."], 
		"Dotline": ["pound", "linear", "Shots turn periodically."] 
	}
const prefix2 : Dictionary = { 
		"empty": ["empty", "empty", "empty", "", null], 
		"Pachinkode\'d": ["top", "cosmic", "hp", "Periodic deals LUCK % extra damage.", null], 
		"Klisp\'d": ["top", "mental", "hp", "Periodic deals PIETY % extra damage.", null], 
		"Juice\'d": ["top", "bio", "hp", "Periodic deals MIGHT % extra damage.", null], 
		"Parkour\'d": ["top", "cyber", "hp", "Periodic deals ACRO % extra damage.", null], 
		"Impose\'d": ["top", "zauber", "hp", "Periodic deals GUTS % extra damage.", null], 
		"Gambling": ["charm", "cosmic", "hp", "Periodic deals 0 - 400% KOSMIC instead of normal damage.", null], 
		"Agonizing": ["charm", "mental", "hp", "Periodic inflicts anguish that deals target MENTAL damage while moving.", null], 
		"Thorny": ["charm", "bio", "hp", "Periodic inflicts target with thornball that shoots out damaging BIO thorns.", null], 
		"Deathbound": ["charm", "cyber", "hp", "Periodic deals extra CYBER damage based on how many times you died.", null], 
		"Radiating": ["charm", "zauber", "hp", "Periodic inflicts cloud that deals ZAUBER damage to nearby enemies.", null], 
		"Galactic": ["bottom", "cosmic", "hp", "Periodic deals 150% KOSMIC instead of normal damage.", null], 
		"Migraining": ["bottom", "mental", "hp", "Periodic deals 150% MENTAL instead of normal damage.", null], 
		"Gooping": ["bottom", "bio", "hp", "Periodic deals 150% BIO instead of normal damage.", null], 
		"Overloading": ["bottom", "cyber", "hp", "Periodic deals 150% CYBER instead of normal damage.", null], 
		"Zaubering": ["bottom", "zauber", "hp", "Periodic deals 150% ZAUBER instead of normal damage.", null], 
		"KosmicBoost": ["top", "cosmic", "capability", "Periodic raises target KOSMIC resistence 60%, lowers other resistences 15%.", null], 
		"MentalBoost": ["top", "mental", "capability", "Periodic raises target MENTAL resistence 60%, lowers other resistences 15%.", null], 
		"BioBoost": ["top", "bio", "capability", "Periodic raises target BIO resistence 60%, lowers other resistences 15%.", null], 
		"CyberBoost": ["top", "cyber", "capability", "Periodic raises target CYBER resistence 60%, lowers other resistences 15%.", null], 
		"ZauberBoost": ["top", "zauber", "capability", "Periodic raises target ZAUBER resistence 60%, lowers other resistences 15%.", null], 
		"ResistRespec": ["charm", "cosmic", "capability", "Periodic respecs target resistences randomly.", null], 
		"ResistLower": ["charm", "mental", "capability", "Periodic lowers target resistences by 20%.", null], 
		"Milkdrop": ["charm", "bio", "capability", "Periodic makes target resistences go off the deep end.", null], 
		"ResistSwap": ["charm", "cyber", "capability", "Periodic randomly swaps target resistences.", null], 
		"ResistEqual": ["charm", "zauber", "capability", "Periodic averages target resistences.", null], 
		"KosmicFallen": ["bottom", "cosmic", "capability", "Periodic lowers target KOSMIC resistence by 30%.", null], 
		"MentalFallen": ["bottom", "mental", "capability", "Periodic lowers target MENTAL resistence by 30%.", null], 
		"BioFallen": ["bottom", "bio", "capability", "Periodic lowers target BIO resistence by 30%.", null], 
		"CyberFallen": ["bottom", "cyber", "capability", "Periodic lowers target CYBER resistence by 30%.", null], 
		"ZauberFallen": ["bottom", "zauber", "capability", "Periodic lowers target ZAUBER resistence by 30%.", null], 
		"LuckBoost": ["top", "cosmic", "properties", "Periodic raises LUCK 60%, lowers all other stats 15%.", null], 
		"PietyBoost": ["top", "mental", "properties", "Periodic raises PIETY 60%, lowers all other stats 15%.", null], 
		"MightBoost": ["top", "bio", "properties", "Periodic raises MIGHT 60%, lowers all other stats 15%.", null], 
		"AcroBoost": ["top", "cyber", "properties", "Periodic raises ACRO 60%, lowers all other stats 15%.", null], 
		"GutsBoost": ["top", "zauber", "properties", "Periodic raises GUTS 60%, lowers all other stats 15%.", null], 
		"Respeccing": ["charm", "cosmic", "properties", "Periodic respecs target GLAMP randomly.", null], 
		"Withering": ["charm", "mental", "properties", "Periodic lowers target GLAMP by 20%.", null], 
		"Dyslexic": ["charm", "bio", "properties", "Periodic makes target GLAMP go off the deep end.", null], 
		"Hotswapping": ["charm", "cyber", "properties", "Periodic randomly swaps target GLAMP.", null], 
		"Equalizing": ["charm", "zauber", "properties", "Periodic averages target GLAMP.", null], 
		"LuckFallen": ["bottom", "cosmic", "properties", "Periodic lowers target LUCK by 30%.", null], 
		"PietyFallen": ["bottom", "mental", "properties", "Periodic lowers target PIETY by 30%.", null], 
		"MightFallen": ["bottom", "bio", "properties", "Periodic lowers target MIGHT by 30%.", null], 
		"AcroFallen": ["bottom", "cyber", "properties", "Periodic lowers target ACRO by 30%.", null], 
		"GutsFallen": ["bottom", "zauber", "properties", "Periodic lowers target GUTS by 30%.", null], 
		"WeightLower": ["top", "cosmic", "weight", "Periodic lowers target WEIGHT 50%, lowers DEFENSE 25%.", null],
		"BrainGain": ["top", "mental", "weight", "Periodic raises target BRAIN 100%, lowers DEFENSE 25%.", null], 
		"DefenseGain": ["top", "bio", "weight", "Periodic raises target DEFENSE by 50%, lowers BP by 50%.", null],
		"KnockGain": ["top", "cyber", "weight", "Periodic raises target knockback resistence 200%, WEIGHT 25%.", null], 
		"StaggerGain": ["top", "zauber", "weight", "Periodic raises target stagger resistence 200%, WEIGHT 25%.", null], 
		"Pilfering": ["charm", "cosmic", "weight", "Periodic makes target drop a candy.", null], 
		"Adhesive": ["charm", "mental", "weight", "Periodic makes target immobile for 5-10 seconds.", null], 
		"Smelting": ["charm", "bio", "weight", "Periodic makes target drop ammo.", null], 
		"Busting": ["charm", "cyber", "weight", "Periodic staggers target for 2-5 seconds.", null], 
		"Blinking": ["charm", "zauber", "weight", "Periodic teleports target to nearby location.", null], 
		"Heavy": ["bottom", "cosmic", "weight", "Periodic raises target WEIGHT by 25%.", null], 
		"Foggy": ["bottom", "mental", "weight", "Periodic lowers target BRAIN by 50%.", null], 
		"Risky": ["bottom", "bio", "weight", "Periodic lowers target DEFENSE by 25%.", null], 
		"Slippery": ["bottom", "cyber", "weight", "Periodic lowers target knockback resistence by 100%.", null], 
		"Goofy": ["bottom", "zauber", "weight", "Periodic lowers target stagger resistence by 100%.", null] 
	}
const suffix : Dictionary = { 
		"empty": ["empty", "empty", "empty", "", null], 
		"of the Dracula": ["down", "bio", "aggressive", "Slurp hitpoints from enemy.", null], 
		"of the Healthy Youth": ["down", "bio", "passive", "Bonus damage based on max hitpoints.", null], 
		"of Flicker": ["down", "bio", "reactive", "Bullets have a very short lifespan.", null], 
		"of the Circus": ["down", "cosmic", "aggressive", "Rolling increases Periodic Meter.", null], 
		"of the Dying Youth": ["down", "cosmic", "passive", "Bonus damage based on missing hitpoints.", null], 
		"of the Bad Aim": ["down", "cosmic", "reactive", "Braster\'s aim is terrible.", null], 
		"of the Clock": ["down", "cyber", "aggressive", "Bonus damage based on passage of time.", null], 
		"of the Today\'s Youth": ["down", "cyber", "passive", "Bonus damage based on current hitpoints.", null], 
		"of the Paintball": ["down", "cyber", "reactive", "Adds a splash of paint to shots.", null], 
		"of Muramasa": ["down", "mental", "aggressive", "Target is pulled towards the braster.", null], 
		"of Masamune": ["down", "mental", "passive", "Zero damage, increased knockback strength.", null], 
		"of Murasame": ["down", "mental", "reactive", "Braster and target are thrown about.", null], 
		"cursed by a Wicca Hex": ["down", "zauber", "aggressive", "Periodic Meter is broken.", null], 
		"of the Lich": ["down", "zauber", "passive", "Bonus damage based on total deaths.", null], 
		"of the Elements": ["down", "zauber", "reactive", "Bullets are imbued with elemental powers.", null], 
		"of Leper\'s Digest": ["strange", "bio", "aggressive", "While you have ammo, you lose health.", null], 
		"of Chaining": ["strange", "bio", "passive", "Bullets chain to nearest enemy.", null], 
		"of the Bazinga": ["strange", "bio", "reactive", "Bullets heal target.", null], 
		"of Jeeper\'s Digest": ["strange", "cosmic", "aggressive", "While you have ammo, you gain health.", null], 
		"of Dotlining": ["strange", "cosmic", "passive", "Bullets move in a dotline.", null], 
		"of Sacrifice": ["strange", "cosmic", "reactive", "Shoot out your own lifeforce.", null], 
		"with Nanomachines": ["strange", "cyber", "aggressive", "Regain up to 20% of ammo.", null], 
		"of Ghosting": ["strange", "cyber", "passive", "Bullets pierce through targets.", null], 
		"of Lets Play": ["strange", "cyber", "reactive", "Remember to like and subscribe.", null], 
		"with a Battery Charger": ["strange", "mental", "aggressive", "Damage based on remaining ammo.", null], 
		"of Magicing": ["strange", "mental", "passive", "Bullets spawn from around the braster.", null], 
		"of the Pacifist": ["strange", "mental", "reactive", "Bullets don\'t deal damage.", null], 
		"of Reaper\'s Digest": ["strange", "zauber", "aggressive", "While you have ammo, everyone is immortal.", null], 
		"of Surfing": ["strange", "zauber", "passive", "Bullets move in a wave pattern.", null], 
		"of Triskelion": ["strange", "zauber", "reactive", "Deals 9999 damage while in Triskelion.", null], 
		"of the Entlord": ["up", "bio", "aggressive", "Bonus BIO damage.", null], 
		"of the Iceman": ["up", "bio", "passive", "Bonus damage based on enemies defeated.", null], 
		"with a hole in the Pocket": ["up", "bio", "reactive", "Ammo depletes constantly.", null], 
		"of the Quasar": ["up", "cosmic", "aggressive", "Bonus KOSMIC damage.", null], 
		"of the Perfectionist": ["up", "cosmic", "passive", "Bonus damage when at full health.", null], 
		"of Eternity": ["up", "cosmic", "reactive", "Bullet have increased lifespans.", null], 
		"of the Doxxer": ["up", "cyber", "aggressive", "Bonus CYBER damage.", null], 
		"of the Metallic Muscle": ["up", "cyber", "passive", "Bonus damage based on Transhumanism.", null], 
		"of the Planet of Vapes": ["up", "cyber", "reactive", "Guns are of the Planet of the Vapes.", null], 
		"of the Encephalon": ["up", "mental", "aggressive", "Bonus MENTAL damage.", null], 
		"from Heck": ["up", "mental", "passive", "Damage varies from 0x to 2.5x.", null], 
		"of Deep Welling": ["up", "mental", "reactive", "Periodic Meter increases constantly.", null], 
		"of the Ps. Pocus": ["up", "zauber", "aggressive", "Bonus ZAUBER damage.", null], 
		"of the Becker": ["up", "zauber", "passive", "Damn slow, but damn hard-hitter!", null], 
		"of the Forever Man": ["up", "zauber", "reactive", "Gun\'s sacrifices itself to save braster.", null] 
	}


## List of B2_WeaponMaterial resources.
const MATERIAL_LIST : Dictionary[MATERIAL, B2_WeaponMaterial] = {
	MATERIAL.PRINTED : 			preload("res://barkley2/resources/B2_Weapon/material/3D Printed.tres"),
	MATERIAL.ADAMANTIUM : 		preload("res://barkley2/resources/B2_Weapon/material/Adamantium.tres"),
	MATERIAL.AEROGEL : 			preload("res://barkley2/resources/B2_Weapon/material/Aerogel.tres"),
	MATERIAL.ALUMINIUM : 		preload("res://barkley2/resources/B2_Weapon/material/Aluminium.tres"), ## Lol, just noticed this. 
	MATERIAL.ALUMINUM : 		preload("res://barkley2/resources/B2_Weapon/material/Aluminum.tres"),
	MATERIAL.ANALOG : 			preload("res://barkley2/resources/B2_Weapon/material/Analog.tres"),
	MATERIAL.ANTI_MATTER : 		preload("res://barkley2/resources/B2_Weapon/material/Anti-Matter.tres"),
	MATERIAL.BLASTER : 			preload("res://barkley2/resources/B2_Weapon/material/Blaster.tres"),
	MATERIAL.BLOOD : 			preload("res://barkley2/resources/B2_Weapon/material/Blood.tres"),
	MATERIAL.BONE : 			preload("res://barkley2/resources/B2_Weapon/material/Bone.tres"),
	MATERIAL.BRAIN : 			preload("res://barkley2/resources/B2_Weapon/material/Brain.tres"),
	MATERIAL.BRASS : 			preload("res://barkley2/resources/B2_Weapon/material/Brass.tres"),
	MATERIAL.BROKEN : 			preload("res://barkley2/resources/B2_Weapon/material/Broken.tres"),
	MATERIAL.BRONZE : 			preload("res://barkley2/resources/B2_Weapon/material/Bronze.tres"),
	MATERIAL.CANDY : 			preload("res://barkley2/resources/B2_Weapon/material/Candy.tres"),
	MATERIAL.CARBON : 			preload("res://barkley2/resources/B2_Weapon/material/Carbon.tres"),
	MATERIAL.CHITIN : 			preload("res://barkley2/resources/B2_Weapon/material/Chitin.tres"),
	MATERIAL.CHOBHAM : 			preload("res://barkley2/resources/B2_Weapon/material/Chobham.tres"),
	MATERIAL.CHROME : 			preload("res://barkley2/resources/B2_Weapon/material/Chrome.tres"),
	MATERIAL.COBALT : 			preload("res://barkley2/resources/B2_Weapon/material/Cobalt.tres"),
	MATERIAL.COPPER : 			preload("res://barkley2/resources/B2_Weapon/material/Copper.tres"),
	MATERIAL.CRYSTAL : 			preload("res://barkley2/resources/B2_Weapon/material/Crystal.tres"),
	MATERIAL.DAMASCUS : 		preload("res://barkley2/resources/B2_Weapon/material/Damascus.tres"),
	MATERIAL.DENIM : 			preload("res://barkley2/resources/B2_Weapon/material/Denim.tres"),
	MATERIAL.DIAMOND : 			preload("res://barkley2/resources/B2_Weapon/material/Diamond.tres"),
	MATERIAL.DIGITAL : 			preload("res://barkley2/resources/B2_Weapon/material/Digital.tres"),
	MATERIAL.DUAL : 			preload("res://barkley2/resources/B2_Weapon/material/Dual.tres"),
	MATERIAL.FIBERGLASS : 		preload("res://barkley2/resources/B2_Weapon/material/Fiberglass.tres"),
	MATERIAL.FOIL : 			preload("res://barkley2/resources/B2_Weapon/material/Foil.tres"),
	MATERIAL.FRANCIUM : 		preload("res://barkley2/resources/B2_Weapon/material/Francium.tres"),
	MATERIAL.FRANKINCENSE : 	preload("res://barkley2/resources/B2_Weapon/material/Frankincense.tres"),
	MATERIAL.FUNGUS : 			preload("res://barkley2/resources/B2_Weapon/material/Fungus.tres"),
	MATERIAL.GLASS : 			preload("res://barkley2/resources/B2_Weapon/material/Glass.tres"),
	MATERIAL.GOLD : 			preload("res://barkley2/resources/B2_Weapon/material/Gold.tres"),
	MATERIAL.GRASS : 			preload("res://barkley2/resources/B2_Weapon/material/Grass.tres"),
	MATERIAL.IMAGINARY : 		preload("res://barkley2/resources/B2_Weapon/material/Imaginary.tres"),
	MATERIAL.IRON : 			preload("res://barkley2/resources/B2_Weapon/material/Iron.tres"),
	MATERIAL.ITANO : 			preload("res://barkley2/resources/B2_Weapon/material/Itano.tres"),
	MATERIAL.JUNK : 			preload("res://barkley2/resources/B2_Weapon/material/Junk.tres"),
	MATERIAL.LEAD : 			preload("res://barkley2/resources/B2_Weapon/material/Lead.tres"),
	MATERIAL.LEATHER : 			preload("res://barkley2/resources/B2_Weapon/material/Leather.tres"),
	MATERIAL.MARBLE : 			preload("res://barkley2/resources/B2_Weapon/material/Marble.tres"),
	MATERIAL.MERCURY : 			preload("res://barkley2/resources/B2_Weapon/material/Mercury.tres"),
	MATERIAL.MYRRH : 			preload("res://barkley2/resources/B2_Weapon/material/Myrrh.tres"),
	MATERIAL.MYTHRIL : 			preload("res://barkley2/resources/B2_Weapon/material/Mythril.tres"),
	MATERIAL.NANOTUBE : 		preload("res://barkley2/resources/B2_Weapon/material/Nanotube.tres"),
	MATERIAL.NAPALM : 			preload("res://barkley2/resources/B2_Weapon/material/Napalm.tres"),
	MATERIAL.NEON : 			preload("res://barkley2/resources/B2_Weapon/material/Neon.tres"),
	MATERIAL.NICKEL : 			preload("res://barkley2/resources/B2_Weapon/material/Nickel.tres"),
	MATERIAL.OBSIDIAN : 		preload("res://barkley2/resources/B2_Weapon/material/Obsidian.tres"),
	MATERIAL.OFFAL : 			preload("res://barkley2/resources/B2_Weapon/material/Offal.tres"),
	MATERIAL.ORB : 				preload("res://barkley2/resources/B2_Weapon/material/Orb.tres"),
	MATERIAL.ORICHALCUM : 		preload("res://barkley2/resources/B2_Weapon/material/Orichalcum.tres"),
	MATERIAL.ORIGAMI : 			preload("res://barkley2/resources/B2_Weapon/material/Origami.tres"),
	MATERIAL.PEARL : 			preload("res://barkley2/resources/B2_Weapon/material/Pearl.tres"),
	MATERIAL.PINATA : 			preload("res://barkley2/resources/B2_Weapon/material/Pinata.tres"),
	MATERIAL.PLANTAIN : 		preload("res://barkley2/resources/B2_Weapon/material/Plantain.tres"),
	MATERIAL.PLASTIC : 			preload("res://barkley2/resources/B2_Weapon/material/Plastic.tres"),
	MATERIAL.PLATINUM : 		preload("res://barkley2/resources/B2_Weapon/material/Platinum.tres"),
	MATERIAL.POLENTA : 			preload("res://barkley2/resources/B2_Weapon/material/Polenta.tres"),
	MATERIAL.PORCELAIN : 		preload("res://barkley2/resources/B2_Weapon/material/Porcelain.tres"),
	MATERIAL.ROTTEN : 			preload("res://barkley2/resources/B2_Weapon/material/Rotten.tres"),
	MATERIAL.RUBBER : 			preload("res://barkley2/resources/B2_Weapon/material/Rubber.tres"),
	MATERIAL.RUSTY : 			preload("res://barkley2/resources/B2_Weapon/material/Rusty.tres"),
	MATERIAL.SALT : 			preload("res://barkley2/resources/B2_Weapon/material/Salt.tres"),
	MATERIAL.SILK : 			preload("res://barkley2/resources/B2_Weapon/material/Silk.tres"),
	MATERIAL.SILVER : 			preload("res://barkley2/resources/B2_Weapon/material/Silver.tres"),
	MATERIAL.SINEW : 			preload("res://barkley2/resources/B2_Weapon/material/Sinew.tres"),
	MATERIAL.SOILED : 			preload("res://barkley2/resources/B2_Weapon/material/Soiled.tres"),
	MATERIAL.SOY : 				preload("res://barkley2/resources/B2_Weapon/material/Soy.tres"),
	MATERIAL.STEEL : 			preload("res://barkley2/resources/B2_Weapon/material/Steel.tres"),
	MATERIAL.STONE : 			preload("res://barkley2/resources/B2_Weapon/material/Stone.tres"),
	MATERIAL.STUDDED : 			preload("res://barkley2/resources/B2_Weapon/material/Studded.tres"),
	MATERIAL.TAXIDERMY : 		preload("res://barkley2/resources/B2_Weapon/material/Taxidermy.tres"),
	MATERIAL.TIN : 				preload("res://barkley2/resources/B2_Weapon/material/Tin.tres"),
	MATERIAL.TITANIUM : 		preload("res://barkley2/resources/B2_Weapon/material/Titanium.tres"),
	MATERIAL.TUNGSTEN : 		preload("res://barkley2/resources/B2_Weapon/material/Tungsten.tres"),
	MATERIAL.UNTAMONIUM : 		preload("res://barkley2/resources/B2_Weapon/material/Untamonium.tres"),
	MATERIAL.WOOD : 			preload("res://barkley2/resources/B2_Weapon/material/Wood.tres"),
	MATERIAL.YGGDRASIL : 		preload("res://barkley2/resources/B2_Weapon/material/Yggdrasil.tres"),
	MATERIAL.ZINC : 			preload("res://barkley2/resources/B2_Weapon/material/Zinc.tres"),
	}
	
## List of B2_WeaponType resources.
const TYPE_LIST : Dictionary[TYPE, B2_WeaponType] = {
	TYPE.GUN_TYPE_ASSAULTRIFLE : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_ASSAULTRIFLE.tres"),
	TYPE.GUN_TYPE_BFG : 				preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_BFG.tres"),
	TYPE.GUN_TYPE_CROSSBOW : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_CROSSBOW.tres"),
	TYPE.GUN_TYPE_DOUBLESHOTGUN : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_DOUBLESHOTGUN.tres"),
	TYPE.GUN_TYPE_ELEPHANTGUN : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_ELEPHANTGUN.tres"),
	TYPE.GUN_TYPE_FLAMETHROWER : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_FLAMETHROWER.tres"),
	TYPE.GUN_TYPE_FLAREGUN : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_FLAREGUN.tres"),
	TYPE.GUN_TYPE_FLINTLOCK : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_FLINTLOCK.tres"),
	TYPE.GUN_TYPE_GATLINGGUN : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_GATLINGGUN.tres"),
	TYPE.GUN_TYPE_HEAVYMACHINEGUN : 	preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_HEAVYMACHINEGUN.tres"),
	TYPE.GUN_TYPE_HUNTINGRIFLE : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_HUNTINGRIFLE.tres"),
	TYPE.GUN_TYPE_MACHINEPISTOL : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MACHINEPISTOL.tres"),
	TYPE.GUN_TYPE_MAGNUM : 				preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MAGNUM.tres"),
	TYPE.GUN_TYPE_MINIGUN : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MINIGUN.tres"),
	TYPE.GUN_TYPE_MITRAILLEUSE : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MITRAILLEUSE.tres"),
	TYPE.GUN_TYPE_MUSKET : 				preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MUSKET.tres"),
	TYPE.GUN_TYPE_PISTOL : 				preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_PISTOL.tres"),
	TYPE.GUN_TYPE_REVOLVER : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_REVOLVER.tres"),
	TYPE.GUN_TYPE_REVOLVERSHOTGUN : 	preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_REVOLVERSHOTGUN.tres"),
	TYPE.GUN_TYPE_RIFLE : 				preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_RIFLE.tres"),
	TYPE.GUN_TYPE_ROCKET : 				preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_ROCKET.tres"),
	TYPE.GUN_TYPE_SHOTGUN : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_SHOTGUN.tres"),
	TYPE.GUN_TYPE_SNIPERRIFLE : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_SNIPERRIFLE.tres"),
	TYPE.GUN_TYPE_SUBMACHINEGUN : 		preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_SUBMACHINEGUN.tres"),
	TYPE.GUN_TYPE_TRANQRIFLE : 			preload("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_TRANQRIFLE.tres"),
}
## STUPID LIST for icons used in only one menu. check Gun line 297 and Utility line 2062. FUCK
const TYPE_ICON_LIST : Dictionary[TYPE, int] = {
	TYPE.GUN_TYPE_ASSAULTRIFLE : 		3,
	TYPE.GUN_TYPE_BFG : 				8,
	TYPE.GUN_TYPE_CROSSBOW : 			0,
	TYPE.GUN_TYPE_DOUBLESHOTGUN : 		9,
	TYPE.GUN_TYPE_ELEPHANTGUN : 		2,
	TYPE.GUN_TYPE_FLAMETHROWER : 		4,
	TYPE.GUN_TYPE_FLAREGUN : 			7,
	TYPE.GUN_TYPE_FLINTLOCK : 			5,
	TYPE.GUN_TYPE_GATLINGGUN : 			10,
	TYPE.GUN_TYPE_HEAVYMACHINEGUN : 	10,
	TYPE.GUN_TYPE_HUNTINGRIFLE : 		2,
	TYPE.GUN_TYPE_MACHINEPISTOL : 		1,
	TYPE.GUN_TYPE_MAGNUM : 				6,
	TYPE.GUN_TYPE_MINIGUN : 			10,
	TYPE.GUN_TYPE_MITRAILLEUSE : 		10,
	TYPE.GUN_TYPE_MUSKET : 				5,
	TYPE.GUN_TYPE_PISTOL : 				6,
	TYPE.GUN_TYPE_REVOLVER : 			6,
	TYPE.GUN_TYPE_REVOLVERSHOTGUN : 	9,
	TYPE.GUN_TYPE_RIFLE : 				2,
	TYPE.GUN_TYPE_ROCKET : 				7,
	TYPE.GUN_TYPE_SHOTGUN : 			9,
	TYPE.GUN_TYPE_SNIPERRIFLE : 		2, # // Is this sniper rifle?
	TYPE.GUN_TYPE_SUBMACHINEGUN : 		3,
	TYPE.GUN_TYPE_TRANQRIFLE : 			2,
}

const GROUP_LIST : Dictionary[TYPE, GROUP] = {
	TYPE.GUN_TYPE_ASSAULTRIFLE : 		GROUP.AUTOMATIC,
	TYPE.GUN_TYPE_BFG : 				GROUP.MOUNTED,
	TYPE.GUN_TYPE_CROSSBOW : 			GROUP.PROJECTILE,
	TYPE.GUN_TYPE_DOUBLESHOTGUN : 		GROUP.SHOTGUNS,
	TYPE.GUN_TYPE_ELEPHANTGUN : 		GROUP.SHOTGUNS,
	TYPE.GUN_TYPE_FLAMETHROWER : 		GROUP.PROJECTILE,
	TYPE.GUN_TYPE_FLAREGUN : 			GROUP.PROJECTILE,
	TYPE.GUN_TYPE_FLINTLOCK : 			GROUP.PISTOLS,
	TYPE.GUN_TYPE_GATLINGGUN : 			GROUP.MOUNTED,
	TYPE.GUN_TYPE_HEAVYMACHINEGUN : 	GROUP.AUTOMATIC,
	TYPE.GUN_TYPE_HUNTINGRIFLE : 		GROUP.RIFLES,
	TYPE.GUN_TYPE_MACHINEPISTOL : 		GROUP.AUTOMATIC,
	TYPE.GUN_TYPE_MAGNUM : 				GROUP.PISTOLS,
	TYPE.GUN_TYPE_MINIGUN : 			GROUP.MOUNTED,
	TYPE.GUN_TYPE_MITRAILLEUSE : 		GROUP.MOUNTED,
	TYPE.GUN_TYPE_MUSKET : 				GROUP.RIFLES,
	TYPE.GUN_TYPE_PISTOL : 				GROUP.PISTOLS,
	TYPE.GUN_TYPE_REVOLVER : 			GROUP.PISTOLS,
	TYPE.GUN_TYPE_REVOLVERSHOTGUN : 	GROUP.SHOTGUNS,
	TYPE.GUN_TYPE_RIFLE : 				GROUP.RIFLES,
	TYPE.GUN_TYPE_ROCKET : 				GROUP.PROJECTILE,
	TYPE.GUN_TYPE_SHOTGUN : 			GROUP.SHOTGUNS,
	TYPE.GUN_TYPE_SNIPERRIFLE : 		GROUP.RIFLES,
	TYPE.GUN_TYPE_SUBMACHINEGUN : 		GROUP.AUTOMATIC,
	TYPE.GUN_TYPE_TRANQRIFLE : 			GROUP.RIFLES,
}
## Used for weapon drops.
const GROUP_TYPE_LIST : Dictionary[GROUP, Array] = {
	GROUP.AUTOMATIC : 	[TYPE.GUN_TYPE_SUBMACHINEGUN,TYPE.GUN_TYPE_MACHINEPISTOL,TYPE.GUN_TYPE_HEAVYMACHINEGUN,TYPE.GUN_TYPE_ASSAULTRIFLE],
	GROUP.SHOTGUNS: 	[TYPE.GUN_TYPE_SHOTGUN,TYPE.GUN_TYPE_REVOLVERSHOTGUN,TYPE.GUN_TYPE_ELEPHANTGUN,TYPE.GUN_TYPE_DOUBLESHOTGUN],
	GROUP.RIFLES: 		[TYPE.GUN_TYPE_TRANQRIFLE,TYPE.GUN_TYPE_SNIPERRIFLE,TYPE.GUN_TYPE_RIFLE,TYPE.GUN_TYPE_MUSKET,TYPE.GUN_TYPE_HUNTINGRIFLE],
	GROUP.PROJECTILE: 	[TYPE.GUN_TYPE_ROCKET,TYPE.GUN_TYPE_FLAREGUN,TYPE.GUN_TYPE_FLAMETHROWER,TYPE.GUN_TYPE_CROSSBOW],
	GROUP.PISTOLS: 		[TYPE.GUN_TYPE_REVOLVER,TYPE.GUN_TYPE_PISTOL,TYPE.GUN_TYPE_MAGNUM,TYPE.GUN_TYPE_FLINTLOCK],
	GROUP.MOUNTED: 		[TYPE.GUN_TYPE_MITRAILLEUSE,TYPE.GUN_TYPE_MINIGUN,TYPE.GUN_TYPE_GATLINGGUN,TYPE.GUN_TYPE_BFG],
	}

## Merged sprite sheet. way simpler.
const FRANKIE_GUNS = preload("res://barkley2/assets/b2_original/guns/FrankieGuns.png")

## Gene Settings ##
const geneAffixChance 			:= 25;	## Range = 1-100% | Rolled 3 times per gun, 1 for each affix slot.
const geneAffixThreshold 		:= 30;	## Range = 1-100  | Value all penchants must be above for an affix to be applied.
const geneMinimumVariance 		:= 20;	## Range = 1-100
const geneMaximumBase 			:= 20;	## Range = 1-100
const geneMaximumVariance 		:= 30;	## Range = 1-100
## ^^^ The above works by doing AffixThreshold + random(MinimumVariance) = MinimumValue a gene can get in this affix generation
## ^^^ The maximum is the MinimumValue + global.geneMaximumBase + random(global.geneMaximumVariance) = MaximumValue
## ^^^ Using the formula above, the lowest a gene could get is a range of 30 to 50 and the highest is 50 to 100

const geneSecondaryValue 		:= .6;		## All penchant genes get this modifier
const geneOtherValue 			:= .45;		## All non-penchant genes get this modifier

static func reset() -> void:
	reset_bandolier()
	reset_gunbag()

static func reset_bandolier() -> void:
	B2_Playerdata.bandolier.clear()

static func reset_gunbag() -> void:
	B2_Playerdata.gun_bag.clear()

#region save and load guns.
static func save_guns() -> void:
	var gun_array := []
	if B2_Playerdata.bandolier:
		for gun in B2_Playerdata.bandolier:
			if gun is B2_Weapon:
				gun_array.append( gun_to_dict( gun ) )
	B2_Config.set_user_save_data( "player.guns.bandolier", gun_array )
	
	var gunbag_array := []
	if B2_Playerdata.gun_bag:
		for gunbag in B2_Playerdata.gun_bag:
			if gunbag is B2_Weapon:
				gunbag_array.append( gun_to_dict( gunbag ) )
	B2_Config.set_user_save_data( "player.guns.bag", gunbag_array )
	
## TODO Fix loading. NOTE Fixed. 
static func load_guns() -> void:
	var gun_array : Array = B2_Config.get_user_save_data( "player.guns.bandolier", [] )
	if gun_array:
		for gun in gun_array:
			if gun is Dictionary:
				var loaded_gun : B2_Weapon = dict_to_gun( gun )
				B2_Playerdata.bandolier.append( loaded_gun )
			else:
				push_error( "Invalid gun loaded: ", gun )
	
	var gunbag_array : Array = B2_Config.get_user_save_data( "player.guns.bag", [] )
	if gunbag_array:
		for gunbag in gun_array:
			if gunbag is Dictionary:
				var loaded_gun : B2_Weapon = dict_to_gun( gunbag )
				B2_Playerdata.gun_bag.append( loaded_gun )
			else:
				push_error( "Invalid gun loaded: ", gunbag )
	
## Gun serialization.
## TODO HANDLE SKILLS
static func gun_to_dict( gun : B2_Weapon ) -> Dictionary:
	var gun_dict := Dictionary()
	gun_dict[ "weapon_type" ] 			= var_to_str( gun.weapon_type )
	gun_dict[ "weapon_material" ] 		= var_to_str( gun.weapon_material )
	gun_dict[ "weapon_group" ]			= var_to_str( gun.weapon_group )

	gun_dict[ "weapon_name" ] 			= var_to_str( gun.weapon_name )
	gun_dict[ "weapon_short_name" ] 	= var_to_str( gun.weapon_short_name )
	gun_dict[ "weapon_pickup_name" ] 	= var_to_str( gun.weapon_pickup_name )
	gun_dict[ "weapon_pickup_color" ] 	= var_to_str( gun.weapon_pickup_color )
	
	gun_dict[ "prefix1" ] 				= var_to_str( gun.prefix1 )
	gun_dict[ "prefix2" ] 				= var_to_str( gun.prefix2 )
	gun_dict[ "suffix" ] 				= var_to_str( gun.suffix )
	gun_dict[ "att" ] 					= var_to_str( gun.att )
	gun_dict[ "spd" ] 					= var_to_str( gun.spd )
	gun_dict[ "acc" ] 					= var_to_str( gun.acc )
	gun_dict[ "afx" ] 					= var_to_str( gun.afx )
	gun_dict[ "wgt" ] 					= var_to_str( gun.wgt )

	gun_dict[ "max_action" ] 			= var_to_str( gun.max_action )
	gun_dict[ "curr_action" ] 			= var_to_str( gun.curr_action )

	gun_dict[ "max_ammo" ] 				= var_to_str( gun.max_ammo )
	gun_dict[ "curr_ammo" ] 			= var_to_str( gun.curr_ammo )

	gun_dict[ "attack_cost" ] 			= var_to_str( gun.attack_cost )
	
	gun_dict[ "generic_damage" ] 		= var_to_str( gun.generic_damage )
	gun_dict[ "bio_damage" ] 			= var_to_str( gun.bio_damage )
	gun_dict[ "cyber_damage" ] 			= var_to_str( gun.cyber_damage )
	gun_dict[ "mental_damage" ] 		= var_to_str( gun.mental_damage )
	gun_dict[ "cosmic_damage" ] 		= var_to_str( gun.cosmic_damage )
	gun_dict[ "zauber_damage" ] 		= var_to_str( gun.zauber_damage )

	gun_dict[ "weapon_lvl" ] 			= var_to_str( gun.weapon_lvl )
	gun_dict[ "weapon_xp" ] 			= var_to_str( gun.weapon_xp )
	gun_dict[ "skill_list" ] 			= var_to_str( gun.skill_list )
	
	gun_dict[ "favorite" ] 				= var_to_str( gun.favorite )
	gun_dict[ "son" ] 					= var_to_str( gun.son )
	gun_dict[ "lineage_top" ] 			= var_to_str( gun.lineage_top )
	gun_dict[ "lineage_bot" ] 			= var_to_str( gun.lineage_bot )
	gun_dict[ "generation" ] 			= var_to_str( gun.generation )

	gun_dict[ "bullets_per_shot" ] 		= var_to_str( gun.bullets_per_shot )
	gun_dict[ "ammo_per_shot" ] 		= var_to_str( gun.ammo_per_shot )
	gun_dict[ "wait_per_shot" ] 		= var_to_str( gun.wait_per_shot )
	gun_dict[ "bullet_spread" ] 		= var_to_str( gun.bullet_spread )
	return gun_dict
	
## TODO HANDLE SKILLS
static func dict_to_gun( gun_dict : Dictionary ) -> B2_Weapon:
	var gun := B2_Weapon.new()
	gun.weapon_type 					= str_to_var( gun_dict.get( "weapon_type") )
	gun.weapon_material 				= str_to_var( gun_dict.get( "weapon_material" ) )
	gun.weapon_group 					= str_to_var( gun_dict.get( "weapon_group" ) )

	gun.weapon_name 					= str_to_var( gun_dict.get( "weapon_name" ) )
	gun.weapon_short_name 				= str_to_var( gun_dict.get( "weapon_short_name" ) )
	gun.weapon_pickup_name 				= str_to_var( gun_dict.get( "weapon_pickup_name" ) )
	gun.weapon_pickup_color 			= str_to_var( gun_dict.get( "weapon_pickup_color" ) )
	
	gun.prefix1 						= str_to_var( gun_dict.get( "prefix1" ) )
	gun.prefix2 						= str_to_var( gun_dict.get( "prefix2" ) )
	gun.suffix 							= str_to_var( gun_dict.get( "suffix" ) )
	gun.att 							= str_to_var( gun_dict.get( "att" ) )
	gun.spd 							= str_to_var( gun_dict.get( "spd" ) )
	gun.acc 							= str_to_var( gun_dict.get( "acc" ) )
	gun.afx 							= str_to_var( gun_dict.get( "afx" ) )
	gun.wgt 							= str_to_var( gun_dict.get( "wgt" ) )

	gun.max_action 						= str_to_var( gun_dict.get( "max_action" ) )
	gun.curr_action 					= str_to_var( gun_dict.get( "curr_action" ) )

	gun.max_ammo 						= str_to_var( gun_dict.get( "max_ammo" ) )
	gun.curr_ammo 						= str_to_var( gun_dict.get( "curr_ammo" ) )

	gun.attack_cost 					= str_to_var( gun_dict.get( "attack_cost" ) )
	
	gun.generic_damage 					= str_to_var( gun_dict.get( "generic_damage" ) )
	gun.bio_damage 						= str_to_var( gun_dict.get( "bio_damage" ) )
	gun.cyber_damage 					= str_to_var( gun_dict.get( "cyber_damage" ) )
	gun.mental_damage 					= str_to_var( gun_dict.get( "mental_damage" ) )
	gun.cosmic_damage 					= str_to_var( gun_dict.get( "cosmic_damage" ) )
	gun.zauber_damage 					= str_to_var( gun_dict.get( "zauber_damage" ) )

	gun.weapon_lvl 						= str_to_var( gun_dict.get( "weapon_lvl" ) )
	gun.weapon_xp 						= str_to_var( gun_dict.get( "weapon_xp" ) )
	
	gun.skill_list 						= str_to_var( gun_dict.get( "skill_list" ) )
	
	gun.favorite 						= str_to_var( gun_dict.get( "favorite" ) )
	gun.son 							= str_to_var( gun_dict.get( "son" ) )
	gun.lineage_top 					= str_to_var( gun_dict.get( "lineage_top" ) )
	gun.lineage_bot 					= str_to_var( gun_dict.get( "lineage_bot" ) )
	gun.generation 						= str_to_var( gun_dict.get( "generation" ) )

	gun.bullets_per_shot 				= str_to_var( gun_dict.get( "bullets_per_shot" ) )
	gun.ammo_per_shot 					= str_to_var( gun_dict.get( "ammo_per_shot" ) )
	gun.wait_per_shot 					= str_to_var( gun_dict.get( "wait_per_shot" ) )
	gun.bullet_spread 					= str_to_var( gun_dict.get( "bullet_spread" ) )
	return gun
#endregion

## Code related to weapon creation, generation and fusion (maybe?).
#region Gun creation
# Check Drop("generate") line 396
## For now, luck stat plays no part in this
static func generate_gun( type := TYPE.GUN_TYPE_NONE, material := MATERIAL.NONE, wpn_name := "", add_affixes := true ) -> B2_Weapon:
	var wpn := B2_Weapon.new()
	
	## Pick weapon type if not specified
	if type != TYPE.GUN_TYPE_NONE:
		wpn.weapon_type = type
	else:
		var type_rand := randi_range(0,99)
		if type_rand < 80:		wpn.weapon_type = RARITY_TYPE[RARITY.TRASH].pick_random()
		elif type_rand < 95:	wpn.weapon_type = RARITY_TYPE[RARITY.MEH].pick_random()
		else:					wpn.weapon_type = RARITY_TYPE[RARITY.RARE].pick_random()
	
	## Get the type resource
	# wpn.type_data = weapon_type( wpn.weapon_type ) ## DEPRECATED
	# wpn.type_data 			= B2_Gun.TYPE_LIST[ wpn.weapon_type ]
	
	## Pick weapon material if not specified
	if material != MATERIAL.NONE:
		wpn.weapon_material = material
	else:
		var mat_rand := randi_range(0,99)
		if mat_rand < 60:			wpn.weapon_material = RARITY_MATERIAL[RARITY.TRASH].pick_random()
		elif mat_rand < 80:			wpn.weapon_material = RARITY_MATERIAL[RARITY.MEH].pick_random()
		elif mat_rand < 98:			wpn.weapon_material = RARITY_MATERIAL[RARITY.RARE].pick_random()
		else:						wpn.weapon_material = RARITY_MATERIAL[RARITY.GODAM].pick_random()
	
	## Get the material resource
	#wpn.material_data = weapon_material( wpn.weapon_material ) ## DEPRECATED
	
	if TYPE_LIST[ wpn.weapon_type ] == null:			push_warning( "Gun %s has no valid type." % wpn.get_full_name() )
	if MATERIAL_LIST[ wpn.weapon_material ] == null:	push_warning( "Gun %s has no valid material." % wpn.get_full_name() )
	
	var affix_count := 0
	var affix_rand := 0
	if add_affixes:
		## Pick affixes
		
		affix_rand = randi_range(0,99)
		if affix_rand < geneAffixChance:
			wpn.prefix1 = prefix1.keys().pick_random()
			affix_count += 1
			
		affix_rand = randi_range(0,99)
		if affix_rand < geneAffixChance:
			wpn.prefix2 = prefix2.keys().pick_random()
			affix_count += 1
			
		affix_rand = randi_range(0,99)
		if affix_rand < geneAffixChance:
			wpn.suffix = suffix.keys().pick_random()
			affix_count += 1
		
	apply_stats( wpn )
		
	## Set base name
	if wpn.weapon_material != MATERIAL.STEEL:
		wpn.weapon_name = str( MATERIAL.keys()[wpn.weapon_material] ).capitalize() + " " + gun_names[ wpn.weapon_type ] ## material different from steel have a different name.
	else:
		wpn.weapon_name = gun_names[ wpn.weapon_type ]
		
	if wpn_name:
		wpn.weapon_short_name = wpn_name
	else:
		## o_debugMode_gunfusinglab
		wpn.weapon_short_name = char( 65 + floor( randi_range(0,26) ) ) + char( 65 + floor(randi_range(0,26) ) ) + char( 65 + floor(randi_range(0,26) ) ) + char( 65 + floor( randi_range(0,26) ) );
	
	## Name used for gun pickups (Used for gunbag guns)
	var tx := ""
	match affix_count:
		1: tx = ["bizarre ","eerie ","odd ","weird "].pick_random(); wpn.weapon_pickup_color = Color.AQUA
		2: tx = ["rare ","special ","strange ","glowing "].pick_random(); wpn.weapon_pickup_color = Color.YELLOW
		3: tx = ["mystical ","ancient ", "mythical ","impossible ","grotesque "].pick_random(); Color.from_rgba8(213,114,177)
			
	wpn.weapon_pickup_name = tx + wpn.weapon_name
	
	## NOTE Missing some stuff. check scr_combat_weapons_buildName() line 33
		
	## Add graphic data, textures, colors, etc.
	# weapon_graphics( wpn ) ## DEPRECATED
		
	## Adjust some details
	# check scr_combat_weapons_prepPattern()
	
	## 18/05/25 - also add some freshly baked xXx-C0mB@7_Sk1l1zz-xXx to a weapon group.
	wpn.weapon_group = GROUP_LIST.get( wpn.weapon_type, GROUP.NONE ) ## Group is important for the type of fire that the weapon uses.
	match wpn.weapon_group:
		GROUP.NONE:
			## summtin isnt right.
			breakpoint
			
		GROUP.SHOTGUNS:
			wpn.bullets_per_shot 	= 10
			wpn.ammo_per_shot 		= 1
			wpn.wait_per_shot 		= 0.0
			wpn.bullet_spread 		= 0.35
			if wpn.weapon_type == TYPE.GUN_TYPE_DOUBLESHOTGUN:
				wpn.bullets_per_shot 	*= 2
				wpn.ammo_per_shot 		*= 2
				
		GROUP.AUTOMATIC:
			wpn.bullets_per_shot 	= 10
			wpn.ammo_per_shot 		= 10
			wpn.wait_per_shot 		= 0.05
			wpn.bullet_spread 		= 0.1
			
			## Skills
			wpn.skill_list[SKILL.BURST_FIRE] 	= 0
			wpn.skill_list[SKILL.FULL_AUTO] 	= 0
			
		GROUP.MOUNTED:
			wpn.bullets_per_shot 	= 25
			wpn.ammo_per_shot 		= 25
			wpn.wait_per_shot 		= 0.05
			wpn.bullet_spread 		= 0.20
			
		GROUP.PISTOLS:
			wpn.bullets_per_shot 	= 3
			wpn.ammo_per_shot 		= 3
			wpn.wait_per_shot 		= 0.2
			wpn.bullet_spread 		= 0.05
			
			## Skills
			wpn.skill_list[SKILL.PRECISION_SHOT] 	= 0
			wpn.skill_list[SKILL.BURST_FIRE] 		= 25
			
		GROUP.PROJECTILE:
			wpn.bullets_per_shot 	= 1
			wpn.ammo_per_shot 		= 1
			wpn.wait_per_shot 		= 0.0
			wpn.bullet_spread 		= 0.0
			
		GROUP.RIFLES:
			wpn.bullets_per_shot 	= 1
			wpn.ammo_per_shot 		= 1
			wpn.wait_per_shot 		= 0.1
			wpn.bullet_spread 		= 0.025
			
			## Skills
			wpn.skill_list[SKILL.PRECISION_SHOT] 	= 0
			wpn.skill_list[SKILL.BURST_FIRE] 		= 25
		_:
			## summtin REEEALY isnt right.
			breakpoint
	
	return wpn
	
static func apply_stats( wpn : B2_Weapon ) -> void:
	## Set base stats (Random for now). This should be modified by the material, type, and affixes. ## WARNING It isnt at this moment 28/02/25
	## 22/04/25 Stat generation is scary.
	
	var points 			:= 100 ## points for stat generation. NOTE I have no idea how the game generate this number. 100 seems normal.
	var points_left 	:= points
	@warning_ignore("integer_division")
	var poinst_each 	:= points_left / 5 # was 7
	
	wpn.att 		= ceil( poinst_each * ( ( ( wpn.get_power_mod() 	- 1 ) / 2 ) + 1 ) )
	wpn.spd 		= ceil( poinst_each * ( ( ( wpn.get_speed_mod() 	- 1 ) / 2 ) + 1 ) )
	wpn.afx			= ceil( poinst_each * ( ( ( wpn.get_affix_mod() 	- 1 ) / 2 ) + 1 ) ) # NOTE Not implemented.
	#wpn.lck 		= ceil( poinst_each * ( ( ( wpn.get_luck_mod() 		- 1 ) / 2 ) + 1 ) )
	wpn.acc 		= ceil( poinst_each * ( ( ( wpn.get_acc_mod() 		- 1 ) / 2 ) + 1 ) )
	wpn.max_ammo 	= ceil( poinst_each * ( ( ( wpn.get_ammo_mod() 		- 1 ) / 2 ) + 1 ) )
		
	wpn.att 		= clamp(wpn.att, 0, 90 )
	wpn.spd 		= clamp(wpn.spd, 0, 90 )
	wpn.afx 		= clamp(wpn.afx, 0, 90 )
	#wpn.lck 		= clamp(wpn.lck, 0, 90 )
	wpn.acc			= clamp(wpn.acc, 0, 90 )
	wpn.max_ammo 	= clamp(wpn.max_ammo, 0, 90 )
	
	## distribute remaining core points randomly
	var remain_points = poinst_each * 2 + ( poinst_each * 5 - ( wpn.att + wpn.spd + wpn.max_ammo + wpn.afx ) );
		
	var tries := 10;
	while remain_points > 0:
		match randi_range(0,3):
			0: pass
			1: pass
			2: pass
			3: pass
		
		var tryit := false ## if a weapon generates an individual stat above 90, it tries again
		if wpn.att > 90: wpn.att = 90; 				tryit = true
		if wpn.spd > 90: wpn.spd = 90; 				tryit = true
		if wpn.max_ammo > 90: wpn.max_ammo = 90; 	tryit = true
		if wpn.afx > 90: wpn.afx = 90; 				tryit = true
		
		## after 10 tries it gives up on fitting the points, and points are lost.
		if !tryit || tries <= 0: 	remain_points -= 1
		else:						tries -= 1 
	
	## Save points used.
	wpn.pts = points
	
## Assign a texture, color, shit like that. Simulates scr_combat_weapons_applyGraphic()
static func weapon_graphics( wpn : B2_Weapon ) -> AtlasTexture: ## scr_combat_weapons_applyGraphic
	var first_atlas 					:= AtlasTexture.new() ## Hud Image
	first_atlas.atlas 					= FRANKIE_GUNS
	first_atlas.region.size.x 			= GUNWIDTH
	first_atlas.region.size.y 			= GUNHEIGHT
	first_atlas.region.position.x 		= wpn.weapon_material 	* GUNWIDTH
	first_atlas.region.position.y 		= wpn.weapon_type 		* GUNHEIGHT
	first_atlas.resource_local_to_scene	= true
	return first_atlas

## this... is a mess. simulates the script scr_combat_weapons_applyMaterial() 		DEPRECATED
#static func weapon_material( mat : MATERIAL ) -> B2_WeaponMaterial:
	#var m := load( MATERIAL_LIST[mat] ) as B2_WeaponMaterial
	#return m

## this... is a mess. simulates the script scr_combat_weapons_applyType()			DEPRECATED
#static func weapon_type( typ : TYPE ) -> B2_WeaponType:
	#var t = load( TYPE_LIST[typ] ) as B2_WeaponType
	#return t

#endregion

## Code related to adding guns, taking guns and stuff like that.
#region Gun management

static func get_gun_from_db( gun_db_name : String, gun_name : String = "" ) -> B2_Weapon:
	## NOTE Once again, im porting old code jankiness.
	match gun_db_name:
		"wilmerGun": # You get this for free from Wilmer
			gun_db_name = "wilmers gun"
			gun_name = "WILM"
		"estherGun": # You get this for free from Wilmer
			gun_db_name = "esthers gun"
			gun_name = "ESTR"    
		"wilmerPax1": # PAX2015 - Get this from Wilmer also
			gun_db_name = "generic pistol"
			gun_name = "URGH"    
		"wilmerPax2": # PAX2015 - Get this from Wilmer also
			gun_db_name = "generic automatic"
			gun_name = "ZOAL"
		"cornrowGun": # Get this after completing the first task for Cornrow
			gun_db_name = "bio shotgun"
			gun_name = "CORN"
		"juiceboxGun": # Get this after completing all of Cornrow's tasks
			gun_db_name = "bio rifle"
			gun_name = "JUCE"
		"kaleviGun1": # Get for free after talking to Kalevi for first time
			gun_db_name = "cyber pistol"
			gun_name = "NANC"
		"kaleviGun2": # Get from Kalevi after visiting rebel base and learning he supplies the rebels
			gun_db_name = "cyber projectile"
			gun_name = "BIGZ"
		"bombHut": # Get from bomb hut (where joad is)
			gun_db_name = "mental rifle"
			gun_name = "DOUG"
		"gunsalesmanGun1": # 1st gun of his bad batch
			gun_db_name = "kosmic pistol"
			gun_name = "FUND"
		"gunsalesmanGun2": # 2nd gun of his bad batch
			gun_db_name = "kosmic rifle"
			gun_name =  "GIRF"
		"gunsalesmanGun3": # 3rd gun of his bad batch
			gun_db_name = "kosmic shotgun"
			gun_name =  "SGUN"
		"gunsalesmanGun4": # 1st gun of his good batch
			gun_db_name = "zauber pistol"
			gun_name =  "HELL"
		"gunsalesmanGun5": # 2nd gun of his good batch
			gun_db_name = "zauber rifle"
			gun_name =  "NIFF"
		"gunsalesmanGun6": # 3rd gun of his good batch
			gun_db_name = "zauber shotgun"
			gun_name =  "GOOP"
		"gilbertGun": # Gun in a chest at Gilbert's Peek
			gun_db_name = "zauber pistol"
			gun_name =  "GILB"
		_:
			if not gun_db.has(gun_db_name):
				push_warning( "Invalid gun being generated from DB. %s - %s." % [gun_db_name, gun_name] )
				gun_db_name 	= "generic pistol"
				gun_name 		= "BOOB"
			
	var my_gun := B2_Weapon.new()
	# scr_gun_db
	## GD  Ge Bi Cy Me Ko Za Au Mo Pi Pr Ri Sh
	## [56, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
	##  00, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 
	var db_gun : Array = gun_db.get( gun_db_name, Array() )
	var choices : Array[GROUP]
	if db_gun:
		if db_gun[7]:
			choices.append( GROUP.AUTOMATIC )
		if db_gun[8]:
			choices.append( GROUP.MOUNTED )
		if db_gun[9]:
			choices.append( GROUP.PISTOLS )
		if db_gun[10]:
			choices.append( GROUP.PROJECTILE )
		if db_gun[11]:
			choices.append( GROUP.RIFLES )
		if db_gun[12]:
			choices.append( GROUP.SHOTGUNS )
			
		my_gun = generate_gun( choices.pick_random(), MATERIAL.NONE, gun_name, true )
		
		my_gun.generic_damage 	= db_gun[1]
		my_gun.bio_damage 		= db_gun[2]
		my_gun.cyber_damage 	= db_gun[3]
		my_gun.mental_damage 	= db_gun[4]
		my_gun.cosmic_damage 	= db_gun[5]
		my_gun.zauber_damage 	= db_gun[6]
		
		#append_gun_to_bandolier( my_gun )
		print( "B2_Gun: Gun '%s' named '%s' generated." % [gun_db_name, gun_name] )
	else:
		push_error( "B2_Gun: Invalid Gun '%s' named '%s'." % [gun_db_name, gun_name] )
		
	return my_gun
	
## Add generate a gun and add it to bandolier.
static func add_gun_to_bandolier( type := TYPE.GUN_TYPE_NONE, material := MATERIAL.NONE, wpn_name := "", add_affixes := true ) -> void: ## TODO
	## Gun names are only 4 letter words.
	append_gun_to_bandolier( generate_gun(type, material, wpn_name.left(4), add_affixes) )

static func append_gun_to_bandolier( wpn : B2_Weapon ) -> void:
	print_rich("[color=orange]Appending gun to bandolier: %s.[/color]" % wpn.get_full_name())
	B2_Playerdata.bandolier.append( wpn )
	if B2_Playerdata.bandolier.size() > BANDOLIER_SIZE:
		B2_Playerdata.bandolier.pop_front() ## Remove the first gun from the bandolier.
		print("B2_Gun: Bandolier full, 'dropping' the oldest gun. ") ## WARNING Droping guns not enabled.

## Add generate a gun and add it to bandolier.
static func add_gun_to_gunbag( type := TYPE.GUN_TYPE_NONE, material := MATERIAL.NONE, wpn_name := "", add_affixes := true ) -> void: ## TODO
	append_gun_to_gunbag( generate_gun(type, material,  wpn_name, add_affixes) )
	
static func append_gun_to_gunbag( wpn : B2_Weapon ) -> void:
	print_rich("[color=orange]Appending gun to gunbag: %s.[/color]" % wpn.get_full_name())
	B2_Playerdata.gun_bag.append( wpn )
	if B2_Playerdata.gun_bag.size() > GUNBAG_SIZE:
		B2_Playerdata.gun_bag.pop_front() ## Remove the first gun from the gunbag
		print("B2_Gun: Gunbag full, 'dropping' the oldest gun. ") ## WARNING Droping guns not enabled.
	
	
## remove specific gun from inventory
static func remove_gun( wpn : B2_Weapon ) -> void:
	remove_gun_from_bandolier( wpn )
	remove_gun_from_gunbag( wpn )
	## TODO manage bandolier and gun bag.

static func remove_gun_from_bandolier( wpn : B2_Weapon ) -> void:
	B2_Playerdata.bandolier.erase( wpn )
	
static func remove_gun_from_gunbag( wpn : B2_Weapon ) -> void:
	B2_Playerdata.gun_bag.erase( wpn )

static func clear_guns() -> void:
	B2_Playerdata.bandolier.clear()
	B2_Playerdata.gun_bag.clear()
	
static func distribute_battle_exp( _exp : int ) -> void:
	## NOTE Only guns in bando can receive XP.
	if not get_bandolier().is_empty():
		@warning_ignore("integer_division")
		var per_gun_exp := _exp / get_bandolier().size()
		for gun : B2_Weapon in get_bandolier():
			gun.gain_exp( per_gun_exp )
	
static func get_skill( skill : SKILL ) -> B2_WeaponSkill:
	return SKILL_LIST.get( skill, null )
	
static func get_bandolier() -> Array[B2_Weapon]:
	return B2_Playerdata.bandolier
	
static func get_gunbag() -> Array[B2_Weapon]:
	return B2_Playerdata.gun_bag
	
static func toggle_gunbag() -> void:
	if get_gunbag().size() > 0:
		B2_Playerdata.gunbag_open = not B2_Playerdata.gunbag_open
		B2_Playerdata.selected_gun = B2_Playerdata.selected_gun
		B2_Playerdata.gun_changed.emit()
	
static func next_band_gun() -> void:
	B2_Playerdata.selected_gun += 1
	# push_warning("DEBUG disabled")
	
static func prev_band_gun() -> void:
	B2_Playerdata.selected_gun -= 1
	# push_warning("DEBUG disabled")
	
static func select_band_gun( id : int ) -> void:
	if id > B2_Playerdata.bandolier.size():
		push_error("Tried to select a weapon that does not exist.")
	B2_Playerdata.selected_gun = id
	
static func select_gunbag_gun( id : int ) -> void:
	if id > B2_Playerdata.gun_bag.size():
		push_error("Tried to select a weapon that does not exist.")
	toggle_gunbag()
	B2_Playerdata.selected_gun = id
	
static func has_gun_in_gunbag() -> bool:
	return not B2_Playerdata.gun_bag.is_empty()
	
static func has_gun_in_bandolier() -> bool:
	return not B2_Playerdata.bandolier.is_empty()
	
static func has_any_guns() -> bool:
	return has_gun_in_gunbag() or has_gun_in_bandolier()
	
static func can_add_gun_to_bando() -> bool:
	return B2_Playerdata.bandolier.size() >= BANDOLIER_SIZE

static func can_add_gun_to_gunbag() -> bool:
	return B2_Playerdata.gun_bag.size() >= GUNBAG_SIZE
	
static func get_current_gun() -> B2_Weapon:
	if B2_Playerdata.gunbag_open:
		if has_gun_in_gunbag():
			return B2_Playerdata.gun_bag[ B2_Playerdata.selected_gun ] ## FIXME
		else:
			return B2_Weapon.new()
	else:
		if has_gun_in_bandolier():
			return B2_Playerdata.bandolier[ B2_Playerdata.selected_gun ] ## FIXME
		else:
			return B2_Weapon.new()
#endregion

#region Position the gun on the players hand
## NOTE THis section was on the player script
## Values taken from scr_player_muzzle_position. unsure how I can use this.
static func get_muzzle_dist() -> float:
	var heldBulletDist := 0.0
	match B2_Gun.get_current_gun().weapon_type:
		B2_Gun.TYPE.GUN_TYPE_MINIGUN:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,B2_Gun.TYPE.GUN_TYPE_RIFLE,B2_Gun.TYPE.GUN_TYPE_MUSKET,B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE,B2_Gun.TYPE.GUN_TYPE_CROSSBOW:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN,B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN,B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN,B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:
			heldBulletDist = 16.0
		## rocket launchers are on the shoulder.
		B2_Gun.TYPE.GUN_TYPE_ROCKET:
			heldBulletDist = 20.0
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL,B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN,B2_Gun.TYPE.GUN_TYPE_REVOLVER,B2_Gun.TYPE.GUN_TYPE_PISTOL,B2_Gun.TYPE.GUN_TYPE_MAGNUM,B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:
			heldBulletDist = 10.0 # was 8.0
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			heldBulletDist = 8.0
		B2_Gun.TYPE.GUN_TYPE_BFG:
			heldBulletDist = 16.0
	return heldBulletDist
	
## Values taken from scr_player_muzzle_position. unsure how I can use this.
static func get_muzzle_pos() -> float: ## TODO
	return 0.0
	
## scr_player_getGunShifts - set the offsef for the held gun
static func get_gun_held_dist() -> float:
	var heldDist := 0.0

	match B2_Gun.get_current_gun().weapon_type:
		B2_Gun.TYPE.GUN_TYPE_MINIGUN:
			heldDist = -6.0
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:
			heldDist = -4.0
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:
			heldDist = 0.0
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:
			heldDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,B2_Gun.TYPE.GUN_TYPE_RIFLE,B2_Gun.TYPE.GUN_TYPE_MUSKET,B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE,B2_Gun.TYPE.GUN_TYPE_CROSSBOW:
			heldDist = 22.0
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN, B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN, B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN, B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:
			heldDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:
			heldDist = 18.0
		## rocket launchers are on the shoulder.
		B2_Gun.TYPE.GUN_TYPE_ROCKET:
			heldDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL, B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN, B2_Gun.TYPE.GUN_TYPE_REVOLVER, B2_Gun.TYPE.GUN_TYPE_PISTOL, B2_Gun.TYPE.GUN_TYPE_MAGNUM, B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:
			heldDist = 22.0 # was 17.0
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			heldDist = 17.0 # was 17.0
		B2_Gun.TYPE.GUN_TYPE_BFG:
			heldDist = 0.0
		_:
			print( B2_Gun.TYPE.keys()[B2_Gun.get_current_gun().weapon_type] )
	return heldDist

## scr_player_getGunShifts - set the offsef for the held gun
static func get_gun_shifts() -> Vector2:
	var heldHShift := 0.0
	var heldVShift := 0.0
	match B2_Gun.get_current_gun().weapon_type:
		B2_Gun.TYPE.GUN_TYPE_MINIGUN:
			heldVShift = -2;
			heldHShift = -12;
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:
			heldVShift = 3;
			heldHShift = -12;
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:
			heldVShift = 3;
			heldHShift = -12;
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:
			heldVShift = 0;
			heldHShift = -8;
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,B2_Gun.TYPE.GUN_TYPE_RIFLE,B2_Gun.TYPE.GUN_TYPE_MUSKET,B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE,B2_Gun.TYPE.GUN_TYPE_CROSSBOW:
			heldVShift = 1;
			heldHShift = -8;
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN,B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN,B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN,B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:
			heldVShift = 0;
			heldHShift = -8;
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:
			heldVShift = 2;
			heldHShift = -8;
		## rocket launchers are on the shoulder.
		B2_Gun.TYPE.GUN_TYPE_ROCKET:
			heldVShift = 12;
			heldHShift = 8;
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL,B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN,B2_Gun.TYPE.GUN_TYPE_REVOLVER,B2_Gun.TYPE.GUN_TYPE_PISTOL,B2_Gun.TYPE.GUN_TYPE_MAGNUM,B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:
			heldHShift = 0; # 0
			heldVShift = 5; # 5
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			heldHShift = 0;
			heldVShift = 6;
		B2_Gun.TYPE.GUN_TYPE_BFG:
			heldVShift = 3;
			heldHShift = -12;
	
	#heldVShift = 0 ## DEBUG
	#return Vector2( heldHShift, heldVShift )
	return Vector2( heldVShift, heldHShift )
#endregion
