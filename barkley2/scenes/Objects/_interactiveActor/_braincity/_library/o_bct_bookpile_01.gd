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
	document_title = "Are JRPGs the Cultural Apex of Mankind?"; ## Truckpump
	document_page.clear()
	document_page.resize(6)
	document_page[0] = "It is beyond question to anyone with more than two brain cells that JRPGs are the last bastion of the cognitive elite, far and away the most important cultural product of modern civilization.";
	document_page[1] = "It can be stated definitively that JRPG masterpieces such as the Der Langrisser series, Ar Tonelico, Wild Arms and of course, Grandia 2, are the cultural and evolutionary apex of mankind, far surpassing the meagre efforts of their predecessors,";
	document_page[2] = "from the conspicuously non-anime cave paintings of our Neanderthal ancestors to Shakespeare's middling and penultimately unimpressive sonnets, which lack the nuance and sly humor of Ted Woolsey's infamous Final Fantasy 6 (3 for my uninformed American audience) translation.";
	document_page[3] = "Why is it, then, that we as a species have largely decided to ignore these cultural treasures in favor of low-hanging plebian offal like Halo and Madden? The answer is simply that the American 'people' (and I use that term reluctantly) are too dysgenically stupid to understand their grandeur and sophistication.";
	document_page[4] = "If, instead of stumbling and outdated works like The Catcher in the Rye and The Great Gatsby, our school system taught Arc the Lad or Valkyrie Profile, the American people might have the intellectual wherewithal to understand more philosophically-minded works such as Terranigma.";
	document_page[5] = "That said, despite my frequent quarrels with the Obama administration, I must commend it for its efforts in securing the localization of Hyperdimension Neptunia Mk2, the indisputable JRPG magnum opus of the modern era.##- Truckpump";
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 1);

func execute_event_user_1():
	document_title = "Baldur's Gate: A Retrospective"; ##Truckpump
	document_page.clear()
	document_page.resize(6)
	document_page[0] = "Ah yes, Baldur's Gate - just what the doctor ordered, the doctor in question being a fool and ignoramus. Baldur's Gate (or Baldur's Egregious Failure, as I have taken to calling it) is an infuriatingly flawed Western 'RPG' that is often touted by Western RPG apologists as a shining beacon of the genre.";
	document_page[1] = "If, in fact, the vidcon is the magnum opus that they claim it is, then their precious genre is as shallow, laughable and worthy of scorn as the modern first person shooter, which no more qualifies as a vidcon as it does a coloring book.";
	document_page[2] = "The vidcon's combat is cumbersome and tiring, its setting bereft of even a single dojo where I can hone my skills and even its writing, supposedly a high watermark for the genre, is lacking the soul and passion of writing like Lunar 2 or even Lufia.";
	document_page[3] = "Had the vidcon a soundtrack composed by Motoi Sakuraba, replete with piercing rock organ and haunting chorus pads, I might be able to overlook these glaring flaws, but instead we are treated to an utterly forgettable yet thoroughly Western orchestral score.";
	document_page[4] = "In conclusion, this vidcon is best suited for a chimpanzee or perhaps, if I'm feeling generous, the slightly more evolved snow monkey from the infamous gaming archipelago of Japan.";
	document_page[5] = "My suggestion? Avoid this farcical disappointment and check out Ar Tonelico, a vidcon thats innovative Soul Dive system has aged like a fine Game Fuel.##- Truckpump";
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 2);
	
func execute_event_user_2():
	document_title = "A Message of Warning to Food Lion"; ## Truckpump
	document_page.clear()
	document_page.resize(4)
	document_page[0] = "It has come to my attention that Food Lion has stopped carrying the wildly popular Japanese delicacy Pokki, typically romanized (incorrectly) as Pocky. I have written numerous times on the virtues of this confection, especially in regard to its use in elite vidcon and anime communities, but it seems that Food Lion has chosen to turn a deaf ear.";
	document_page[1] = "Pocky is, without a doubt, the most preferred snack for high level vidcon performance (due to its portability, sugar content and exceptional Japanese engineering, though this has all been discussed at length in my essays) and by refusing to sell it,";
	document_page[2] = "Food Lion is turning its back on both the extremely prestigious vidcon and Japanese communities, both of which hold significant influence.";
	document_page[3] = "This is your first and final warning, Food Lion: put Pocky back on the shelves or your act of extreme betrayal against vidconners will be met with an economic retribution that can only be likened to a tsunami, the Japanese word for ~tidal wave~.##- Truckpump";
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 3);
	
func execute_event_user_3():
	document_title = "Katanas or Longswords: My Cutting Rebuttal"; ## Truckpump
	document_page.clear()
	document_page.resize(6)
	document_page[0] = "Ah, the eternal 'katana versus longsword' debate. Although I rarely write on topics outside of my well-established and highly recognized niche of vidcons, I am considered an expert on numerous other subjects, including, and not limited to, swords and swordsmanship.";
	document_page[1] = "So skilled am I with the folded steel that my local karate dojo was forced out of necessity to invent a rank even higher than black belt specifically for me. That is why, although it is not customary for me to speak outside of my field, it is certainly within my range of expertise, and, in the current climate of debate on the subject, unfortunately necessary.";
	document_page[2] = "Katanas are, without exception, superior to European longswords; any attempt to argue otherwise is wildly ill-informed pablum at best, outright malicious disinformation fuelled by misguided Eurocentrism at worst. The katana is faster, sharper, harder and far more precise than even the most expertly-crafted longsword,";
	document_page[3] = "although the discipline needed to wield (or dual wield, as I prefer) one is vastly more demanding. The master samurai is trained from the day he is born to cut through cars and titanium slabs (which I do regularly to subdue my opponents) with the flick of his wrist; cutting through longswords and pitiful Western platemail is as easy as cutting through tissue.";
	document_page[4] = "In fact, the greatest of samurai were known to cut through multiple, fully-armored knights with a single blow. By contrast, the European longsword is dull and flat, quite often by virtue of their shoddy craftsmanship. The knight is forced to either bludgeon his foes with the overly-weighty pommel of his blade or close in with a dirk, the poor man's 'wakizashi'.";
	document_page[5] = "Even the infamous bastard sword, which I have taken to calling the dullard sword, cannot match the quality of the katana, although I must admit that its capacity to inflict debilitating crits is nearly as potent.## - Truckpump";
	_make_doc( document_title, document_page )
	B2_Playerdata.Quest("bctBookpile", 0);
