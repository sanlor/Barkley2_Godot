extends Control

const MATERIAL := {
	Vector2(1,1) : ["Candy",	1,	1	],
	Vector2(1,2) : ["Soiled",	1,	7	],
	Vector2(1,3) : ["Salt",		1,	23	],
	Vector2(1,4) : ["Plantain",	1,	39	],
	Vector2(1,5) : ["Napalm",	1,	85	],
	Vector2(1,6) : ["Digital",	1,	133	],
	Vector2(1,7) : ["Francium",	1,	223	],
	
	Vector2(2,2) : ["Rotten",	2,	9	],
	Vector2(2,3) : ["Wood",		2,	24	],
	Vector2(2,4) : ["Bone",		2,	40	],
	Vector2(2,5) : ["Origami",	2,	88	],
	Vector2(2,6) : ["Brain",	2,	137	],
	Vector2(2,7) : ["Orb",		2,	226	],
	
	Vector2(3,4) : ["Aluminium",	2,	45	],
	Vector2(3,5) : ["Offal",		2,	89	],
	Vector2(3,6) : ["Chobham",		2,	139	],
	Vector2(3,7) : ["Nanotube",		2,	227	],
	
	Vector2(4,4) : ["Titanium",		2,	48	],
	Vector2(4,5) : ["Crystal",		2,	91	],
	Vector2(4,6) : ["Bronze",		2,	178	],
	Vector2(4,7) : ["Taxidermy",	2,	261	],
	
	Vector2(5,4) : ["Stone",		2,	51	],
	Vector2(5,5) : ["Adamantium",	1,	93	],
	Vector2(5,6) : ["Blaster",		2,	181	],
	Vector2(5,7) : ["Porcelain",	2,	262	],
	
	Vector2(6,4) : ["Chrome",		1,	52	],
	Vector2(6,5) : ["Silk",			1,	96	],
	Vector2(6,6) : ["Tungsten",		2,	184	],
	Vector2(6,7) : ["Anti-Matter",	2,	263	],
	
	Vector2(7,4) : ["Frankincense",		2,	55	],
	Vector2(7,5) : ["Marble",			1,	98	],
	Vector2(7,6) : ["Itano",			2,	186	],
	Vector2(7,7) : ["Aerogel",			2,	263	],
	
	Vector2(8,4) : ["Iron",				2,	56	],
	Vector2(8,5) : ["Rubber",			1,	101	],
	Vector2(8,6) : ["Pearl",			2,	190	],
	Vector2(8,7) : ["Denim",			2,	265	],
	
	Vector2(9,4) : ["Cobalt",		2,	59	],
	Vector2(9,5) : ["Foil",			1,	103	],
	Vector2(9,6) : ["Myrrh",		2,	192	],
	Vector2(9,7) : ["Untamonium",	2,	266	],
	
	Vector2(10,4) : ["Nickel",		2,	59	],
	Vector2(10,5) : ["Blood",		18,	106	],
	Vector2(10,6) : ["Platinum",	1,	195	],
	
	Vector2(11,4) : ["Copper",		1,	64	],
	Vector2(11,5) : ["Silver",		1,	108	],
	Vector2(11,6) : ["Gold",		1,	197	],
	
	Vector2(12,4) : ["Zinc",		2,	65	],
	Vector2(12,5) : ["Chitin",		2,	112	],
	Vector2(12,6) : ["Mercury",		2,	200	],
	
	Vector2(13,2) : ["Broken",		3,	11	],
	Vector2(13,3) : ["Aluminum",	3,	27	],
	Vector2(13,4) : ["Fiberglass",	3,	70	],
	Vector2(13,5) : ["Sinew",		3,	115	],
	Vector2(13,6) : ["Imaginary",	3,	204	],
	
	Vector2(14,2) : ["Carbon",		4,	12	],
	Vector2(14,3) : ["Glass",		4,	28	],
	Vector2(14,4) : ["Grass",		4,	73	],
	Vector2(14,5) : ["Tin",			4,	119	],
	Vector2(14,6) : ["Lead",		4,	207	],
	
	Vector2(15,2) : ["Mythril",		5,	14	],
	Vector2(15,3) : ["Plastic",		5,	31	],
	Vector2(15,4) : ["Soy",			5,	75	],
	Vector2(15,5) : ["Obsidian",	5,	122	],
	Vector2(15,6) : ["Diamond",		5,	209	],
	
	Vector2(16,2) : ["Rusty",		6,	16	],
	Vector2(16,3) : ["Leather",		6,	32	],
	Vector2(16,4) : ["Steel",		6,	79	],
	Vector2(16,5) : ["Fungus",		6,	128	],
	Vector2(16,6) : ["Polenta",		6,	209	],
	
	Vector2(17,2) : ["Junk",		7,	19	],
	Vector2(17,3) : ["Studded",		7,	35	],
	Vector2(17,4) : ["Brass",		7,	80	],
	Vector2(17,5) : ["Damascus",	7,	127	],
	Vector2(17,6) : ["Yggdrasil",	7,	210	],
	
	Vector2(18,1) : ["3D Printed",	8,	4	],
	Vector2(18,2) : ["Neon",		8,	20	],
	Vector2(18,3) : ["Dual",		8,	40	],
	Vector2(18,4) : ["Orichalcum",	8,	84	],
	Vector2(18,5) : ["Analog",		8,	131	],
	Vector2(18,6) : ["Pinata",		8,	222	],
}
func _ready() -> void:
	#var my_mat : Dictionary = {}
	#for m : Vector2 in MATERIAL:
		#my_mat[ MATERIAL[m][0] ] = [ int(m.x), int(m.y), MATERIAL[m][1], MATERIAL[m][2] ]
	#
	#var file = FileAccess.open( "res://barkley2/resources/B2_Weapon/material_table.json", FileAccess.WRITE )
	#file.store_string( JSON.stringify( my_mat, "\t", false) )
	#file.close()
	pass
