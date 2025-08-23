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
	document_page.resize(2)
	document_title = "Recipes Vol. I"; # Barnabas Draketouched
	document_page[0] = "~The orcs have breached the keep!~ A noble guardsman shouted as he blasted an orc in the gullet with a crossbow bolt. ~Alack...~ mourned a different guardsman. She beckoned over a nearby wizard and tasked her with a quest. ~Seek ye first the kingdom of drakes. And may the drakes be with you,~ her desperate plea rang true in the hearts of all those who heard.".replace("~",'"')
	document_page[1] = "~Doff thy caps and don thy helms,~ a virtuous peasant hooted from the highest belfry. An orc swooped down from above, causing mayhem and mischief for all those who crossed its path. These were dire times indeed.##- Barnabas Draketouched".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 1);

func execute_event_user_1():
	document_page.clear()
	document_page.resize(4)
	document_title = "Genealogy of Good King Hucbald"; ## The Venerable Bede
	document_page[0] = "Count Gustav IV of Bavaria begat Theodoric the Humongous, who begat Ealdorman Wiglaf, who begat Hugo Rat-Goblet, who begat Marquis Yorick the Falconer, who begat Bart of Good Tidings, who begat Eugene III the Parched, who begat Lady Windermere, who begat Bloody Angus, who begat Count Ruprecht, who begat Wise King Samuel,".replace("~",'"')
	document_page[1] = "who begat Vladimir the Impious, who begat Ronald the Bastard, who begat Duke Giselbert the Cobbler, who begat Old Cuthbert, who begat Banquo the Shrew, who begat Giuseppe Hotblood, who begat Angela the Bugler, who begat Theobald X, who begat Friedrich von Castle, who begat Grunwald the Humble, who begat Guthwin,".replace("~",'"')
	document_page[2] = "who begat Pepin the Curious, who begat Constable Stephen, who begat Radoslav whom Fortune Favors, who begat Old King Stewart, who begat Rimbald the Pure, who begat Guido the Helper, who begat Gruspwald the Kind, who begat Merlin, who begat Ursula the Dire, who begat Donald the Bell Wringer,".replace("~",'"')
	document_page[3] = "who begat Good King Hucbald.##- The Venerable Bede".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 2);
	
func execute_event_user_2():
	document_page.clear()
	document_page.resize(3)
	document_title = "The Secret Garden 2" ## Zakabar the Sad
	document_page[0] = "If you've ever read ~The Secret Garden~, then you know it's about children who spend their time in a garden in India. This is ~The Secret Garden 2~ and it's about orcs. I seek out orcs and aid them with rejuvenating spells.".replace("~",'"')
	document_page[1] = "I increase their muscle mass and vigor with valorous enchantments. I give them gold and jewels to help them on their missions. When an orc is in need, I shall soon be there. When I hear the cry of an orc, I cast spells that help them.".replace("~",'"')
	document_page[2] = "I give them food and coffee. I dug a ditch to help an orc. Orcs by the forest and the bay. Orcs aplenty.##- Zakabar the Sad".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 3);
	
func execute_event_user_3():
	document_page.clear()
	document_page.resize(3)
	document_title = "10 Trumpets of Virtue"; ## Gaphulp Duopop
	document_page[0] = "Fie fie and rub-a-dub dub. 10 Trumpets of Virtue blare down the highest chimney for the good names of our noble benefactors. The first trumpet blows for the good Duke of Saxony, who hoots upon orcs for the good of the dukedom. The second trumpet blows for Bart of Good Tidings, who brings his tidings to even the peasants and paupers.".replace("~",'"')
	document_page[1] = "The third trumpet trumps for Marquess Cornwallis, that good marquess. The fourth, fifth and sixth trumpets blast for Shadrach, Meschach and Abednigo, who ate moss and wool on their dire journey. The seventh trumpet blasts for kings, queens, dukes and earls. The eighth trumpet was lost long ago, but echoes yet throughout the hills and dales.".replace("~",'"')
	document_page[2] = "The ninth trumpet plays only for the virtuous Hill Orcs. The tenth and final trumpet blares for Falconer Vanessa, who can tame even the most tumultuous of genies. Memorize these names of virtues, for you will be quizzed on them.##- Gaphulp Duopop".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 0);
