extends Resource
class_name B2_Database

# check scr_money_db()
# Factorio Space Age is pretty good. its been a few weeks/months since I last worked on this.

## Data related to money. Maybe this should be a Json or other kind of DB? yes, anything can be a DB if you are dumb enough.
## Not money anymore, every "DB" is a dictionary now. Dictionaries can be DBs too.

const money := {
	##--------------------------------------------------------------------
	##  TIR NA NOG ~ the HomeTown of the Dwarfs ~
	##--------------------------------------------------------------------
	# Dubre's Map
	"dubreMap01": 10, # the cost of the Tir na nOg map on first offer
	"dubreMap02": 15,# randi_range(0,20) + 1
	# Wilmer Mortgage
	"wilmerMortgage": 100, # base cost of wilmer's mortgage
	"wilmerMortgageBonus": 30, # bonus money included for hoopz
	"wilmerMortgageTotal": 130, # scr_money_db("wilmerMortgage") + scr_money_db("wilmerMortgageBonus");
	"wilmerSurcharge": 20,
	"vikingstadDemand1": 130, # scr_money_db("wilmerMortgage") + scr_money_db("wilmerSurcharge");
	"vikingstadTease": 130,
	## TODO: Add the rest of the variables.
}
