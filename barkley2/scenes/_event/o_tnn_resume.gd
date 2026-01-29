## Resume stuff. Tried to copy-paste the old code for an easy time.
extends Node2D

var ans := [ 0, 0, 0, 0 ] # for (i = 0; i < 4; i += 1) ans[i] = 0;

var offX 	:= 0.0
var offY 	:= 0.0
var pro		:= 0.0

var progress := 0.0
var qx		:= 0.0
var qs		:= 0.0

var queX	:= [0.0, 0.0, 0.0, 0.0]
var queY	:= [0.0, 0.0, 0.0, 0.0]
var que		:= ["","","",""]
var ansX	:= [0.0, 0.0, 0.0, 0.0]
var ansY	:= [0.0, 0.0, 0.0, 0.0]
var ansInd 	:= [ 0, 0, 0, 0 ]

func _ready() -> void:
	# Create
	offX = 0;
	offY = 240;
	pro = 0;

	#66, 84
	progress = 0;
	qx = 64;
	qs = 16;
	var i := 0
	queX[i] = qx;
	queY[i] = 80;
	que[i] = "References: ";
	ansX[i] = queX[i] + 80; 
	ansY[i] = queY[i];# + qs;
	ansInd[i] = 0;
	ans[i][0] = "P_NAME";
	ans[i][1] = "Not applicable";
	ans[i][2] = "Lots of animals";
	ans[i][3] = "Cuchulainn";
	ansInd[i] = 0;

	i = 1;
	queX[i] = qx; queY[i] = ansY[i - 1] + qs;
	que[i] = "Experience:";
	ansX[i] = queX[i] + 80;# + 96; 
	ansY[i] = queY[i];
	ans[i][0] = "None (but full of gumption)";
	ans[i][1] = "DwarfNET Moderator";
	ans[i][2] = "Full-time MMO player";
	ans[i][3] = "Bat guano enthusiast";
	ans[i][4] = "fuckyeahbulldogs.cogworx.edu";
	ansInd[i] = 0;

	i = 2;
	queX[i] = qx; queY[i] = ansY[i - 1] + qs + qs;
	que[i] = "Qualifications:";
	ansX[i] = queX[i];# + 96; 
	ansY[i] = queY[i] + qs;
	ans[i][0] = "Love animals, works with them daily";
	ans[i][1] = "Unbelievably loud falcon mimicry";
	ans[i][2] = "Perhaps my BARNSTARS will convince you";
	ans[i][3] = "Basically none, completely dysfunctional cretin";
	ans[i][4] = "Mole breeder extraordinaire";
	ansInd[i] = 0;

	i = 3;
	queX[i] = qx; queY[i] = ansY[i - 1] + qs + qs;
	que[i] = "Skills:";
	ansX[i] = queX[i];# + 96; 
	ansY[i] = queY[i] + qs;
	ans[i][0] = "More than two decades of pet care";
	ans[i][1] = "I cut through the pet bullshit";
	ans[i][2] = "I have NEVER missed Shark Week";
	ans[i][3] = "No skills, product of entropy and a wasted life";
	ans[i][4] = "Depraved ocelot DwarfNET meme";
	ansInd[i] = 0;

func _update_quest_vars() -> void:
	pro += 1;
	ans[0] = B2_Playerdata.Quest("ericReference");
	ans[1] = B2_Playerdata.Quest("ericExperience");
	ans[2] = B2_Playerdata.Quest("ericQualification");
	ans[3] = B2_Playerdata.Quest("ericSkill");
