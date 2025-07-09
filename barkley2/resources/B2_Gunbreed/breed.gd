extends RefCounted
class_name B2_GunBreed
## Class that helps out with the Gun breeding process.

## TODO Define what this does.
static func get_compatibility( top_gun : B2_Weapon, bottom_gun : B2_Weapon ) -> float:
	return randf()
	
## TODO Define what this does.
static func get_influence_ratio( top_gun : B2_Weapon, bottom_gun : B2_Weapon ) -> float:
	return randf()
