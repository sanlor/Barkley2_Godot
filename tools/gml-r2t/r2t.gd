extends Control

@onready var load_room: 			FileDialog 			= $load_room
@onready var room_label: 			Label 				= $MarginContainer/VBoxContainer/options_room/Label
@onready var room_data: 			HFlowContainer 		= $MarginContainer/VBoxContainer/room_data
@onready var gen_tilemap: 			Button 				= $MarginContainer/VBoxContainer/gen_tilemap
@onready var save_tilemap: 			Button 				= $MarginContainer/VBoxContainer/save_tilemap
@onready var menu_order : 			VBoxContainer 		= $MarginContainer/VBoxContainer
@onready var tilemap_container: 	ScrollContainer 	= $MarginContainer/VBoxContainer/tilemap

var room_folder_path 	:= "Y:/tmp/barkley_2/Barkley2.gmx/rooms/"

var selected_room 	:= ""

var needed_bg 		:= Array()
var selected_bg 	:= Array()

var img_buttons 	:= Array() # load bg im buttons

var has_room := false
var has_bg := false

var room_settings_gml 			:= {}
var room_instances_gml 			: Array[Dictionary] = [] 
var room_tiles_gml 				: Array[Dictionary] = []
var room_layers_gml				: Array[String]		= [] # "-1000000"
var room_view_gml 				: Array[Dictionary] = []
var room_background_gml 		: Array[Dictionary] = []


#var my_tilemap : TileMapLayer
var tilemap_root 	: Node2D
var tileset 		: TileSet # used to save tilesets, save to disk

func _ready() -> void:
	print( str("%X" % 225).lpad(4, "0") )
	pass # Replace with function body.

func parse_room_gmx():
	room_settings_gml.clear()
	room_instances_gml.clear()
	room_tiles_gml.clear()
	room_layers_gml.clear()
	room_view_gml.clear()
	room_background_gml.clear()
	
	needed_bg.clear()
	selected_bg.clear()
	img_buttons.clear()
	
	for c in tilemap_container.get_children():
		c.queue_free()
	
	var parser := XMLParser.new()
	var error = parser.open( selected_room  )
	if error != OK:
		push_error(error, " - Couldnt parse the file ", selected_room)
		has_room = false
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

	check_room_tile_layers()
	populate_room_data()
	has_room = true
	
func check_room_tile_layers():
	for tile in room_tiles_gml:
		var depth : String = str( tile["depth"] )
		if room_layers_gml.has( depth ):
			continue
		else:
			room_layers_gml.append( depth )
	
func populate_room_data():
	for data in room_data.get_children():
		data.queue_free()
	
	var rsize = Vector2( room_settings_gml["width"], room_settings_gml["height"] )
	create_data_label( "Room size", str(rsize) )
	create_data_label( "Room layers", str( room_layers_gml.size() ) )
	
	var bgName := []
	for bg in room_tiles_gml:
		if not bgName.has( bg["bgName"] ):
			bgName.append( bg["bgName"] )
	
	# cleanup old buttons
	for b in img_buttons:
		b.queue_free()
	
	var index := 0
	for n : String in bgName:
		#create_data_label(" - Need tileset", n)
		needed_bg.append( n )
		var img_load = preload("uid://by21n03ae7gav").instantiate()
		menu_order.add_child( img_load )
		img_load.set_required_file ( n )
		img_load.index = index
		img_load.file_loaded.connect( check_loaded_files ) # check if the images were loaded before trying to generate the room.
		menu_order.move_child( img_load, 1 )
		img_buttons.append( img_load )
		
		index += 1
		
	selected_bg.resize( bgName.size() )
	
func check_loaded_files( id : int, file : String):
	var is_ok := true
	for loader in img_buttons:
		if not loader.is_file_loaded():
			is_ok = false
	if is_ok:
		gen_tilemap.disabled = false
	else:
		gen_tilemap.disabled = true
	
	# save the selected file path
	selected_bg[id] = file

func create_data_label( key, value ):
	var l := Label.new()
	l.text = key + ": " + value
	l.modulate = Color.GREEN
	room_data.add_child( l )

func _on_room_button_pressed() -> void:
	load_room.access = FileDialog.ACCESS_FILESYSTEM #FileDialog.ACCESS_RESOURCES
	load_room.current_dir = room_folder_path #bg_folder_path
	load_room.show()

func _on_load_room_file_selected(path: String) -> void:
	selected_room = path
	room_label.text = str(path)
	parse_room_gmx()

func _on_gen_tilemap_pressed() -> void:
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
	
	for c in tilemap_container.get_children():
		c.queue_free()
	
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
					
	tilemap_root = Node2D.new()
	for layer in layer_index.values():
		tilemap_root.add_child( layer, true )
		
	tilemap_container.add_child( tilemap_root )
	
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
	save_tilemap.disabled = false


func _on_save_tilemap_pressed() -> void:
	var time := Time.get_ticks_msec()
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
	ResourceSaver.save(scene, "user://%s.tscn" % file_name)
	print( "Objects saved at user://%s.tscn" % file_name )
	print( "saving took: %s msecs. " % str(Time.get_ticks_msec() - time) )
	OS.shell_open (ProjectSettings.globalize_path("user://") )
	
	get_tree().reload_current_scene()
	
