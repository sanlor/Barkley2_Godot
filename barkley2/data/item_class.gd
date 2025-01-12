extends Node
class_name B2_Item

## Helper class to add, change, remove, give and use items.
## Check Item()
## item sprite is sItem
#region old notes
# Item("gain", item_name, quantity (optional: default 1))
#  Hoopz gaisn an item

# Item("lose", item_name, quantity (optional: default 1))
#  Hoopz loses an item

# Item("have", item_name)
#  Returns true if you have one or more of an item

# Item("count", item_name)
#  Returns the number you have of the item

# Item("build", ...)
#  Add build in front of any statement to have it work in a GML cinema

# Below are less common functions

# Item("init")
#  Call once per game

# Item("reset")
#  Call when player identity is reset

# Item("define", item_name, item_description)
#  Adds an item definition to the game (scroll down to init section to define items)

# Item("name", index)
#  Returns a name from an item index

# Item("description", item_name) 
#  Returns a description from a name

# Item("string")
#  Returns a giant string of all items and quantities you have
#endregion

## ALERT this script works differently from the original code. THS WILL BREAK COMPATIBILITY.

# item format -> "Lock Pick" : 2

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
	
## Hoopz gaisn an item
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
		else:
			i[item_name] = amount
		if i[item_name] < 1:
			i.erase(item_name)
		B2_Config.set_user_save_data( "quest.itemsName", i )
	else:
		push_error( "Invalid item %s." % item_name )
