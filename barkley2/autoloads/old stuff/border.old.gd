extends Node

## NOTE This autoload is responsible for creating dialog boxes and buttons.

##/ Border(generate, id, x, y)

## Border("generate", id, width, height);   Generate a border to be drawn later
## Border("draw", id, x, y);                Draw a border at X Y  
## Border("draw back", id, x, y);           Draw just the grid BG of a border
## Border("draw border", id, x, y);         Draw just the border of a border

## USAGE:
## First generate a border in a create event
## Border("generate", 0, 96, 40);
## Then draw later using the ID you supplied
## Border("draw", 0, x, y);

## NOTE This might need to be changed
#func generate( id, width, height):
func generate( _width, _height):
	pass
