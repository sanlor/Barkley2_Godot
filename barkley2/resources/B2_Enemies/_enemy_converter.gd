@tool
extends EditorScript

## is this useful?



func _run() -> void:
	const ENEMY_DB 			= preload("res://barkley2/resources/B2_Enemies/enemyDB.json")
	const ENEMY_FOLDER 		:= "res://barkley2/resources/B2_Enemies/"

	for key : String in ENEMY_DB.data:
		var enemy_data 				:= B2_EnemyData.new()
		enemy_data.enemy_name 		= ENEMY_DB.data[key]["name"]
		enemy_data.resource_name 	= key
		
		for propriety : String in ENEMY_DB.data[key]["default"]:
			enemy_data.set( propriety, float( ENEMY_DB.data[key]["default"][propriety] ) )

		ResourceSaver.save( enemy_data, ENEMY_FOLDER + key + ".tres", ResourceSaver.FLAG_RELATIVE_PATHS )
		
