extends Resource
class_name B2_Gun_Fuse
## Class that handles some of the gun breeding / fuse.
# There is a file called "material.csv" on the game files, that had a bunch of atomic info about materials, but the way it was stores was terrible. Need to convert it to json os something like that

const DEBUG := false

enum {ROW,COLUMN,ELECTRONS,ATOMIC_WEIGHT} # <- no idea what info1 and info2 are yet.
const MATERIAL := preload("res://barkley2/resources/B2_Weapon/material_table.json") ## Material periodic table (converted from csv to json)
## NOTE check "res://barkley2/resources/B2_Weapon/periodic.png"
# Also, fucking check scr_combat_weapons_fusion_material(), dumbass.
## INFO as of right now, I have no idea what "diatomic" means. 

## List of exceptions for material fusing.
# check scr_combat_weapons_fusion_material line 194
enum {EXCEPTION_A,EXCEPTION_B,EXCEPTION_RESULT}
const MATERIAL_EXCEPIONS := [
	# Studded
	["Studded", "Studded", "Studded"],
	["Leather", "Soiled", "Studded"],
	["Leather", "Broken", "Studded"],
	["Leather", "Rusty", "Studded"],
	["Leather", "Aluminum", "Studded"],
	["Leather", "Aluminium", "Studded"],
	["Leather", "Titanium", "Studded"],
	["Leather", "Chrome", "Studded"],
	["Leather", "Iron", "Studded"],
	["Leather", "Cobalt", "Studded"],
	["Leather", "Nickel", "Studded"],
	["Leather", "Copper", "Studded"],
	["Leather", "Zinc", "Studded"],
	# Other
	["Carbon", "Nanotube", "Damascus"],
	["Copper", "Zinc", "Brass"],
	["Broken", "Junk", "Mythril"],
]

# List of diatomic materials
const MATERIALDIATOMICLIST := [
	"Candy",
	"Mythril",
	"Rusty",
	"Junk",
	"Studded",
	"Brass",
	"Damascus",
]

# Set volatility levels so electrons drop
const MATERIALVOLATILITY := [ # check scr_combat_weapons_fusion_material line 115
	2, 2, 3, 1, 1, 2, 1
]
const SETTINGFUSEWEIGHT := 0.75 ## Used for stat fusing

static func get_material_data( material_name : String ) -> Array:
	if not MATERIAL.data.has(material_name):
		push_warning("Invalid naterial name for the material lists '%s'. Bitch ass. Returning some invalid data." % material_name)
	return MATERIAL.data.get( material_name, [0,0, -999, -999] )

## Mix 2 materials into 1. Uses a lot of GML code. Seems to work somehow???
# 28/09/25 - it does not. it only generates 3 or 4 types or materials. something went wrong with my implementation...
# It only generates 3D printed, Neon and Dual materials. They are the heaviest materials, it seems.
static func fuse_material( material_1 : B2_Gun.MATERIAL, material_2 : B2_Gun.MATERIAL ) -> B2_Gun.MATERIAL:
	if DEBUG: print_rich( "[bgcolor=white][color=red]fuse_material: Begin[/color][/bgcolor]" )
	
	# Index some arrays for those stupid checks.
	var materialBoxV 			:= {} # Atomic Weight
	var materialBoxN 			:= {} # Material name
	var materialBoxE			:= {} # Electons
	var materialBoxD			:= {} ## NOTE this seems to be unused.
	var materialBoxDiatomic 	:= {} # Is material Diatomic
	
	## Those +1 are because position "0" does not exist.
	for r in 18 + 1:		# Row
		for c in 7 + 1:		# Column
			materialBoxV[ Vector2(r,c) ] = -999
			materialBoxDiatomic[ Vector2(r,c) ] = 0
			
	for mat in MATERIAL.data: # Indexes the materils as row / column.
		var pos := Vector2( MATERIAL.data[mat][ROW], MATERIAL.data[mat][COLUMN] )
		materialBoxV[ pos ] = MATERIAL.data[mat][ATOMIC_WEIGHT]
		materialBoxE[ pos ] = MATERIAL.data[mat][ELECTRONS]
		materialBoxN[ pos ] = mat
		
		if MATERIALDIATOMICLIST.has(mat):
			materialBoxDiatomic[ pos ] = 1
			
	## Copying some code from GML
	# get ready for some spaghetti
	var mat_1_data := get_material_data( B2_Gun.MATERIAL_NAMES.get(material_1, B2_Gun.MATERIAL.NONE) )
	var mat_2_data := get_material_data( B2_Gun.MATERIAL_NAMES.get(material_2, B2_Gun.MATERIAL.NONE) )
	
	# vvv2 seems to be the "data" from the pediodic table. Going to ignore this.
	# nope, vvv2 seems important. Im glad they chose such a GOOD name for that variable.
	var vvv2 = ( mat_1_data[ATOMIC_WEIGHT] + mat_2_data[ATOMIC_WEIGHT] ) / 2 # The "mean value" for the atomic weight.
	# "mean value" seems to be just the average?
	
	var meanR; var meanC; var elecC; var elecR; var finalR; var finalC;
	var electrons; var didSelf;
	
	meanR 	= -1
	meanC 	= -1
	elecR 	= -1
	elecC 	= -1
	finalR 	= -1		## Final row selected
	finalC 	= -1		## Final column selected
	didSelf = +0		## Both guns have the same material
	
	# Check if both materials are the same.
	if mat_1_data[ROW] == mat_2_data[ROW] and mat_1_data[COLUMN] == mat_2_data[COLUMN]:
		if DEBUG: print( "fuse_material: Both materials are the same." )
		finalR = mat_1_data[ROW]
		finalC = mat_1_data[COLUMN]
		didSelf = 1
	
	# Exception table
	## NOTE 28/09/25 Seems that this is causing issues. Most materials are falling into the exception rule. <- this is incorrect. exception rules has nothing to do with the bug.
	if finalR == -1:
		# global.materialBoxN seems to be the material name.
		var n0 = B2_Gun.MATERIAL_NAMES.get(material_1, B2_Gun.MATERIAL.NONE) # Material name
		var n1 = B2_Gun.MATERIAL_NAMES.get(material_2, B2_Gun.MATERIAL.NONE) # material name
		for i : Array in MATERIAL_EXCEPIONS:
				# 'i' is an array wih 3 names
			var v0 = i[EXCEPTION_A] # Maybe "v" means value?
			var v1 = i[EXCEPTION_B]
			if n0 == v0 && n1 == v1 or n0 == v1 && n1 == v0:
				if DEBUG: print( "fuse_material: hit a material exception." )
				var v2 		:= "" # name the an mateiral created during the exception check.
				var rowNew 	:= 0	# Row for the exception material
				var colNew 	:= 0	# Column for the exception material
					
				v2 = i[EXCEPTION_RESULT] # GML is so weird. you dont need to actually declare a variable?
				rowNew = get_material_data( v2 )[ROW]
				colNew = get_material_data( v2 )[COLUMN]
				elecR = rowNew;
				elecC = colNew;
				finalR = rowNew;
				finalC = colNew;
				didSelf = 1;
				if DEBUG: print( "fuse_material: Material exception - %s selected." % materialBoxN[ Vector2(finalR, finalC) ] )
				break ## Is this needed? I added this.
				if DEBUG: print( "fuse_material: Material exception selection finished." )

	## Get mean value
	# NOTE WTF is a mean value???
	if finalR == -1:
		## NOTE WTF is this loop doing?
		# This seems to select the LAST LIGHT material on the list. it tends to select Mercury, Gold or Imaginary materials.
		# This seems wrong. The original game probably uses some special order for the array.
		##		Looks like the array is stored left to right, top to bottom. Lets try to modify this loop so loof for the LAST LIGHT material using the row / column as a parameter.
		var new_vvv2 := 0.0
		for i in MATERIAL.data:
			var int0 : float = MATERIAL.data[i][ATOMIC_WEIGHT]
			if vvv2 >= int0:
				#if MATERIAL.data[i][ROW] > meanR : 				## Added this on 28/09/25
				#	if MATERIAL.data[i][COLUMN] > meanC:			## Added this on 28/09/25
				if int0 > new_vvv2:
					new_vvv2 = int0
					meanR = MATERIAL.data[i][ROW]
					meanC = MATERIAL.data[i][COLUMN]
					# print( "vvv2 %s - int0 %s - %s" % [vvv2, int0, Vector2i(meanR, meanC)] )

		## If you have enough electrons, drop down
		#if meanR + 1 < 7: # Why it was + 1?
		if meanR < 7:
			if DEBUG: print( "fuse_material: Dropping eletrons. (was %s)" % materialBoxN[ Vector2(meanR, meanC)] )
			if materialBoxV[ Vector2(meanR + 1, meanC)] != -999:
				var v = MATERIALVOLATILITY[meanR]; # volitility level
				electrons = mat_1_data[ELECTRONS] + mat_2_data[ELECTRONS]
				if (electrons / v) != round(electrons / v):
					elecR = meanR + 1;
					#elecR = meanR;
					elecC = meanC;

		if elecR == -1: finalR = meanR; finalC = meanC;
		else: finalR = elecR; finalC = elecC;
	
	# If it's diatomic, go to heaviest non diatomic material that weighs less than the target
	if didSelf == 0:
		if materialBoxDiatomic[ Vector2(finalR, finalC) ] == 1:
			if DEBUG: print( "fuse_material: Diatomic selection started. Curr pos is %s (%s)" % [Vector2(finalR, finalC), materialBoxN[ Vector2(finalR, finalC) ] ] )
			
			## NOTE This seems a weird way to do this check. looks like its going to go OOB easily.
			#while materialBoxDiatomic[ Vector2(finalR, finalC) ] == 1:
			#	ind = ds_list_find_index(global.materialName, global.materialBoxN[finalR, finalC]);
			#	finalR = ds_list_find_value(global.materialRow, ind - 1);
			#	finalC = ds_list_find_value(global.materialCol, ind - 1);
			
			var curr_weight		: int = materialBoxV[ Vector2(finalR, finalC) ]
			var new_mat 		: String = ""
			var new_mat_weight 	: int = 9999
			for i in MATERIAL.data:
				if MATERIAL.data[i][ATOMIC_WEIGHT] > curr_weight and MATERIAL.data[i][ATOMIC_WEIGHT] < new_mat_weight:
					new_mat = i
					new_mat_weight = MATERIAL.data[i][ATOMIC_WEIGHT]
					if DEBUG: print_rich( "fuse_material: Diatomic - [color=green]%s[/color] selected." % i )
					break # this seems necessary
				else:
					if DEBUG: print_rich( "fuse_material: Diatomic - %s [b]NOT[/b] selected." % i )
			
			if new_mat:
				finalR = MATERIAL.data[new_mat][ROW]
				finalC = MATERIAL.data[new_mat][COLUMN]
				if DEBUG: print( "fuse_material: Diatomic selection finalized." )
			else:
				push_error("Issue with Material fusing (Diatomic). Fix this.")
			
	if DEBUG: print( "fuse_material: Material %s created." % materialBoxN[ Vector2(finalR, finalC) ])
	var final_material : B2_Gun.MATERIAL = B2_Gun.MATERIAL_NAMES.find_key( materialBoxN[ Vector2(finalR, finalC) ] )
	
	if DEBUG: print_rich( "[bgcolor=white][color=blue]fuse_material: Finish.[/color][/bgcolor]" )
	# wow, what a mess, huh?
	return final_material

## check the stats for 2 guns and fuse them into one. will apply the changes directly to the child gun.
static func fuse_stats( top_gun : B2_Weapon, bottom_gun : B2_Weapon, child_gun : B2_Weapon ) -> void:
	var gunStatDivisionBonus 	:= 25 		# was 15
	var gunPowerRatio 			:= 1.2 		# was 1.2
	var gunNoisePercent 		:= .05
	
	# Grabbed values
	var fga := top_gun		## Love these 3 leter variables!
	var fgb := bottom_gun	## Love these 3 leter variables!
	
	## Declaring some variables.
	## So stupid. This creates an array to with the stat for each weapon. Fuck it, just going to copy and paste code now.
	# Grabbed values
	var gunPower 		:= [top_gun.get_pow(),		bottom_gun.get_pow()]
	var gunROF 			:= [top_gun.get_spd(),		bottom_gun.get_spd()]		# Rate of fire?
	var gunAmmo 		:= [top_gun.get_amm(),		bottom_gun.get_amm()]
	var gunAffix 		:= [top_gun.get_afx(),		bottom_gun.get_afx()]
	var gunWeight 		:= [top_gun.get_wgt(),		bottom_gun.get_wgt()]

	var gunPowerMod 	:= [
		top_gun.get_pow_mod() 	+ top_gun.get_pow_max_mod() / 2, 
		bottom_gun.get_pow_mod() 	+ bottom_gun.get_pow_max_mod() / 2
		]
	var gunROFMod 		:= [top_gun.get_spd_mod(),	bottom_gun.get_spd_mod()]
	var gunAmmoMod 		:= [top_gun.get_amm_mod(),	bottom_gun.get_amm_mod()]
	var gunAffixMod 	:= [top_gun.get_afx_mod(),	bottom_gun.get_afx_mod()]
	var gunWeightMod 	:= [top_gun.get_wgt_mod(),	bottom_gun.get_wgt_mod()]
	
	# Generate totals, priorities, bonus
	var gunTotal 		:= [ 
		gunPower[0] + gunROF[0] + gunAmmo[0] + gunAffix[0], 
		gunPower[1] + gunROF[1] + gunAmmo[1] + gunAffix[1],
		] # priority
	var gunRatio 		:= [ 0.5, 0.5 ] ## Default ratio, i guess?
	var gunRatioPower 	:= [ 0.5, 0.5 ] ## Default ratio, i guess?

	var gunPowerTotal 	:= [ gunPower[0] * gunPowerMod[0], gunPower[1] * gunPowerMod[1] ]
	var gunROFTotal 	:= [ gunROF[0] * gunROFMod[0], gunROF[1] * gunROFMod[1] ]
	var gunAmmoTotal	:= [ gunAmmo[0] * gunAmmoMod[0], gunAmmo[1] * gunAmmoMod[1] ]
	var gunAffixTotal	:= [ gunAffix[0] * gunAffixMod[0], gunAffix[1] * gunAffixMod[1] ]
	var gunWeightTotal	:= [ gunWeight[0] * gunWeightMod[0], gunWeight[1] * gunWeightMod[1] ]

	var gunPowerBonus	:= [ gunPowerTotal[0] / gunStatDivisionBonus, gunPowerTotal[1] / gunStatDivisionBonus ] # total divided by bonus division
	var gunROFBonus		:= [ gunROFTotal[0] / gunStatDivisionBonus, gunROFTotal[1] / gunStatDivisionBonus ]
	var gunAmmoBonus	:= [ gunAmmoTotal[0] / gunStatDivisionBonus, gunAmmoTotal[1] / gunStatDivisionBonus ]
	var gunAffixBonus	:= [ gunAffixTotal[0] / gunStatDivisionBonus, gunAffixTotal[1] / gunStatDivisionBonus ]
	var gunWeightBonus	:= [ gunWeightTotal[0] / gunStatDivisionBonus, gunWeightTotal[1] / gunStatDivisionBonus ]

	# Do ratios
	gunRatio[0] = gunTotal[0] / (gunTotal[0] + gunTotal[1]) ## Apply correct ratio? Ratio for what?
	gunRatio[1] = gunTotal[1] / (gunTotal[0] + gunTotal[1]);
	
	# Do power ratios
	if gunRatio[0] == gunRatio[1]:
		gunRatioPower[0] = 0.5
		gunRatioPower[1] = 0.5
	else:
		if gunRatio[0] > gunRatio[1]:
			gunRatioPower[0] = 1 - pow(gunRatio[1], gunPowerRatio)
		else:
			gunRatioPower[0] = pow(gunRatio[0], gunPowerRatio)
		gunRatioPower[1] = abs(gunRatioPower[0] - 1)
	
	var ratio = gunRatioPower[0]; # <- WTF doest this do ????
	
	## I asume that this should be a float? Im so glad that GML allows such a sloppy code. 
	var gunPowerAverage 	: float = (gunPower[0] * gunRatioPower[0]) + (gunPower[1] * gunRatioPower[1]);
	var gunROFAverage 		: float = (gunROF[0] * gunRatioPower[0]) + (gunROF[1] * gunRatioPower[1]);
	var gunAmmoAverage 		: float = (gunAmmo[0] * gunRatioPower[0]) + (gunAmmo[1] * gunRatioPower[1]);
	var gunAffixAverage 	: float = (gunAffix[0] * gunRatioPower[0]) + (gunAffix[1] * gunRatioPower[1]);
	var gunWeightAverage 	: float = (gunWeight[0] * gunRatioPower[0]) + (gunWeight[1] * gunRatioPower[1]);
	
	# bonus times the other power ratio
	var gunPowerGain 		: float = (gunPowerBonus[0] * gunRatioPower[1]) + (gunPowerBonus[1] * gunRatioPower[0]);
	var gunROFGain 			: float = (gunROFBonus[0] * gunRatioPower[1]) + (gunROFBonus[1] * gunRatioPower[0]);
	var gunAmmoGain 		: float = (gunAmmoBonus[0] * gunRatioPower[1]) + (gunAmmoBonus[1] * gunRatioPower[0]);
	var gunAffixGain 		: float = (gunAffixBonus[0] * gunRatioPower[1]) + (gunAffixBonus[1] * gunRatioPower[0]);
	var gunWeightGain 		: float = (gunWeightBonus[0] * gunRatioPower[1]) + (gunWeightBonus[1] * gunRatioPower[0]);
	
	# New total
	var gunPowerNew			: float = gunPowerAverage + gunPowerGain;
	var gunROFNew			: float = gunROFAverage + gunROFGain;
	var gunAmmoNew 			: float = gunAmmoAverage + gunAmmoGain;
	var gunAffixNew			: float = gunAffixAverage + gunAffixGain;
	var gunWeightNew		: float = gunWeightAverage + gunWeightGain + SETTINGFUSEWEIGHT
	var gunTotalWorkingNew	: float = gunPowerNew + gunROFNew + gunAmmoNew + gunAffixNew; # + gunWeightNew;
	
	# NOISE
	var gunPowerNoise		: float = max(gunPower[0], gunPower[1]) * gunNoisePercent;
	var gunROFNoise			: float = max(gunROF[0], gunROF[1]) * gunNoisePercent;
	var gunAmmoNoise		: float = max(gunAmmo[0], gunAmmo[1]) * gunNoisePercent;
	var gunAffixNoise		: float = max(gunAffix[0], gunAffix[1]) * gunNoisePercent;
	var gunWeightNoise		: float = max(gunWeight[0], gunWeight[1]) * gunNoisePercent;
	
	# RANDOM
	var gunPowerNoiseEffect		: float = randf_range(0.0,gunPowerNoise) 	* [1, -1].pick_random()
	var gunROFNoiseEffect		: float = randf_range(0.0,gunROFNoise) 		* [1, -1].pick_random()
	var gunAmmoNoiseEffect		: float = randf_range(0.0,gunAmmoNoise) 	* [1, -1].pick_random()
	var gunAffixNoiseEffect		: float = randf_range(0.0,gunAffixNoise) 	* [1, -1].pick_random()
	var gunWeightNoiseEffect	: float = randf_range(0.0,gunWeightNoise) # * choose(1, -1);
	
	# Noise total
	var gunPowerNoiseTotal	: float = gunPowerNew + gunPowerNoiseEffect;
	var gunROFNoiseTotal	: float = gunROFNew + gunROFNoiseEffect;
	var gunAmmoNoiseTotal	: float = gunAmmoNew + gunAmmoNoiseEffect;
	var gunAffixNoiseTotal	: float = gunAffixNew + gunAffixNoiseEffect;
	var gunWeightNoiseTotal	: float = gunWeightNew + gunWeightNoiseEffect;
	
	# GZ ADD
	var gunTotalNoiseless	: float = gunPowerNew + gunROFNew + gunAmmoNew + gunAffixNew;
	# GZ NEW WEIGHT
	gunWeightNoiseTotal = max(gunWeight[0], gunWeight[1]);
	if gunTotal[0] > gunTotal[1]:
		gunWeightNoiseTotal += fga.generation * SETTINGFUSEWEIGHT;
	else:
		gunWeightNoiseTotal += fgb.generation * SETTINGFUSEWEIGHT;

	var gunTotalFinal := gunPowerNoiseTotal + gunROFNoiseTotal + gunAmmoNoiseTotal + gunAffixNoiseTotal + gunWeightNoiseTotal;
	
	## END OF THE CODE DUMP.
	# Now, how do I use this in my code...?
	
	child_gun.weapon_stats.sPower = gunPowerNoiseTotal
	child_gun.weapon_stats.sSpeed = gunROFNoiseTotal
	child_gun.weapon_stats.sAmmo = int(gunAmmoNoiseTotal)
	child_gun.weapon_stats.sAffix = gunAffixNoiseTotal
	child_gun.weapon_stats.sWeight = gunWeightNoiseTotal
	#@warning_ignore("narrowing_conversion")
	#child_gun.pts = gunPowerNoiseTotal + gunROFNoiseTotal + gunAmmoNoiseTotal + gunAffixNoiseTotal
	
	## TODO feels like this is missing something...
	
# Check scr_combat_weapons_fusion_affix()
# Check scr_combat_weapons_fusion_affixdb()
# Check scr_combat_weapons_fusion_affixhood()
# https://learn.genetics.utah.edu/content/basics/patterns/
static func fuse_affix( top_gun : B2_Weapon, bottom_gun : B2_Weapon, child_gun : B2_Weapon ) -> void:
	# OK, so this code is way, way too confusing. no idea what its exacly doing, but I got the gist of it.
	# No idea what "aGenePenchant" is doing. I guess it applies some kind of preference for genes / affixes?
	var compare_empty := func(afx1 : String,afx2 : String): return afx1.is_empty() and afx2.is_empty()
	var return_dominant_affix := func(afx1 : String,afx2 : String):
		if afx1.is_empty():			return afx2
		elif afx2.is_empty():		return afx1
		else:						return [afx1,afx2].pick_random() ## both guns have affixes. return a random one.
	
	## Reset suffixes
	child_gun.prefix1 	= ""
	child_gun.prefix2 	= ""
	child_gun.suffix 	= ""
	
	## Both guns do not have prefix 1.
	if compare_empty.call( top_gun.prefix1, bottom_gun.prefix1 ):
		if randf() < 0.15:
			child_gun.prefix1 = B2_Gun.prefix1.keys().pick_random()
			child_gun.afx_count += 1
	else: child_gun.prefix1 = return_dominant_affix.call( top_gun.prefix1, bottom_gun.prefix1 ); child_gun.afx_count += 1
			
	## Both guns do not have prefix 2.
	if compare_empty.call( top_gun.prefix2, bottom_gun.prefix2 ):
		if randf() < 0.15:
			child_gun.prefix2 = B2_Gun.prefix2.keys().pick_random()
			child_gun.afx_count += 1
	else: child_gun.prefix2 = return_dominant_affix.call( top_gun.prefix2, bottom_gun.prefix2 ); child_gun.afx_count += 1
	
	## Both guns do not have suffix.
	if compare_empty.call( top_gun.suffix, bottom_gun.suffix ):
		if randf() < 0.15:
			child_gun.suffix = B2_Gun.suffix.keys().pick_random()
			child_gun.afx_count += 1
	else: child_gun.suffix = return_dominant_affix.call( top_gun.suffix, bottom_gun.suffix ); child_gun.afx_count += 1
