extends Resource
class_name B2_Gun_Fuse
## Class that handles some of the gun breeding / fuse.
# There is a file called "material.csv" on the game files, that had a bunch of atomic info about materials, but the way it was stores was terrible. Need to convert it to json os something like that

enum {NAME,INFO1,INFO2} # <- no idea what info1 and info2 are yet.
const MATERIAL := "res://barkley2/resources/B2_Weapon/material_table.json" ## Material periodic table (converted from csv to json)
## NOTE check "res://barkley2/resources/B2_Weapon/periodic.png"
# Also, fucking check scr_combat_weapons_fusion_material(), dumbass.
## INFO as of right now, I have no idea what "diatomic" means. 

static var material_table : Dictionary

static func load_material_table() -> void:
	var file := FileAccess.open( "res://barkley2/resources/B2_Weapon/material_table.json", FileAccess.READ )
	material_table = JSON.to_native( JSON.parse_string( file.get_as_text() ) )
	assert( not material_table.is_empty(), "Material table invalid." )

static func get_material_data( pos : Vector2 ) -> Array:
	if not material_table:
		load_material_table()
	if not material_table.has(pos):
		push_warning("Invalid position for the material lists '%s'. Bitch ass. Returning some invalid data." % pos)
	return material_table.get( pos, ["invalid", -999, -999] )

static func fuse_material( material_1 : B2_Gun.MATERIAL, material_2 : B2_Gun.MATERIAL ) -> B2_Gun.MATERIAL:
	if not material_table:
		load_material_table()
	
	## CRITICAL fix this.
	return B2_Gun.MATERIAL.NONE
