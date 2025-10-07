@tool
extends Control
## The absolute lazy script! All this does is convert the gml room to godot's tilemaplayer, in batch.

const temp_room_folder 		:= "res://tools/gml-r2t/temp_room_folder/"
#const r2t_script 			:= preload("uid://be81dfq2iw58x")
const room_folder_path 		:= "/home/sanlo/Documents/GitHub/Barkley2_Original/barkley_2/Barkley2.gmx/rooms/" # "Y:/tmp/barkley_2/Barkley2.gmx/rooms/"

@export var room_prefix := "r_pea"
@export_tool_button("Let it rip!") var ripper : Callable = _ripper

func _ready() -> void:
	if not Engine.is_editor_hint():
		_ripper()

func _ripper() -> void:
	var all_rooms := DirAccess.get_files_at(room_folder_path)
	var parsed_rooms := []
	
	for room : String in all_rooms:
		if room.begins_with(room_prefix):
			parsed_rooms.append( room )
	
	var all_bgs := DirAccess.get_files_at("res://barkley2/assets/b2_original/backgrounds/")
	
	#print( parsed_rooms )
	for room : String in parsed_rooms:
		var room_settings_gml 			:= {}
		var room_instances_gml 			: Array[Dictionary] = [] 
		var room_tiles_gml 				: Array[Dictionary] = []
		var room_layers_gml				: Array[String]		= [] # "-1000000"
		var room_view_gml 				: Array[Dictionary] = []
		var room_background_gml 		: Array[Dictionary] = []
		
		var selected_room := room_folder_path + room
		var parser := XMLParser.new()
		var error = parser.open( selected_room  )
		if error != OK:
			push_error(error, " - Couldnt parse the file ", selected_room)
			return
		var write_text_to := ""
		
		while parser.read() != ERR_FILE_EOF:
			if parser.get_node_type() == XMLParser.NODE_ELEMENT:
				var node_name = parser.get_node_name()
			
				if node_name == "instance":
					var dict := {}
					for idx in range(parser.get_attribute_count()):
						dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
					room_instances_gml.append( dict )
					
				elif node_name == "tile":
					var dict := {}
					for idx in range(parser.get_attribute_count()):
						dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
					room_tiles_gml.append( dict )
				elif node_name == "view":
					
					var dict := {}
					for idx in range(parser.get_attribute_count()):
						dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
					room_view_gml.append( dict )
				elif node_name == "background":
					
					var dict := {}
					for idx in range(parser.get_attribute_count()):
						dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
					room_background_gml.append( dict )
					
				# Should only be the settings
				else:
					room_settings_gml[node_name] = null
					write_text_to = node_name
					
			if parser.get_node_type() == XMLParser.NODE_TEXT:
				if not write_text_to.is_empty():
					room_settings_gml[write_text_to] = str_to_var( parser.get_node_data() )
					write_text_to = ""

		# check_room_tile_layers()
		for tile in room_tiles_gml:
			var depth : String = str( tile["depth"] )
			if room_layers_gml.has( depth ):
				continue
			else:
				room_layers_gml.append( depth )
				
		var needed_bg 		:= Array()
		var selected_bg 	:= Array()
		
		for bg in room_tiles_gml:
			if not needed_bg.has( bg["bgName"] ):
				needed_bg.append( bg["bgName"] )
				
		for bg : String in needed_bg:
			selected_bg.append( "res://barkley2/assets/b2_original/backgrounds/" + all_bgs.get( all_bgs.find(bg + ".png") ) )
				
		var tilemap_root 	: Node2D
		var tileset 		: TileSet # used to save tilesets, save to disk
		
		# _on_gen_tilemap_pressed()
		# initial setup
		var time := Time.get_ticks_msec()
		print( "Tilemap gen started!")
		var bg_index := {} # "tls_fct_eggroom01" = 0, "tls_fct_factory01" = 1
		
		var atlas_sources := []
		for bg in selected_bg:
			var tilesetatlassource := TileSetAtlasSource.new()
			#var img_bg := Image.load_from_file( bg )
			#tilesetatlassource.texture = ImageTexture.create_from_image( img_bg )
			var texture : Texture2D = load( bg )
			tilesetatlassource.texture = ResourceLoader.load( bg, "Texture2D" )
			
			
			var img_x : int = tilesetatlassource.texture.get_width()
			var img_y : int = tilesetatlassource.texture.get_height()
			@warning_ignore("integer_division")
			for x in img_x / 16:
				@warning_ignore("integer_division")
				for y in img_y / 16:
					tilesetatlassource.create_tile( Vector2( x, y ), Vector2i( 1, 1 ) )
			
			atlas_sources.append( tilesetatlassource )
			
			bg.replace("\\", "/")
			var split_bg : Array = bg.split( "/", false )
			var img_name : String = split_bg.back().trim_suffix(".png")
			bg_index[ img_name ] = bg_index.size()
			tilesetatlassource.resource_name = img_name
		
		#var tileset := TileSet.new()
		tileset = TileSet.new()
		
		# set the cell size
		tileset.tile_size = Vector2i( 16, 16 ) ## TEMP, i think.
		
		for source in atlas_sources:
			tileset.add_source ( source )
			print("Tileset source %s loaded!" % source)
		
		print( tileset.get_source_count() )
		
		var layer_index := {}
		for depth : String in room_layers_gml:
		#my_tilemap = TileMapLayer.new()
		#my_tilemap.tile_set = tileset
			var _tilemaplayer 			:= TileMapLayer.new()
			_tilemaplayer.tile_set 		= tileset
			_tilemaplayer.name 			= "layer " + depth
			layer_index[depth] 			= _tilemaplayer
		
		# Pattern setup
		# add_pattern(pattern: TileMapPattern, index: int = -1)
		for tile in room_tiles_gml:
			var pos_in_tilemap 		:= Vector2i( int(tile["x"]), 	int(tile["y"]) ) / 16
			var pos_in_bg 			:= Vector2i( int(tile["xo"]), 	int(tile["yo"]) ) / 16
			var tile_name 			: String = tile["bgName"]
			var _my_tilemap			: TileMapLayer = layer_index[ tile["depth"] ]
			
			if tile["scaleX"] == "1" and tile["scaleY"] == "1": # the tile is not streched, treat it as a pattern or a single tile.
				
				if tile["w"] == "16" and tile["h"] == "16": # is a single unstreched tile
					_my_tilemap.set_cell(pos_in_tilemap, bg_index[ tile_name ], pos_in_bg)
					
				else: # is a pattern of lots of tiles
					var tile_size 			:= Vector2i( int(tile["w"]), int(tile["h"]) ) / 16
					for x in tile_size.x:
						for y in tile_size.y:
							
							_my_tilemap.set_cell( pos_in_tilemap + Vector2i( x, y ), bg_index[ tile_name ], pos_in_bg + Vector2i( x, y ) )
							
			else: # Is a streched single tile.
				var tile_scale 			:= Vector2i( int(tile["scaleX"]), int(tile["scaleY"]) )
				for x in tile_scale.x:
					for y in tile_scale.y:
						_my_tilemap.set_cell( pos_in_tilemap + Vector2i( x, y ), bg_index[ tile_name ], pos_in_bg )
						
		tilemap_root = B2_ROOMS.new()
		
		## Love being lazy.
		tilemap_root.add_child( B2_TOOL_ROOM_CONVERTER.new(), true )
		tilemap_root.add_child( B2_TOOL_GML_SPRITE_CONVERTER_LITE.new(), true )
		tilemap_root.add_child( B2_TOOL_DWARF_CONVERTER.new(), true )
		
		for layer in layer_index.values():
			tilemap_root.add_child( layer, true )
			
		
		print( "Tilemap gen finished! ", Time.get_ticks_msec() - time)
		time = Time.get_ticks_msec()
		print ( "Creating objects.")
		
		var index := 0
		for objects in room_instances_gml:
			var placeholder 		:= Marker2D.new()
			var obj_pos 			:= Vector2( int(objects["x"]), int(objects["y"]) )
			var obj_scale 			:= Vector2( int(objects["scaleX"]), int(objects["scaleY"]) )
			var obj_name 			: String = objects["objName"]
			var obj_inst_name 		: String = objects["name"]
			var obj_code 			: String = objects["code"]
			
			placeholder.position = obj_pos
			placeholder.name = "P" + str(index) + " - " + obj_name
			placeholder.set_meta("code", 		obj_code)
			placeholder.set_meta("inst_name", 	obj_inst_name)
			placeholder.set_meta("scale", 		obj_scale)
			
			tilemap_root.add_child( placeholder )
			index += 1
		
		print( "Objects created: %s . " % str( tilemap_root.get_child_count() ), Time.get_ticks_msec() - time )
		
		var time2 := Time.get_ticks_msec()
		
		print("Saving...")
		if selected_room.is_empty():
			breakpoint
			
		selected_room.replace("\\", "/")
		var file_array := selected_room.split( "/", false )
		var file_name : String = file_array[-1].trim_suffix(".room.gmx")
		
		var res_tileset := tileset
		
		for i in res_tileset.get_source_count():
			var tilesetatlassource : TileSetAtlasSource = res_tileset.get_source( i )
			
			# set the external atlas resource
			## Disabled as a test 10-01-25 vvvv
			#ResourceSaver.save( tilesetatlassource, "user://%s.tres" % tilesetatlassource.resource_name, ResourceSaver.FLAG_COMPRESS )
			#res_tileset.remove_source( i )
			#res_tileset.add_source( load("user://%s.tres" % tilesetatlassource.resource_name), i )
			## ^^^^
		
		var scene = PackedScene.new()
		for c in tilemap_root.get_children(): # save children to disk
			c.set_owner(tilemap_root)
			
		tilemap_root.name = file_name
		scene.pack( tilemap_root )
		
		if FileAccess.file_exists( temp_room_folder + "%s.tscn" % file_name ):
			print_rich("[color=red]Whoa baby, file already exists. Remove the file manually. bypassing this one...[/color]")
			continue
			
		ResourceSaver.save(scene, temp_room_folder + "%s.tscn" % file_name)
		print( "Objects saved at user://%s.tscn" % file_name )
		print( "saving took: %s msecs. " % str(Time.get_ticks_msec() - time2) )
