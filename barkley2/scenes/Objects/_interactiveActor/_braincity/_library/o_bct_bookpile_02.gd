extends B2_EnvironInteractive
## https://youtu.be/lnpeKS1XoVY?t=10888
const O_MG_DOCUMENT = preload("uid://cju4mfpiho3e0")

var document_title := ""
var document_page := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _make_doc( title : String, pages : Array ) -> void:
	var doc : B2_MiniGame_Document = O_MG_DOCUMENT.instantiate()
	doc.setup_title( title )
	doc.setup_pages( pages )
	add_sibling( doc, true )

func execute_event_user_0():
	document_page.clear()
	document_page.resize(3)
	document_title = "Orc Death 1" ## Elgarth Hellblood
	document_page[0] = "Orcs... orcs from the highest mountain peak. Orcs from the lowest gulch. Orcs from the dampest cave. Orcs had flooded the mystical realm and only the wisest wizards and bravest knights dared battle them.".replace("~",'"')
	document_page[1] = "'Bring thy mallets! Bring thy mallets!' the beleaguered king shouted desperately. But it was to no avail - the orcs had already taken the ancient keep, once thought to be impenetrable by even the darkest of drakes, whose brutal maws snapped viciously in the night.".replace("~",'"')
	document_page[2] = "One dark orc sneered at the king, a pale shadow of his former self. 'Soon your kingdom will be hexed,' an orc rasped, his voice echoing down a corridor. Everyone believed him, including the elfs.##- Elgarth Hellblood".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 1);

func execute_event_user_1():
	document_page.clear()
	document_page.resize(2)
	document_title = "Orc Death 2" ## Elgarth Hellblood
	document_page[0] = "~If you seek orcs, you have come to the right place,~ the king told a weary traveler. A blood red potion cascaded down the king's gullet. Orcs put wax on the king as a joke. These were dire times indeed - yet the darkest of times had yet to come... For the king had converted to the orcs' side, shocking even the bloodiest of warlocks.".replace("~",'"')
	document_page[1] = "The king's once-formidable jester looked grimly at his liege, then looked grimly somewhere else. Orcs hooted from the balcony as they forged their engines of war. There was no denying it: war had come upon the magical kingdom. Not even the elfs could avoid it.##- Elgarth Hellblood".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 2);
	
func execute_event_user_2():
	document_page.clear()
	document_page.resize(2)
	document_title = "Orc Death 3" ## Elgarth Hellblood
	document_page[0] = "~Lackaday, lackaday,~ the king gasped mournfully as he gulped a potion, rejuvenating his wounds and gashes. His whole body ached from repeated blows from a glowing orc nunchuck. The king sighed as he looked out the window of his castle, gazing upon the once-fertile fields of his fief, a land of mystical peasants and pleading paupers.".replace("~",'"')
	document_page[1] = "The orcs had ransacked the king's precious goblets and crackers, so soon he himself would become a pauper, supplicating himself before warlocks and squires for nuggets and boons. But the time of reckoning drew nigh, even for the elfs.##- Elgarth Hellblood".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 3);
	
func execute_event_user_3():
	document_page.clear()
	document_page.resize(3)
	document_title = "Orc Death 4" ## Elgarth Hellblood
	document_page[0] = "~Alms for the poor! Alms for the poor!~ the king shouted from beneath his own statue, a magnificent granite piece once adorned with gems and jaspers of all kinds, but ransacked by orcs. He was dressed in rags and robes that rendered him unrecognizable to all but the most brave - or perhaps foolhardy - of orcs.".replace("~",'"')
	document_page[1] = "Little did the orcs know that his rags were enchanted with a bonus to dodging. ~Take this, noble serf,~ a magician gasped as he handed the king a bento of crust. ~Eat it to grow strong.~ But the king did not eat it.".replace("~",'"')
	document_page[2] = "He had more devious plans for this bento, plans that not even the most perceptive of elfs could surmise.##- Elgarth Hellblood".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 0);
