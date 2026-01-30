## Resume stuff. Tried to copy-paste the old code for an easy time.
extends Node2D

const REFERENCES := [
	"P_NAME",
	"Not applicable",
	"Lots of animals",
	"Cuchulainn",
	]
const EXPERIENCE := [
	"None (but full of gumption)",
	"DwarfNET Moderator",
	"Full-time MMO player",
	"Bat guano enthusiast",
	"fuckyeahbulldogs.cogworx.edu",
	]
const QUALIFICATION := [
	"Love animals, works with them daily",
	"Unbelievably loud falcon mimicry",
	"Perhaps my BARNSTARS will convince you",
	"Basically none, completely dysfunctional cretin",
	"Mole breeder extraordinaire",
	]
const SKILLS := [
	"More than two decades of pet care",
	"I cut through the pet bullshit",
	"I have NEVER missed Shark Week",
	"No skills, product of entropy and a wasted life",
	"Depraved ocelot DwarfNET meme",
	]
func _ready() -> void:
	_translate()

func _translate() -> void:
	for i in get_children():
		if i is Label:
			i.text = Text.pr( i.text )

func _update_quest_vars() -> void:
	pro += 1;
	ans[0] = B2_Playerdata.Quest("ericReference");
	ans[1] = B2_Playerdata.Quest("ericExperience");
	ans[2] = B2_Playerdata.Quest("ericQualification");
	ans[3] = B2_Playerdata.Quest("ericSkill");
