@tool
extends Node

func search_dir(path: String, search_pattern: String = "", recursive: bool = false) -> Array:
	search_pattern = "*" if search_pattern == "" else search_pattern
	var dir = DirAccess.open(path)

	if not dir:
		var error = "Could not open dir at path: \"%s\"" % path
		printerr(error)
		push_error(error)
		return []

	# TODO: Set include_hidden and include_navigational
	dir.list_dir_begin()
	# TODO: Push full path! Files are naked here
	var files = []
	var full_path = path

	var file = dir.get_next()
	while file != "":
		if dir.current_is_dir():
			if recursive:
				var file_full_path = "%s/%s" % [full_path.trim_suffix('/'), file]
				files.append_array(search_dir(file_full_path, search_pattern, recursive))
			else:
				# Pass ensures file is set to next
				pass
		elif file.match(search_pattern):
			files.append("%s/%s" % [full_path.trim_suffix('/'), file])

		file = dir.get_next()        

	return files
