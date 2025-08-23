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
	document_title = "Gore Ape"; ## Druksmald
	document_page[0] = "~The Gore Ape is coming! The Gore Ape is coming!~ The cry of warning was too late; the Gore Ape had already penetrated the keep, running amok amongst the pages and squires. The Gore Ape hooted treacherously as it knocked baskets over, banging on a pot and swinging through the marketplace. Townsfolk ran in all directions from the Gore Ape.".replace("~",'"')
	document_page[1] = "The Gore Ape climbed up a thatched roof of a humble abode and threw some debris down a chimney, letting loose a bloodcurdling cry. ~Kyaaaaaaaaaaaah!~ Not a day went by when innocent paupers weren't subject to the Gore Ape's villainy.##- Druksmald".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 1);

func execute_event_user_1():
	document_page.clear()
	document_page.resize(5)
	document_title = "Sacco Versus Vanzetti: Showdown at the Colosseum"; ## Ghostly Maria
	document_page[0] = "~Drink deeply from my cup of rage,~ growled the grizzled Sacco to his menacing foe Vanzetti, standing across from him in the famous Roman colosseum. All around them cheered the bloodthirsty mob, impatient for a gory death. ~Ahhh, I shall, brother,~ Vanzetti gave a wry smile, ~and I shall chase it with thy blood.~".replace("~",'"')
	document_page[1] = "Sacco took a step forward and drew his mighty tonfas, ~Don't speak so confidently, brother. News of thy demise shall be celebrated from Tuscany to the mystic land of Japan, where ronins dare to tread.~".replace("~",'"')
	document_page[2] = "Visibly angered, Vanzetti readied his body for a telling blow and sneered, ~Laugh now, knave, for in but a moment my blazing spindash will strew thy entrails from one end of this arena to the other.~".replace("~",'"')
	document_page[3] = "Vanzetti gave a toothy grin and peered at Sacco, ~Spindash me, dear brother.~ He paused a moment to give his insult tension, ~For I shall dodge thy spindash as the matador dodges the bull, and return with a spindash of mine own.~ The emperor nodded in approval at Sacco's taunt.".replace("~",'"')
	document_page[4] = "Suddenly, orcs began to rampage throughout the Colosseum with a reckless abandon, killing and enslaving all who crossed their path.##- Ghostly Maria".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 2);
	
func execute_event_user_2():
	document_page.clear()
	document_page.resize(3)
	document_title = "Pro Strats 1"; ## Ricky Tip
	document_page[0] = "On the third floor of Hellcrypt, after killing the Eclipse Mistress but BEFORE recruiting the sand golems, use the wasp spray on the crystal goblins to unlock a new challenge.##NEVER equip Gordon's Royal Pauldrons and the Glowing Silken Turban at the same time.".replace("~",'"')
	document_page[1] = "Fly around the world three times after getting the airship. Then go back to the Duke's palace and talk to the wet nurse. Check the medicine cabinet in Claudia's bathroom and return to the airship. Fly to Blood Tower but don't enter it or bodyslam any of the skeletons. There will be a new mission in the Cobbler's Guild.".replace("~",'"')
	document_page[2] = "Pressing the select button can help you in a number of situations.##Sadly, the Shadow Ape is non-romanceable.##- Ricky Tipz".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 3);
	
func execute_event_user_3():
	document_page.clear()
	document_page.resize(2)
	document_title = "Collected Quotations of Clispaeth".replace("~",'"') ## by Clispaeth (???)
	document_page[0] = "~A penny saved is a penny earned.~ - Clispaeth##~The early bird catches the worm.~ - Clispaeth##~Early to bed and early to rise makes a man healthy, wealthy and wise.~ - Clispaeth".replace("~",'"')
	document_page[1] = "~A friend in need is a friend indeed.~ - Clispaeth##~Speak softly and carry a big stick.~ - Clispaeth##~Just be yourself.~ - Clispaeth".replace("~",'"')
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 0);
