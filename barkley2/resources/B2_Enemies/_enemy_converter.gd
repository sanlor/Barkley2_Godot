@tool
extends EditorScript

## is this useful?

const ENEMY_DB 			= preload("res://barkley2/resources/B2_Enemies/enemyDB.json")
const ENEMY_FOLDER 		:= "res://barkley2/resources/B2_Enemies/"

func _run() -> void:
	for key : String in ENEMY_DB.data:
		var enemy_data 				:= B2_EnemyData.new()
		enemy_data.enemy_name 		= ENEMY_DB.data[key]["name"]
		enemy_data.resource_name 	= key
		
		for propriety : String in ENEMY_DB.data[key]["default"]:
			enemy_data.set( propriety, float( ENEMY_DB.data[key]["default"][propriety] ) )

		ResourceSaver.save.call_deferred( enemy_data, ENEMY_FOLDER + key + ".tres", ResourceSaver.FLAG_BUNDLE_RESOURCES )
		
