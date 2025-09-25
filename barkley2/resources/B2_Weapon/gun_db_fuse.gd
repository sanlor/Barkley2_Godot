extends Resource
class_name B2_Gun_Fuse
## Class that handles some of the gun breeding / fuse.
# There is a file called "material.csv" on the game files, that had a bunch of atomic info about materials, but the way it was stores was terrible. Need to convert it to json os something like that

enum {ROW,COLUMN,ELECTRONS,ATOMIC_WEIGHT} # <- no idea what info1 and info2 are yet.
const MATERIAL := preload("res://barkley2/resources/B2_Weapon/material_table.json") ## Material periodic table (converted from csv to json)
## NOTE check "res://barkley2/resources/B2_Weapon/periodic.png"
# Also, fucking check scr_combat_weapons_fusion_material(), dumbass.
## INFO as of right now, I have no idea what "diatomic" means. 

## List of exceptions for material fusing.
# check scr_combat_weapons_fusion_material line 194
enum {EXCEPTION_A,EXCEPTION_B,EXCEPTION_RESULT}
const MATERIAL_EXCEPIONS := [
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

static func get_material_data( material_name : String ) -> Array:
	if not MATERIAL.data.has(material_name):
		push_warning("Invalid naterial name for the material lists '%s'. Bitch ass. Returning some invalid data." % material_name)
	return MATERIAL.data.get( material_name, [0,0, -999, -999] )

static func fuse_material( material_1 : B2_Gun.MATERIAL, material_2 : B2_Gun.MATERIAL ) -> B2_Gun.MATERIAL:
	## Copying some code from GML
	# get ready for some spaghetti
	var mat_1_data := get_material_data(material_1)
	var mat_2_data := get_material_data(material_2)
	
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
		finalR = mat_1_data[ROW]
		finalC = mat_1_data[COLUMN]
		didSelf = 1
	
	# Exception table
	if finalR == -1:
		# global.materialBoxN seems to be the material name.
			var n0 = B2_Gun.MATERIAL_NAMES.get(material_1, B2_Gun.MATERIAL.NONE) # Material name
			var n1 = B2_Gun.MATERIAL_NAMES.get(material_2, B2_Gun.MATERIAL.NONE) # material name
			for i : Array in MATERIAL_EXCEPIONS:
				# 'i' is an array wih 3 names
				var v0 = i[EXCEPTION_A] # Maybe "v" means value?
				var v1 = i[EXCEPTION_B]
				if n0 == v0 && n1 == v1 or n0 == v1 && n1 == v0:
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
					break ## Is this needed? I added this.
	
	## Get mean value
	# NOTE WTF is a mean value???
	if finalR == -1:
		for (i = 0; i < ds_list_size(global.materialValue); i += 1)
		{
			int0 = ds_list_find_value(global.materialValue, i);
			if (vvv2 >= int0)
			{
				meanR = ds_list_find_value(global.materialRow, i);
				meanC = ds_list_find_value(global.materialCol, i);
			}
		}

		## If you have enough electrons, drop down
		if (meanR + 1 < 7)
		{
			if (global.materialBoxV[meanR + 1, meanC] != -999)
			{
				v = global.materialVolatility[meanR]; //volitility level
				electrons = global.materialBoxE[r0, c0] + global.materialBoxE[r1, c1];
				if ((electrons / v) != round(electrons / v))
				{
					elecR = meanR + 1;
					elecC = meanC;
				}
			}
		}

		if (elecR == -1) { finalR = meanR; finalC = meanC; }
		else { finalR = elecR; finalC = elecC; }
	}
	
	## CRITICAL fix this.
	return B2_Gun.MATERIAL.NONE
