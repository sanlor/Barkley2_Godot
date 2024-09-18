extends StaticBody2D
class_name B2_RIGID_SOLID

# I have no idea whats the difference between a Solid and a Semisolid.

# check o_rigid_solid
# Base class for some collision stuff.

## GML Macro
const ZMAX := 1000000
const ZMIN := -1000000

var shape 		= 0;
var z_bottom 	= ZMIN;
var z_top 		= ZMAX;
