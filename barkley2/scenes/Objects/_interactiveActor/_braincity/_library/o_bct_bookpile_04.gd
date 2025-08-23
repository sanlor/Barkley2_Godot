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
	document_title = "Trumpets of Valor"; ## Tormac of Blogus
	document_page[0] = "~Ring the trumpets! Ring the trumpets!~ The King excoriated, his gullet shredded by a stray arrow. ~For alas,~ he continued, ~My lips shall no longer embrace the trumpet's brass frame. No longer shall the trumpets ring true for me, on account of my wounded gullet.~".replace("~",'"')
	document_page[1] = "The King stumbled down the parapets, his hands clenching his ragged gullet to stem the tide of blood. ~I loved trumpets in my youth.~ The King's agonized rasps echoed through hills and dales. ~But no longer shall they play for me. No longer shall the brassen trump roar from its cavernous bell for me, because of my gullet.~".replace("~",'"')
	document_page[2] = "All who heard the King's trumpet monologue shook their heads in sorrow. It was his greatest moment.##- Tormac of Blogus".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 1);

func execute_event_user_1():
	document_page.clear()
	document_page.resize(3)
	document_title = "Confederates Versus Orcs"; ##Mobart the Pious
	document_page[0] = "~Don't fire until you see the whites of their eyes!~ Robert E. Lee barked orders to his loyal Confederate soldiers, who aimed their muskets at the invading orc tribe below them. Stonewall Jackson gazed at the approaching orcs with vim and determination.".replace("~",'"')
	document_page[1] = "~These orcs have one weakness,~ he began. But it was too late - he was blasted in the gullet by a sizzling Melf's Acid Arrow. ~Consarn it...~ he rasped to himself sadly.".replace("~",'"')
	document_page[2] = "War was waged that day at every battlefield from the misty dales of Gettysburg to the misty dales of Normandy and many a life, both savage Orc and genteel Confederate, was snuffed short. And to the victor went all the jaspers in the kingdom.##- Mobart the Pious".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 2);
