## Resume stuff. Tried to copy-paste the old code for an easy time.
extends Control

const DEBUG		:= true

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
	
@onready var note_itself: 			TextureRect = $note_itself
	
@onready var resume_photo_text: 	TextureRect = $note_itself/resume_photo_text
@onready var name_value_lbl: 		Label = $note_itself/name_value_lbl
@onready var age_value_lbl: 		Label = $note_itself/age_value_lbl
@onready var quote_value_lbl: 		Label = $note_itself/quote_value_lbl

@onready var ref_value_lbl: 		Label = $note_itself/ref_value_lbl
@onready var exp_value_lbl: 		Label = $note_itself/exp_value_lbl
@onready var qual_value_lbl: 		Label = $note_itself/qual_value_lbl
@onready var skill_value_lbl: 		Label = $note_itself/skill_value_lbl

var progress := 0

func _ready() -> void:
	if DEBUG: push_warning("RESUME DEBUG is on.")
	_translate()
	# position itself on the correct place
	if get_parent() is B2_ROOMS:
		global_position = B2_CManager.camera.global_position + Vector2(0, -120 + 10)
		

func _translate() -> void:
	for i in get_children():
		if i is Label:
			i.text = Text.pr( i.text )

## Progress on the minigame
func execute_event_user_0():
	if DEBUG: print("RESUME: Progress -> %s" % progress)
	match progress:
		# Static data
		0:		set_photo()
		1:		set_resume_name()
		2:		set_resume_age()
		3:		set_resume_quote()
		
		# Dynamic data
		4:		set_reference()
		5:		set_experience()
		6:		set_qualifications()
		7:		set_skills()
		
	# Progress can't be stopped.
	progress += 1
	B2_Sound.play("altijd_pencil")

## Sling Sheet upward
func execute_event_user_1():
	if DEBUG: print("RESUME: Slid upward")
	z_index = 1000
	reset_resume()
	note_itself.position.y = 240.0
	var t := create_tween()
	t.tween_property( note_itself, "position:y", 0.0, 0.75 ).set_trans( Tween.TRANS_CUBIC )
	
## Sling Sheet downward
func execute_event_user_2():
	if DEBUG: print("RESUME: Slid downward")
	note_itself.position.y = 0.0
	var t := create_tween()
	t.tween_property( note_itself, "position:y", 240.0, 0.75 ).set_trans( Tween.TRANS_CUBIC )
	t.tween_interval(0.5)
	t.tween_callback( queue_free )

func reset_resume() -> void:
	if DEBUG: print("RESUME: Reset")
	resume_photo_text.hide()
	name_value_lbl.text 	= ""
	age_value_lbl.text 		= ""
	quote_value_lbl.text 	= ""
	
	ref_value_lbl.text 		= ""
	exp_value_lbl.text 		= ""
	qual_value_lbl.text 	= ""
	skill_value_lbl.text 	= ""

func fill_resume() -> void:
	if DEBUG: print("RESUME: Filled")
	set_photo()
	set_resume_age()
	set_resume_quote()
	set_resume_name()
	set_experience()
	set_qualifications()
	set_reference()
	set_skills()

func set_photo() -> void:			resume_photo_text.show()
func set_resume_name() -> void:		name_value_lbl.text 	= Text.pr("Eric")
func set_resume_age() -> void:		age_value_lbl.text 		= Text.pr("???")
func set_resume_quote() -> void:		quote_value_lbl.text 	= Text.pr('"No gods, no masters. Only pets."')

func set_reference() -> void:		ref_value_lbl.text 		= Text.pr( REFERENCES[ B2_Playerdata.Quest("ericReference") ] )
func set_experience() -> void:		exp_value_lbl.text 		= Text.pr( EXPERIENCE[ B2_Playerdata.Quest("ericExperience") ] )
func set_qualifications() -> void:	qual_value_lbl.text 	= Text.pr( QUALIFICATION[ B2_Playerdata.Quest("ericQualification") ] )
func set_skills() -> void:			skill_value_lbl.text 	= Text.pr( SKILLS[ B2_Playerdata.Quest("ericSkill") ] )
