extends B2_EnvironInteractive

## Finding the Cyberspear Dais ##
## event_air_dais01

#This is the Cyberspear Dias that should hold the Lance. Unfortunately, it is missing when you first get to it ...

#csQuest
	#0 = Have not started quest
	#1 = Discussed the AI Ruins, Hoopz has started his journey there
	#2 = Hoopz talks to cdwarf after turning on the Wifi. Cyberdwarf and Hoopz compelled to descend into the ruins
	#3 = Cyberdwarf repeating dialogue
	#4 = Hoopz returns after finding the Cyberspear altar empty, Cyberdwarf asks him to descend further into the ruins
	#5 = Cyberdwarf repeating dialogue
	#6 = Hoopz has found the first piece and talked to Cyberdwarf

#csComplete
	#0 - the Cyberspear is not complete and Hoopz doesn't have knowledge to complete it
	#1 - the Cyberspear pieces been collected
	#2 - Hoopz has assembled the Cyberspear with Cyberdwarf (done in his Hideout)

#csDaisSeen
	#0 = have not seen
	#1 = Hoopz has seen the Dais and knows that the Cyberspear isn't in there.
	
#csQuest
#csPieceAIRuins
#csPieceFactory
#csPieceGrem
#csPiecesTotal 
#csComplete

## Assembling the complete Cyberspear with all the pieces ##

#csQuest
	#0 = Have not started quest
	#1 = Quest has begun, find the router/AI Ruins
	#2 = Reached the AI Ruins gate, it was locked
	#3 = Talked to Cdwarf, the gate has been opened
	#4 = Realize that the Cyberspear is not in the AI Ruins, one piece found
	#5 = Hoopz has completed one CSpear quest, two pieces found
	#6 = Hoopz has completed two CSpear quests, three pieces found
	#7 = Hoopz has completed three CSpear quests, four pieces found
	#8 = The Cyberspear has been re-assembled

func _ready() -> void:
	##Set the Vidcon Name
	#Quest("gamename", Vidcon("name", 5));
	## TODO add Vidcons
	pass
	
