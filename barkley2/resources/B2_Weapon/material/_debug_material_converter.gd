@tool
extends EditorScript

var c := {
	"c_aqua" :	  		16776960,
	"c_black" :	  		0,
	"c_blue" :	  		16711680,
	"c_dkgray" :	  	4210752,
	"c_fuchsia" :	  	16711935,
	"c_gray" :	  		8421504,
	"c_green" :	  		32768,
	"c_lime" :	  		65280,
	"c_ltgray" :	  	12632256,
	"c_maroon" :	  	128,
	"c_navy" :	  		8388608,
	"c_olive" :	  		32896,
	"c_orange" :	  	4235519,
	"c_purple" :	  	8388736,
	"c_red" :	  		255,
	"c_silver" :	  	12632256,
	"c_teal":	  		8421376,
	"c_white" :	  		16777215,
	"c_yellow" :	  	65535,
}

const GUN_MATERIAL_DB 	= preload("res://barkley2/resources/B2_Weapon/gun_material_db.json")
const MATERIAL_FOLDER 		:= "res://barkley2/resources/B2_Weapon/material/"

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
#func _ready() -> void:
	var missing := []
	for mat : String in  GUN_MATERIAL_DB.data:
		#if mat == "3D Printed": 	mat = "PRINTED"
		#if mat == "Anti-Matter": 	mat = "ANTI_MATTER"
		var my_enum : B2_Gun.MATERIAL = B2_Gun.MATERIAL.get( mat.to_upper(), B2_Gun.MATERIAL.NONE )
		if my_enum != null:
			if my_enum == B2_Gun.MATERIAL.NONE:
				print( mat )
				
			var my_mat := B2_WeaponMaterial.new()
			#my_mat.material = my_enum
			
			for data : String in GUN_MATERIAL_DB.data[mat]:
				if data in my_mat:
					var d : String = GUN_MATERIAL_DB.data[mat][data]
					if d.is_valid_float() or d.is_valid_int():
						my_mat.set( data, float(d) )
					else:
						if c.has( d ):
							d = load("res://barkley2/autoloads/gamedata.gd").just_convert_gamemaker_color_to_hex_already( c[d] ).to_html()
						if d.count(",") == 2:
							var split = d.split(",")
							d = Color.from_rgba8( int(split[0]), int(split[1]), int(split[2]), 255 ).to_html()
						my_mat.set( data, str(d) )
				else:
					if not missing.has(data):
						missing.append( data )
			
			ResourceSaver.save(my_mat, MATERIAL_FOLDER + mat + ".tres", )
		else:
			print( "Material: ", mat )
		pass
		
	for m : String in missing:
		print( "@export var " + m.replace('"',"") + " : String")
