extends Resource
class_name B2_Gun
## Static data for Guns.
# Check scr_gun_db(), Drop() and Gun()
# Also HUD line 25 for gunsheet shit.
# also scr_combat_weapons_generate for material an gun generation.

const GUNWIDTH 		= 49;
const GUNHEIGHT 	= 24;
const GUNPERSHEET 	= 9; 	## Number of guns to put per sheet. If loading a sheet takes too long, lower this number. ## NOTE Number of gun material per "FrankieGuns" texture
const GUNMATERIALS 	= 81; 	## Maximum number of gun materials in game
const GUNTYPES 		= 26;	## Maximum number of types of guns we'll have

const BANDOLIER_SIZE 	:= 3
const GUNBAG_SIZE 		:= 3

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
	GUN_TYPE_NONE
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
	
enum GROUP{ ## Weapon groups. no idea how its used.
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

## List of affixes. Add modifiers to guns
const prefix1 := [
	{ "description": "Shots fire into random directions. N00bs only.", "gene1": "minus", "gene2": "random", "name": "NoScope360" },
	{ "description": "Shots avoid enemies.", "gene1": "minus", "gene2": "homing", "name": "Polarized" },
	{ "description": "Shots return to the shooter.", "gene1": "minus", "gene2": "bounce", "name": "Fetching" },
	{ "description": "Shots lob into the air.", "gene1": "minus", "gene2": "curved", "name": "Lobbing" },
	{ "description": "Shots slow down after being fired.", "gene1": "minus", "gene2": "firing", "name": "Pensioner\'s" },
	{ "description": "Shots fire from behind the braster.", "gene1": "minus", "gene2": "linear", "name": "Afterburner" },
	{ "description": "Shots fire from around the player.", "gene1": "plus", "gene2": "random", "name": "Magician\'s" },
	{ "description": "Shots seek the nearest enemy.", "gene1": "plus", "gene2": "homing", "name": "Gravitational" },
	{ "description": "Shots ricochet off solid surfaces.", "gene1": "plus", "gene2": "bounce", "name": "Ricocheting" },
	{ "description": "Shots move in a wave pattern.", "gene1": "plus", "gene2": "curved", "name": "Surfing" },
	{ "description": "Gun\'s fires multiple, wasteful shots at once.", "gene1": "plus", "gene2": "firing", "name": "Flooding" },
	{ "description": "Shots pierce through enemies.", "gene1": "plus", "gene2": "linear", "name": "Ghostic" },
	{ "description": "Shots are out of control.", "gene1": "pound", "gene2": "random", "name": "Goofed" },
	{ "description": "Shots fire towards nearest enemy.", "gene1": "pound", "gene2": "homing", "name": "Proximity" },
	{ "description": "Shots chain to multiple enemies.", "gene1": "pound", "gene2": "bounce", "name": "Chaining" },
	{ "description": "Shots circle around the braster.", "gene1": "pound", "gene2": "curved", "name": "Orbiting" },
	{ "description": "Gun\'s has anger issues.", "gene1": "pound", "gene2": "firing", "name": "Berzerk\'d" },
	{ "description": "Shots turn periodically.", "gene1": "pound", "gene2": "linear", "name": "Dotline" },
	]
const prefix2 := [
	{ "action": null, "description": "hp", "gene1": "top", "gene2": "cosmic", "name": "Pachinkode\'d" },
	{ "action": null, "description": "hp", "gene1": "top", "gene2": "mental", "name": "Klisp\'d" },
	{ "action": null, "description": "hp", "gene1": "top", "gene2": "bio", "name": "Juice\'d" },
	{ "action": null, "description": "hp", "gene1": "top", "gene2": "cyber", "name": "Parkour\'d" },
	{ "action": null, "description": "hp", "gene1": "top", "gene2": "zauber", "name": "Impose\'d" },
	{ "action": null, "description": "hp", "gene1": "charm", "gene2": "cosmic", "name": "Gambling" },
	{ "action": null, "description": "hp", "gene1": "charm", "gene2": "mental", "name": "Agonizing" },
	{ "action": null, "description": "hp", "gene1": "charm", "gene2": "bio", "name": "Thorny" },
	{ "action": null, "description": "hp", "gene1": "charm", "gene2": "cyber", "name": "Deathbound" },
	{ "action": null, "description": "hp", "gene1": "charm", "gene2": "zauber", "name": "Radiating" },
	{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "cosmic", "name": "Galactic" },
	{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "mental", "name": "Migraining" },
	{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "bio", "name": "Gooping" },
	{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "cyber", "name": "Overloading" },
	{ "action": null, "description": "hp", "gene1": "bottom", "gene2": "zauber", "name": "Zaubering" },
	{ "action": null, "description": "capability", "gene1": "top", "gene2": "cosmic", "name": "KosmicBoost" },
	{ "action": null, "description": "capability", "gene1": "top", "gene2": "mental", "name": "MentalBoost" },
	{ "action": null, "description": "capability", "gene1": "top", "gene2": "bio", "name": "BioBoost" },
	{ "action": null, "description": "capability", "gene1": "top", "gene2": "cyber", "name": "CyberBoost" },
	{ "action": null, "description": "capability", "gene1": "top", "gene2": "zauber", "name": "ZauberBoost" },
	{ "action": null, "description": "capability", "gene1": "charm", "gene2": "cosmic", "name": "ResistRespec" },
	{ "action": null, "description": "capability", "gene1": "charm", "gene2": "mental", "name": "ResistLower" },
	{ "action": null, "description": "capability", "gene1": "charm", "gene2": "bio", "name": "Milkdrop" },
	{ "action": null, "description": "capability", "gene1": "charm", "gene2": "cyber", "name": "ResistSwap" },
	{ "action": null, "description": "capability", "gene1": "charm", "gene2": "zauber", "name": "ResistEqual" },
	{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "cosmic", "name": "KosmicFallen" },
	{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "mental", "name": "MentalFallen" },
	{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "bio", "name": "BioFallen" },
	{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "cyber", "name": "CyberFallen" },
	{ "action": null, "description": "capability", "gene1": "bottom", "gene2": "zauber", "name": "ZauberFallen" },
	{ "action": null, "description": "properties", "gene1": "top", "gene2": "cosmic", "name": "LuckBoost" },
	{ "action": null, "description": "properties", "gene1": "top", "gene2": "mental", "name": "PietyBoost" },
	{ "action": null, "description": "properties", "gene1": "top", "gene2": "bio", "name": "MightBoost" },
	{ "action": null, "description": "properties", "gene1": "top", "gene2": "cyber", "name": "AcroBoost" },
	{ "action": null, "description": "properties", "gene1": "top", "gene2": "zauber", "name": "GutsBoost" },
	{ "action": null, "description": "properties", "gene1": "charm", "gene2": "cosmic", "name": "Respeccing" },
	{ "action": null, "description": "properties", "gene1": "charm", "gene2": "mental", "name": "Withering" },
	{ "action": null, "description": "properties", "gene1": "charm", "gene2": "bio", "name": "Dyslexic" },
	{ "action": null, "description": "properties", "gene1": "charm", "gene2": "cyber", "name": "Hotswapping" },
	{ "action": null, "description": "properties", "gene1": "charm", "gene2": "zauber", "name": "Equalizing" },
	{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "cosmic", "name": "LuckFallen" },
	{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "mental", "name": "PietyFallen" },
	{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "bio", "name": "MightFallen" },
	{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "cyber", "name": "AcroFallen" },
	{ "action": null, "description": "properties", "gene1": "bottom", "gene2": "zauber", "name": "GutsFallen" },
	{ "action": null, "description": "weight", "gene1": "top", "gene2": "cosmic", "name": "WeightLower" },
	{ "action": null, "description": "weight", "gene1": "top", "gene2": "mental", "name": "BrainGain" },
	{ "action": null, "description": "weight", "gene1": "top", "gene2": "bio", "name": "DefenseGain" },
	{ "action": null, "description": "weight", "gene1": "top", "gene2": "cyber", "name": "KnockGain" },
	{ "action": null, "description": "weight", "gene1": "top", "gene2": "zauber", "name": "StaggerGain" },
	{ "action": null, "description": "weight", "gene1": "charm", "gene2": "cosmic", "name": "Pilfering" },
	{ "action": null, "description": "weight", "gene1": "charm", "gene2": "mental", "name": "Adhesive" },
	{ "action": null, "description": "weight", "gene1": "charm", "gene2": "bio", "name": "Smelting" },
	{ "action": null, "description": "weight", "gene1": "charm", "gene2": "cyber", "name": "Busting" },
	{ "action": null, "description": "weight", "gene1": "charm", "gene2": "zauber", "name": "Blinking" },
	{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "cosmic", "name": "Heavy" },
	{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "mental", "name": "Foggy" },
	{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "bio", "name": "Risky" },
	{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "cyber", "name": "Slippery" },
	{ "action": null, "description": "weight", "gene1": "bottom", "gene2": "zauber", "name": "Goofy" },
	]
const suffix := [
	{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "bio", "name": "of the Dracula" },
	{ "action": null, "description": "passive", "gene1": "down", "gene2": "bio", "name": "of the Healthy Youth" },
	{ "action": null, "description": "reactive", "gene1": "down", "gene2": "bio", "name": "of Flicker" },
	{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "cosmic", "name": "of the Circus" },
	{ "action": null, "description": "passive", "gene1": "down", "gene2": "cosmic", "name": "of the Dying Youth" },
	{ "action": null, "description": "reactive", "gene1": "down", "gene2": "cosmic", "name": "of the Bad Aim" },
	{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "cyber", "name": "of the Clock" },
	{ "action": null, "description": "passive", "gene1": "down", "gene2": "cyber", "name": "of the Today\'s Youth" },
	{ "action": null, "description": "reactive", "gene1": "down", "gene2": "cyber", "name": "of the Paintball" },
	{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "mental", "name": "of Muramasa" },
	{ "action": null, "description": "passive", "gene1": "down", "gene2": "mental", "name": "of Masamune" },
	{ "action": null, "description": "reactive", "gene1": "down", "gene2": "mental", "name": "of Murasame" },
	{ "action": null, "description": "aggressive", "gene1": "down", "gene2": "zauber", "name": "cursed by a Wicca Hex" },
	{ "action": null, "description": "passive", "gene1": "down", "gene2": "zauber", "name": "of the Lich" },
	{ "action": null, "description": "reactive", "gene1": "down", "gene2": "zauber", "name": "of the Elements" },
	{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "bio", "name": "of Leper\'s Digest" },
	{ "action": null, "description": "passive", "gene1": "strange", "gene2": "bio", "name": "of Chaining" },
	{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "bio", "name": "of the Bazinga" },
	{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "cosmic", "name": "of Jeeper\'s Digest" },
	{ "action": null, "description": "passive", "gene1": "strange", "gene2": "cosmic", "name": "of Dotlining" },
	{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "cosmic", "name": "of Sacrifice" },
	{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "cyber", "name": "with Nanomachines" },
	{ "action": null, "description": "passive", "gene1": "strange", "gene2": "cyber", "name": "of Ghosting" },
	{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "cyber", "name": "of Lets Play" },
	{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "mental", "name": "with a Battery Charger" },
	{ "action": null, "description": "passive", "gene1": "strange", "gene2": "mental", "name": "of Magicing" },
	{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "mental", "name": "of the Pacifist" },
	{ "action": null, "description": "aggressive", "gene1": "strange", "gene2": "zauber", "name": "of Reaper\'s Digest" },
	{ "action": null, "description": "passive", "gene1": "strange", "gene2": "zauber", "name": "of Surfing" },
	{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "zauber", "name": "of Triskelion" },
	{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "bio", "name": "of the Entlord" },
	{ "action": null, "description": "passive", "gene1": "up", "gene2": "bio", "name": "of the Iceman" },
	{ "action": null, "description": "reactive", "gene1": "up", "gene2": "bio", "name": "with a hole in the Pocket" },
	{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "cosmic", "name": "of the Quasar" },
	{ "action": null, "description": "passive", "gene1": "up", "gene2": "cosmic", "name": "of the Perfectionist" },
	{ "action": null, "description": "reactive", "gene1": "up", "gene2": "cosmic", "name": "of Eternity" },
	{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "cyber", "name": "of the Doxxer" },
	{ "action": null, "description": "passive", "gene1": "up", "gene2": "cyber", "name": "of the Metallic Muscle" },
	{ "action": null, "description": "reactive", "gene1": "up", "gene2": "cyber", "name": "of the Planet of Vapes" },
	{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "mental", "name": "of the Encephalon" },
	{ "action": null, "description": "passive", "gene1": "up", "gene2": "mental", "name": "from Heck" },
	{ "action": null, "description": "reactive", "gene1": "up", "gene2": "mental", "name": "of Deep Welling" },
	{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "zauber", "name": "of the Ps. Pocus" },
	{ "action": null, "description": "passive", "gene1": "up", "gene2": "zauber", "name": "of the Becker" },
	{ "action": null, "description": "reactive", "gene1": "up", "gene2": "zauber", "name": "of the Forever Man" },
	{ "action": null, "description": "aggressive", "gene1": "up", "gene2": "cyber", "name": "of the Doxxer" },
	{ "action": null, "description": "passive", "gene1": "up", "gene2": "cyber", "name": "of Perpetual War" },
	{ "action": null, "description": "reactive", "gene1": "up", "gene2": "cyber", "name": "of Caltropix" },
	{ "action": null, "description": "passive", "gene1": "up", "gene2": "mental", "name": "with a hole in the pocket" },
	{ "action": null, "description": "reactive", "gene1": "up", "gene2": "mental", "name": "of Fight or Flight" },
	{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "cyber", "name": "of the Let\'s Plays" },
	{ "action": null, "description": "reactive", "gene1": "strange", "gene2": "mental", "name": "of Bailing Out" },
	]

## Data related to the material status modifiers. This took me 1 hour to make, hope I use it. ## DEPRECATED
#const GUN_MATERIAL_DB = preload("res://barkley2/resources/B2_Weapon/gun_material_db.json")

## Data related to the weapon type. its missing a lot of stuff. ## DEPRECATED
#const GUN_TYPE_DB = preload("res://barkley2/resources/B2_Weapon/gun_type_db.json")

const MATERIAL_LIST : Dictionary[MATERIAL, String] = {
	MATERIAL.PRINTED : ("res://barkley2/resources/B2_Weapon/material/3D Printed.tres"),
	MATERIAL.ADAMANTIUM : ("res://barkley2/resources/B2_Weapon/material/Adamantium.tres"),
	MATERIAL.AEROGEL : ("res://barkley2/resources/B2_Weapon/material/Aerogel.tres"),
	MATERIAL.ALUMINIUM : ("res://barkley2/resources/B2_Weapon/material/Aluminium.tres"),
	MATERIAL.ALUMINUM : ("res://barkley2/resources/B2_Weapon/material/Aluminum.tres"),
	MATERIAL.ANALOG : ("res://barkley2/resources/B2_Weapon/material/Analog.tres"),
	MATERIAL.ANTI_MATTER : ("res://barkley2/resources/B2_Weapon/material/Anti-Matter.tres"),
	MATERIAL.BLASTER : ("res://barkley2/resources/B2_Weapon/material/Blaster.tres"),
	MATERIAL.BLOOD : ("res://barkley2/resources/B2_Weapon/material/Blood.tres"),
	MATERIAL.BONE : ("res://barkley2/resources/B2_Weapon/material/Bone.tres"),
	MATERIAL.BRAIN : ("res://barkley2/resources/B2_Weapon/material/Brain.tres"),
	MATERIAL.BRASS : ("res://barkley2/resources/B2_Weapon/material/Brass.tres"),
	MATERIAL.BROKEN : ("res://barkley2/resources/B2_Weapon/material/Broken.tres"),
	MATERIAL.BRONZE : ("res://barkley2/resources/B2_Weapon/material/Bronze.tres"),
	MATERIAL.CANDY : ("res://barkley2/resources/B2_Weapon/material/Candy.tres"),
	MATERIAL.CARBON : ("res://barkley2/resources/B2_Weapon/material/Carbon.tres"),
	MATERIAL.CHITIN : ("res://barkley2/resources/B2_Weapon/material/Chitin.tres"),
	MATERIAL.CHOBHAM : ("res://barkley2/resources/B2_Weapon/material/Chobham.tres"),
	MATERIAL.CHROME : ("res://barkley2/resources/B2_Weapon/material/Chrome.tres"),
	MATERIAL.COBALT : ("res://barkley2/resources/B2_Weapon/material/Cobalt.tres"),
	MATERIAL.COPPER : ("res://barkley2/resources/B2_Weapon/material/Copper.tres"),
	MATERIAL.CRYSTAL : ("res://barkley2/resources/B2_Weapon/material/Crystal.tres"),
	MATERIAL.DAMASCUS : ("res://barkley2/resources/B2_Weapon/material/Damascus.tres"),
	MATERIAL.DENIM : ("res://barkley2/resources/B2_Weapon/material/Denim.tres"),
	MATERIAL.DIAMOND : ("res://barkley2/resources/B2_Weapon/material/Diamond.tres"),
	MATERIAL.DIGITAL : ("res://barkley2/resources/B2_Weapon/material/Digital.tres"),
	MATERIAL.DUAL : ("res://barkley2/resources/B2_Weapon/material/Dual.tres"),
	MATERIAL.FIBERGLASS : ("res://barkley2/resources/B2_Weapon/material/Fiberglass.tres"),
	MATERIAL.FOIL : ("res://barkley2/resources/B2_Weapon/material/Foil.tres"),
	MATERIAL.FRANCIUM : ("res://barkley2/resources/B2_Weapon/material/Francium.tres"),
	MATERIAL.FRANKINCENSE : ("res://barkley2/resources/B2_Weapon/material/Frankincense.tres"),
	MATERIAL.FUNGUS : ("res://barkley2/resources/B2_Weapon/material/Fungus.tres"),
	MATERIAL.GLASS : ("res://barkley2/resources/B2_Weapon/material/Glass.tres"),
	MATERIAL.GOLD : ("res://barkley2/resources/B2_Weapon/material/Gold.tres"),
	MATERIAL.GRASS : ("res://barkley2/resources/B2_Weapon/material/Grass.tres"),
	MATERIAL.IMAGINARY : ("res://barkley2/resources/B2_Weapon/material/Imaginary.tres"),
	MATERIAL.IRON : ("res://barkley2/resources/B2_Weapon/material/Iron.tres"),
	MATERIAL.ITANO : ("res://barkley2/resources/B2_Weapon/material/Itano.tres"),
	MATERIAL.JUNK : ("res://barkley2/resources/B2_Weapon/material/Junk.tres"),
	MATERIAL.LEAD : ("res://barkley2/resources/B2_Weapon/material/Lead.tres"),
	MATERIAL.LEATHER : ("res://barkley2/resources/B2_Weapon/material/Leather.tres"),
	MATERIAL.MARBLE : ("res://barkley2/resources/B2_Weapon/material/Marble.tres"),
	MATERIAL.MERCURY : ("res://barkley2/resources/B2_Weapon/material/Mercury.tres"),
	MATERIAL.MYRRH : ("res://barkley2/resources/B2_Weapon/material/Myrrh.tres"),
	MATERIAL.MYTHRIL : ("res://barkley2/resources/B2_Weapon/material/Mythril.tres"),
	MATERIAL.NANOTUBE : ("res://barkley2/resources/B2_Weapon/material/Nanotube.tres"),
	MATERIAL.NAPALM : ("res://barkley2/resources/B2_Weapon/material/Napalm.tres"),
	MATERIAL.NEON : ("res://barkley2/resources/B2_Weapon/material/Neon.tres"),
	MATERIAL.NICKEL : ("res://barkley2/resources/B2_Weapon/material/Nickel.tres"),
	MATERIAL.OBSIDIAN : ("res://barkley2/resources/B2_Weapon/material/Obsidian.tres"),
	MATERIAL.OFFAL : ("res://barkley2/resources/B2_Weapon/material/Offal.tres"),
	MATERIAL.ORB : ("res://barkley2/resources/B2_Weapon/material/Orb.tres"),
	MATERIAL.ORICHALCUM : ("res://barkley2/resources/B2_Weapon/material/Orichalcum.tres"),
	MATERIAL.ORIGAMI : ("res://barkley2/resources/B2_Weapon/material/Origami.tres"),
	MATERIAL.PEARL : ("res://barkley2/resources/B2_Weapon/material/Pearl.tres"),
	MATERIAL.PINATA : ("res://barkley2/resources/B2_Weapon/material/Pinata.tres"),
	MATERIAL.PLANTAIN : ("res://barkley2/resources/B2_Weapon/material/Plantain.tres"),
	MATERIAL.PLASTIC : ("res://barkley2/resources/B2_Weapon/material/Plastic.tres"),
	MATERIAL.PLATINUM : ("res://barkley2/resources/B2_Weapon/material/Platinum.tres"),
	MATERIAL.POLENTA : ("res://barkley2/resources/B2_Weapon/material/Polenta.tres"),
	MATERIAL.PORCELAIN : ("res://barkley2/resources/B2_Weapon/material/Porcelain.tres"),
	MATERIAL.ROTTEN : ("res://barkley2/resources/B2_Weapon/material/Rotten.tres"),
	MATERIAL.RUBBER : ("res://barkley2/resources/B2_Weapon/material/Rubber.tres"),
	MATERIAL.RUSTY : ("res://barkley2/resources/B2_Weapon/material/Rusty.tres"),
	MATERIAL.SALT : ("res://barkley2/resources/B2_Weapon/material/Salt.tres"),
	MATERIAL.SILK : ("res://barkley2/resources/B2_Weapon/material/Silk.tres"),
	MATERIAL.SILVER : ("res://barkley2/resources/B2_Weapon/material/Silver.tres"),
	MATERIAL.SINEW : ("res://barkley2/resources/B2_Weapon/material/Sinew.tres"),
	MATERIAL.SOILED : ("res://barkley2/resources/B2_Weapon/material/Soiled.tres"),
	MATERIAL.SOY : ("res://barkley2/resources/B2_Weapon/material/Soy.tres"),
	MATERIAL.STEEL : ("res://barkley2/resources/B2_Weapon/material/Steel.tres"),
	MATERIAL.STONE : ("res://barkley2/resources/B2_Weapon/material/Stone.tres"),
	MATERIAL.STUDDED : ("res://barkley2/resources/B2_Weapon/material/Studded.tres"),
	MATERIAL.TAXIDERMY : ("res://barkley2/resources/B2_Weapon/material/Taxidermy.tres"),
	MATERIAL.TIN : ("res://barkley2/resources/B2_Weapon/material/Tin.tres"),
	MATERIAL.TITANIUM : ("res://barkley2/resources/B2_Weapon/material/Titanium.tres"),
	MATERIAL.TUNGSTEN : ("res://barkley2/resources/B2_Weapon/material/Tungsten.tres"),
	MATERIAL.UNTAMONIUM : ("res://barkley2/resources/B2_Weapon/material/Untamonium.tres"),
	MATERIAL.WOOD : ("res://barkley2/resources/B2_Weapon/material/Wood.tres"),
	MATERIAL.YGGDRASIL : ("res://barkley2/resources/B2_Weapon/material/Yggdrasil.tres"),
	MATERIAL.ZINC : ("res://barkley2/resources/B2_Weapon/material/Zinc.tres"),
	}
## Old sprite sheet.  ## DEPRECATED
#const FRANKIE_GUNS_OLD := [ ## List of weapon sheets.
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns0.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns1.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns2.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns3.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns4.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns5.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns6.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns7.png"),
	#preload("res://barkley2/assets/b2_original/guns/FrankieGuns8.png"),
	#]
	
const TYPE_LIST : Dictionary[TYPE, String] = {
	TYPE.GUN_TYPE_ASSAULTRIFLE : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_ASSAULTRIFLE.tres"),
	TYPE.GUN_TYPE_BFG : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_BFG.tres"),
	TYPE.GUN_TYPE_CROSSBOW : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_CROSSBOW.tres"),
	TYPE.GUN_TYPE_DOUBLESHOTGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_DOUBLESHOTGUN.tres"),
	TYPE.GUN_TYPE_ELEPHANTGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_ELEPHANTGUN.tres"),
	TYPE.GUN_TYPE_FLAMETHROWER : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_FLAMETHROWER.tres"),
	TYPE.GUN_TYPE_FLAREGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_FLAREGUN.tres"),
	TYPE.GUN_TYPE_FLINTLOCK : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_FLINTLOCK.tres"),
	TYPE.GUN_TYPE_GATLINGGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_GATLINGGUN.tres"),
	TYPE.GUN_TYPE_HEAVYMACHINEGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_HEAVYMACHINEGUN.tres"),
	TYPE.GUN_TYPE_HUNTINGRIFLE : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_HUNTINGRIFLE.tres"),
	TYPE.GUN_TYPE_MACHINEPISTOL : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MACHINEPISTOL.tres"),
	TYPE.GUN_TYPE_MAGNUM : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MAGNUM.tres"),
	TYPE.GUN_TYPE_MINIGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MINIGUN.tres"),
	TYPE.GUN_TYPE_MITRAILLEUSE : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MITRAILLEUSE.tres"),
	TYPE.GUN_TYPE_MUSKET : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_MUSKET.tres"),
	TYPE.GUN_TYPE_PISTOL : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_PISTOL.tres"),
	TYPE.GUN_TYPE_REVOLVER : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_REVOLVER.tres"),
	TYPE.GUN_TYPE_REVOLVERSHOTGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_REVOLVERSHOTGUN.tres"),
	TYPE.GUN_TYPE_RIFLE : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_RIFLE.tres"),
	TYPE.GUN_TYPE_ROCKET : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_ROCKET.tres"),
	TYPE.GUN_TYPE_SHOTGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_SHOTGUN.tres"),
	TYPE.GUN_TYPE_SNIPERRIFLE : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_SNIPERRIFLE.tres"),
	TYPE.GUN_TYPE_SUBMACHINEGUN : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_SUBMACHINEGUN.tres"),
	TYPE.GUN_TYPE_TRANQRIFLE : ("res://barkley2/resources/B2_Weapon/type/GUN_TYPE_TRANQRIFLE.tres"),
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


## Code related to weapon creation, generation and fusion (maybe?).
#region Gun creation
# Check Drop("generate") line 396
## For now, luck stat plays no part in this
static func generate_gun( type := TYPE.GUN_TYPE_NONE, material := MATERIAL.NONE ) -> B2_Weapon:
	var wpn := B2_Weapon.new()
	
	## Pick weapon type if not specified
	if type != TYPE.GUN_TYPE_NONE:
		wpn.weapon_type = type
	else:
		var type_rand := randi_range(0,99)
		if type_rand < 80:
			wpn.weapon_type = RARITY_TYPE[RARITY.TRASH].pick_random()
		elif type_rand < 90:
			wpn.weapon_type = RARITY_TYPE[RARITY.MEH].pick_random()
		else:
			wpn.weapon_type = RARITY_TYPE[RARITY.RARE].pick_random()
	
	## Get the type resource
	wpn.type_data = weapon_type( wpn.weapon_type )
	
	## Set base name
	wpn.weapon_name = gun_names[ wpn.weapon_type ]
	## NOTE Missing some stuff. check scr_combat_weapons_buildName() line 33
	
	## Pick weapon material if not specified
	if material != MATERIAL.NONE:
		wpn.weapon_material = material
	else:
		var mat_rand := randi_range(0,99)
		if mat_rand < 60:
			wpn.weapon_material = RARITY_MATERIAL[RARITY.TRASH].pick_random()
		elif mat_rand < 80:
			wpn.weapon_material = RARITY_MATERIAL[RARITY.MEH].pick_random()
		elif mat_rand < 98:
			wpn.weapon_material = RARITY_MATERIAL[RARITY.RARE].pick_random()
		else:
			wpn.weapon_material = RARITY_MATERIAL[RARITY.GODAM].pick_random()
	
	## Get the material resource
	wpn.material_data = weapon_material( wpn.weapon_material )
	
	if wpn.type_data == null:
		push_warning( "Gun %s has no valid type." % wpn.get_full_name() )
	if wpn.material_data == null:
		push_warning( "Gun %s has no valid material." % wpn.get_full_name() )
	
	## Pick affixes
	var affix_rand := 0
	affix_rand = randi_range(0,99)
	if affix_rand < geneAffixChance:
		wpn.prefix1 = prefix1.pick_random()
		
	affix_rand = randi_range(0,99)
	if affix_rand < geneAffixChance:
		wpn.prefix2 = prefix2.pick_random()
		
	affix_rand = randi_range(0,99)
	if affix_rand < geneAffixChance:
		wpn.suffix = suffix.pick_random()
		
	## Set base stats (Random for now). This should be modified by the material, type, and affixes. ## WARNING It isnt at this moment 28/02/25
	wpn.att = randi_range(1,9)
	wpn.spd = randi_range(1,9)
	#wpn.lck = randi_range(1,9) ## TEMP
	wpn.acc = randi_range(1,9)
		
	## Add graphic data, textures, colors, etc.
	weapon_graphics( wpn )
		
	return wpn
	
## Assign a texture, color, shit like that. Simulates scr_combat_weapons_applyGraphic()
static func weapon_graphics( wpn : B2_Weapon ) -> void:
	## scr_combat_weapons_applyGraphic
	
	## Hud Image
	var first_atlas 	:= AtlasTexture.new()
	first_atlas.atlas = FRANKIE_GUNS
	
	first_atlas.region.size.x = GUNWIDTH
	first_atlas.region.size.y = GUNHEIGHT
	first_atlas.region.position.x = wpn.weapon_material * GUNWIDTH
	first_atlas.region.position.y = wpn.weapon_type * GUNHEIGHT
	
	wpn.weapon_hud_sprite = first_atlas

## this... is a mess. simulates the script scr_combat_weapons_applyMaterial()
static func weapon_material( mat : MATERIAL ) -> B2_WeaponMaterial:
	var m := load( MATERIAL_LIST[mat] ) as B2_WeaponMaterial
	return m

## this... is a mess. simulates the script scr_combat_weapons_applyType()
static func weapon_type( typ : TYPE ) -> B2_WeaponType:
	var t = load( TYPE_LIST[typ] ) as B2_WeaponType
	return t

#endregion

## Code related to adding guns, taking guns and stuff like that.
#region Gun management

## Add gun to inventory
static func add_gun( add_to_bandolier := true, type := TYPE.GUN_TYPE_NONE, material := MATERIAL.NONE ) -> void: ## TODO
	if B2_Playerdata.bandolier.size() < BANDOLIER_SIZE and add_to_bandolier:
		B2_Playerdata.bandolier.append( generate_gun(type, material) )
	elif B2_Playerdata.gun_bag.size() < GUNBAG_SIZE:
		B2_Playerdata.gun_bag.append( generate_gun(type, material) )
	else:
		push_warning( "Bandolier and Gunbag full." )
	
## remove specific gun from inventory
static func remove_gun( wpn : B2_Weapon ) -> void:
	B2_Playerdata.bandolier.erase( wpn )
	B2_Playerdata.gun_bag.erase( wpn )
	## TODO manage bandolier and gun bag.
	
static func clear_guns() -> void:
	B2_Playerdata.bandolier.clear()
	B2_Playerdata.gun_bag.clear()
	
static func get_bandolier() -> Array[B2_Weapon]:
	return B2_Playerdata.bandolier
	
static func get_gunbag() -> Array[B2_Weapon]:
	return B2_Playerdata.gun_bag
	
static func next_band_gun() -> void:
	B2_Playerdata.selected_gun += 1
	# push_warning("DEBUG disabled")
	
static func prev_band_gun() -> void:
	B2_Playerdata.selected_gun -= 1
	# push_warning("DEBUG disabled")
	
static func get_current_gun() -> B2_Weapon:
	if B2_Playerdata.bandolier.is_empty():
		push_warning("Bandolier is empty.")
		return null
	else:
		if B2_Playerdata.bandolier.size() <= B2_Playerdata.selected_gun:
			push_error("Array overflow")
			return null
		else:
			return B2_Playerdata.bandolier[ B2_Playerdata.selected_gun ]
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
