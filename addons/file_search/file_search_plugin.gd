@tool
extends EditorPlugin


const AUTOLOAD_NAME = "FileSearch"


func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/file_search/search_dir.gd")


func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
