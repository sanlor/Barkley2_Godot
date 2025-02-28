extends Resource
class_name B2_Weapon
## Parent class for all weapons.
## Holds a list of stats, attack types and skills
# Check Gun(), GunMap()

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
	}
enum GROUP{ ## Weapon groups. no idea how its used.
	AUTOMATIC,
	MOUNTED,
	PISTOLS,
	PROJECTILE,
	RIFLES,
	SHOTGUNS,
}
enum EFFECT{ DAMAGE, RECOVERY }

@export var weapon_name		:= "Unnamed Weapon"
@export var weapon_type 	:= TYPE.GUN_TYPE_PISTOL
@export var weapon_group 	:= GROUP.PISTOLS
@export var weapon_effect 	:= EFFECT.DAMAGE 		## Damage effect
@export var projectile		: PackedScene			## Projectile for Ranged type

@export var att					:= 3.0
@export var spd					:= 3.0
@export var lck					:= 1.0
@export var acc					:= 0.03 ## Lower is better
@export var damage_variation 	:= 0.2 

@export var max_ammo			:= 10
var curr_ammo					:= max_ammo

@export var max_action			:= 100
var curr_action					:= 0

@export var attack_cost			:= 35			## How many action point cost for reloading this weapon

var weapon_xp					:= 0			## Unlocks new skill when you use this weapon for long enough

#@export var normal_attack	: CombatComponent				## Normal attack
#@export var skill_list		: Dictionary[CombatSkill, int] 	## List of attacks, with the EXP necessary to unlock it

## Used for menus
var is_selected := false

func _init() -> void:
	curr_ammo = max_ammo

## check if 
#func has_avaiable_skills() -> bool:
	#for s in skill_list:
		#if s:
			#if s.skill_cost >= curr_action:
				#return true
	#return false
