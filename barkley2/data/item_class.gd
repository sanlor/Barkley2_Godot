extends Node
class_name B2_Item

## Helper class to add, change, remove, give and use items.
## Check Item()
## item sprite is sItem

## ALERT this script works differently from the original code. THS WILL BREAK COMPATIBILITY.

# item format -> {"Lock Pick" : 2}

static func item_init() -> void:
	B2_Config.set_user_save_data( "quest.itemsName", {} )
	
## Returns true if you have one or more of an item
static func have_item( item_name : String ) -> bool:
	if B2_Database.items.has( item_name ):
		var i : Dictionary = B2_Config.get_user_save_data( "quest.itemsName", {} )
		if i.has( item_name ): # check if player has the item
			if i[item_name] > 0: # check if the quantity is above 0 ( should never be <= 0 )
				return true
		return false
	else:
		push_error( "Invalid item %s." % item_name )
		return false
		
## Get a list of hoopz items
static func get_items() -> Dictionary:
	return B2_Config.get_user_save_data( "quest.itemsName", {} )
		
## Returns the number you have of the item
static func count_item( item_name : String ) -> int:
	if B2_Database.items.has( item_name ):
		var i : Dictionary = B2_Config.get_user_save_data( "quest.itemsName", {} )
		if i.has( item_name ): # check if player has the item
			return i[item_name]
		return 0
	else:
		push_error( "Invalid item %s." % item_name )
		return 0
	
## Hoopz gains an item
static func gain_item( item_name : String, amount := 1 ) -> void:
	if B2_Database.items.has( item_name ):
		var i : Dictionary = B2_Config.get_user_save_data( "quest.itemsName", {} )
		if i.has( item_name ): # check if player has the item
			i[item_name] += amount
		else:
			i[item_name] = amount
		i[item_name] = clampi( i[item_name], 1, 99 ) ## Add a item cap.
		B2_Config.set_user_save_data( "quest.itemsName", i )
	else:
		push_error( "Invalid item %s." % item_name )
		
## Hoopz loses an item
static func lose_item( item_name : String, amount := 1 ) -> void:
	if B2_Database.items.has( item_name ):
		var i : Dictionary = B2_Config.get_user_save_data( "quest.itemsName", {} )
		if i.has( item_name ): # check if player has the item
			i[item_name] -= amount
		#else:							# 30/12/25 disabled these lines. Seems wrong. Are they adding an item if it doesnt exist?
		#	i[item_name] = amount
		if i[item_name] < 1:
			i.erase(item_name)
		B2_Config.set_user_save_data( "quest.itemsName", i )
	else:
		push_error( "Invalid item %s." % item_name )
