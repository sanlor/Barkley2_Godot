@tool
@icon("res://barkley2/assets/b2_original/images/merged/sMapIconQuestion.png")
extends Node
class_name B2_TOOL_SCENE_REPLACER

# Replaces a marker with an existing scene.
# https://github.com/godotengine/godot-proposals/issues/4991

@export var target_node 					: Marker2D
@export_file("*.tscn") var desired_scene 	:= ""

@export_category("Execution")
@export var simulate := true					## Dont change anything, just check if everything is working fine
@export var remove_nodes 		:= false
@export var start_conversion 	:= false :		## Start the conversion process.
	set(b):
		lets_goooo()
		
func lets_goooo():
	if desired_scene.is_empty():
		print("No scene selected.")
		return
	
	if not is_instance_valid(target_node):
		print("Target node not valid.")
		return
	
	var node = load(desired_scene).instantiate()
	if not is_instance_valid(node):
		print("Scene not valid.")
		return
	
	if simulate:
		print("Scene is valid. ", node.name)
		return
		
	print("Writing changes")
	var t = target_node
	var t_name = target_node.name
	var t_pos = target_node.global_position
	
	for meta : String in t.get_meta_list():
		node.set_meta( meta, t.get_meta(meta) )
		
	if remove_nodes:
		t.replace_by( node )
	else:
		add_sibling( node, true)
		node.owner = get_parent()
		
	node.name 		= t_name
	node.position 	= t_pos
	
	print("Finished.")
