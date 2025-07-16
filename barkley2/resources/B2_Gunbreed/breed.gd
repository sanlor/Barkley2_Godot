extends RefCounted
class_name B2_GunBreed
## Class that helps out with the Gun breeding process.

## TODO Define what this does.
static func get_compatibility( _top_gun : B2_Weapon, _bottom_gun : B2_Weapon ) -> float:
	return randf()
	
## TODO Define what this does.
static func get_influence_ratio( _top_gun : B2_Weapon, _bottom_gun : B2_Weapon ) -> float:
	return randf()

## TODO actually make this work.
static func breed_gun( _top_gun : B2_Weapon, _bottom_gun : B2_Weapon ) -> B2_Weapon:
	return B2_Gun.generate_gun()
