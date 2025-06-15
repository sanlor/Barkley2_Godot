extends Node2D
## convert affix

var prefix_1 	:= {}
var prefix_2 	:= {}
var suffix 		:= {}



func scr_combat_weapons_fusion_affixhood(a, n, b, c, d, e = null):
	if a == "create prefix1":
		prefix_1[n] = [ b, c, d ]
	if a == "create prefix2":
		prefix_2[n] = [ b, c, d, e, null ]
	if a == "create suffix":
		suffix[n] = [ b, c, d, e, null ]

func _ready() -> void:
#region New Code Region
	
	scr_combat_weapons_fusion_affixhood("create prefix1", "empty", "empty", "empty", "");
											
	scr_combat_weapons_fusion_affixhood("create prefix1", "NoScope360",     "minus", "random", "Shots fire into random directions. N00bs only.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Polarized",      "minus", "homing", "Shots avoid enemies.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Fetching",       "minus", "bounce", "Shots return to the shooter.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Lobbing",        "minus", "curved", "Shots lob into the air.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Pensioner's",    "minus", "firing", "Shots slow down after being fired.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Afterburner",    "minus", "linear", "Shots fire from behind the braster.");
											
	
	scr_combat_weapons_fusion_affixhood("create prefix1", "Magician's",     "plus", "random", "Shots fire from around the player.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Gravitational",  "plus", "homing", "Shots seek the nearest enemy.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Ricocheting",    "plus", "bounce", "Shots ricochet off solid surfaces.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Surfing",        "plus", "curved", "Shots move in a wave pattern.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Flooding" ,      "plus", "firing", "Gun's fires multiple, wasteful shots at once.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Ghostic",        "plus", "linear", "Shots pierce through enemies.");      
											
	
	scr_combat_weapons_fusion_affixhood("create prefix1", "Goofed",         "pound", "random", "Shots are out of control.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Proximity",      "pound", "homing", "Shots fire towards nearest enemy.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Chaining",       "pound", "bounce", "Shots chain to multiple enemies.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Orbiting",       "pound", "curved", "Shots circle around the braster.");
	scr_combat_weapons_fusion_affixhood("create prefix1", "Berzerk'd",      "pound", "firing", "Gun's has anger issues.");        
	scr_combat_weapons_fusion_affixhood("create prefix1", "Dotline",        "pound", "linear", "Shots turn periodically.");
#endregion
#region New Code Region

	scr_combat_weapons_fusion_affixhood("create prefix2", "empty",          "empty",  "empty",  "empty",        "")#, statusEffect_null)

	scr_combat_weapons_fusion_affixhood("create prefix2", "Pachinkode'd",   "top",    "cosmic", "hp",           "Periodic deals LUCK % extra damage.")#,  statusEffect_pachinkoded);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Klisp'd",        "top",    "mental", "hp",           "Periodic deals PIETY % extra damage.")#, statusEffect_klispd);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Juice'd",        "top",    "bio",    "hp",           "Periodic deals MIGHT % extra damage.")#, statusEffect_juiced);                                 
	scr_combat_weapons_fusion_affixhood("create prefix2", "Parkour'd",      "top",    "cyber",  "hp",           "Periodic deals ACRO % extra damage.")#,  statusEffect_parkourd);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Impose'd",       "top",    "zauber", "hp",           "Periodic deals GUTS % extra damage.")#,  statusEffect_imposed);

	scr_combat_weapons_fusion_affixhood("create prefix2", "Gambling",       "charm",  "cosmic", "hp",           "Periodic deals 0 - 400% KOSMIC instead of normal damage.")#, statusEffect_gambling);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Agonizing",      "charm",  "mental", "hp",           "Periodic inflicts anguish that deals target MENTAL damage while moving.")#, statusEffect_agonizing);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Thorny",         "charm",  "bio",    "hp",           "Periodic inflicts target with thornball that shoots out damaging BIO thorns.")#, statusEffect_thorned, "Thorned");
	scr_combat_weapons_fusion_affixhood("create prefix2", "Deathbound",     "charm",  "cyber",  "hp",           "Periodic deals extra CYBER damage based on how many times you died.")#, statusEffect_deathbound);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Radiating",      "charm",  "zauber", "hp",           "Periodic inflicts cloud that deals ZAUBER damage to nearby enemies.")#, statusEffect_radiating);

	scr_combat_weapons_fusion_affixhood("create prefix2", "Galactic",       "bottom", "cosmic", "hp",           "Periodic deals 150% KOSMIC instead of normal damage.")#, statusEffect_galactic);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Migraining",     "bottom", "mental", "hp",           "Periodic deals 150% MENTAL instead of normal damage.")#, statusEffect_migraining);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Gooping",        "bottom", "bio",    "hp",           "Periodic deals 150% BIO instead of normal damage.")#, statusEffect_gooping);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Overloading",    "bottom", "cyber",  "hp",           "Periodic deals 150% CYBER instead of normal damage.")#, statusEffect_overloading);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Zaubering",      "bottom", "zauber", "hp",           "Periodic deals 150% ZAUBER instead of normal damage.")#, statusEffect_zaubering);

	scr_combat_weapons_fusion_affixhood("create prefix2", "KosmicBoost",    "top",    "cosmic", "capability",   "Periodic raises target KOSMIC resistence 60%, lowers other resistences 15%.")#, statusEffect_kosmicBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "MentalBoost",    "top",    "mental", "capability",   "Periodic raises target MENTAL resistence 60%, lowers other resistences 15%.")#, statusEffect_mentalBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "BioBoost",       "top",    "bio",    "capability",   "Periodic raises target BIO resistence 60%, lowers other resistences 15%.")#, statusEffect_bioBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "CyberBoost",     "top",    "cyber",  "capability",   "Periodic raises target CYBER resistence 60%, lowers other resistences 15%.")#, statusEffect_cyberBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "ZauberBoost",    "top",    "zauber", "capability",   "Periodic raises target ZAUBER resistence 60%, lowers other resistences 15%.")#, statusEffect_zauberBoost);

	scr_combat_weapons_fusion_affixhood("create prefix2", "ResistRespec",   "charm",  "cosmic", "capability",   "Periodic respecs target resistences randomly.")#, statusEffect_resistRespec);
	scr_combat_weapons_fusion_affixhood("create prefix2", "ResistLower",    "charm",  "mental", "capability",   "Periodic lowers target resistences by 20%.")#, statusEffect_resistLower);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Milkdrop",       "charm",  "bio",    "capability",   "Periodic makes target resistences go off the deep end.")#, statusEffect_resistVisual);
	scr_combat_weapons_fusion_affixhood("create prefix2", "ResistSwap",     "charm",  "cyber",  "capability",   "Periodic randomly swaps target resistences.")#, statusEffect_resistSwap);
	scr_combat_weapons_fusion_affixhood("create prefix2", "ResistEqual",    "charm",  "zauber", "capability",   "Periodic averages target resistences.")#, statusEffect_resistEqual);

	scr_combat_weapons_fusion_affixhood("create prefix2", "KosmicFallen",   "bottom", "cosmic", "capability",   "Periodic lowers target KOSMIC resistence by 30%.")#, statusEffect_kosmicFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "MentalFallen",   "bottom", "mental", "capability",   "Periodic lowers target MENTAL resistence by 30%.")#, statusEffect_mentalFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "BioFallen",      "bottom", "bio",    "capability",   "Periodic lowers target BIO resistence by 30%.")#, statusEffect_bioFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "CyberFallen",    "bottom", "cyber",  "capability",   "Periodic lowers target CYBER resistence by 30%.")#, statusEffect_cyberFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "ZauberFallen",   "bottom", "zauber", "capability",   "Periodic lowers target ZAUBER resistence by 30%.")#, statusEffect_zauberFallen);    

	scr_combat_weapons_fusion_affixhood("create prefix2", "LuckBoost",      "top",    "cosmic", "properties",   "Periodic raises LUCK 60%, lowers all other stats 15%.")#, statusEffect_luckBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "PietyBoost",     "top",    "mental", "properties",   "Periodic raises PIETY 60%, lowers all other stats 15%.")#, statusEffect_pietyBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "MightBoost",     "top",    "bio",    "properties",   "Periodic raises MIGHT 60%, lowers all other stats 15%.")#, statusEffect_mightBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "AcroBoost",      "top",    "cyber",  "properties",   "Periodic raises ACRO 60%, lowers all other stats 15%.")#, statusEffect_acroBoost);
	scr_combat_weapons_fusion_affixhood("create prefix2", "GutsBoost",      "top",    "zauber", "properties",   "Periodic raises GUTS 60%, lowers all other stats 15%.")#, statusEffect_gutsBoost);

	scr_combat_weapons_fusion_affixhood("create prefix2", "Respeccing",     "charm",  "cosmic", "properties",   "Periodic respecs target GLAMP randomly.")#, statusEffect_respeccing);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Withering",      "charm",  "mental", "properties",   "Periodic lowers target GLAMP by 20%.")#, statusEffect_withering);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Dyslexic",       "charm",  "bio",    "properties",   "Periodic makes target GLAMP go off the deep end.")#, statusEffect_dyslexic);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Hotswapping",    "charm",  "cyber",  "properties",   "Periodic randomly swaps target GLAMP.")#, statusEffect_glampSwap);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Equalizing",     "charm",  "zauber", "properties",   "Periodic averages target GLAMP.")#, statusEffect_equalizing);

	scr_combat_weapons_fusion_affixhood("create prefix2", "LuckFallen",     "bottom", "cosmic", "properties",   "Periodic lowers target LUCK by 30%.")#, statusEffect_luckFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "PietyFallen",    "bottom", "mental", "properties",   "Periodic lowers target PIETY by 30%.")#, statusEffect_pietyFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "MightFallen",    "bottom", "bio",    "properties",   "Periodic lowers target MIGHT by 30%.")#, statusEffect_mightFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "AcroFallen",     "bottom", "cyber",  "properties",   "Periodic lowers target ACRO by 30%.")#, statusEffect_acroFallen);
	scr_combat_weapons_fusion_affixhood("create prefix2", "GutsFallen",     "bottom", "zauber", "properties",   "Periodic lowers target GUTS by 30%.")#, statusEffect_gutsFallen);
																		
	scr_combat_weapons_fusion_affixhood("create prefix2", "WeightLower",    "top",    "cosmic", "weight",       "Periodic lowers target WEIGHT 50%, lowers DEFENSE 25%.")#, statusEffect_weightLower);
	scr_combat_weapons_fusion_affixhood("create prefix2", "BrainGain",      "top",    "mental", "weight",       "Periodic raises target BRAIN 100%, lowers DEFENSE 25%.")#, statusEffect_brainGain);
	scr_combat_weapons_fusion_affixhood("create prefix2", "DefenseGain",    "top",    "bio",    "weight",       "Periodic raises target DEFENSE by 50%, lowers BP by 50%.")#, statusEffect_defenseGain); 
	scr_combat_weapons_fusion_affixhood("create prefix2", "KnockGain",      "top",    "cyber",  "weight",       "Periodic raises target knockback resistence 200%, WEIGHT 25%.")#, statusEffect_knockGain); 
	scr_combat_weapons_fusion_affixhood("create prefix2", "StaggerGain",    "top",    "zauber", "weight",       "Periodic raises target stagger resistence 200%, WEIGHT 25%.")#, statusEffect_staggerGain);

	scr_combat_weapons_fusion_affixhood("create prefix2", "Pilfering",      "charm",  "cosmic", "weight",       "Periodic makes target drop a candy.")#, statusEffect_pilfering);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Adhesive",       "charm",  "mental", "weight",       "Periodic makes target immobile for 5-10 seconds.")#, statusEffect_adhesive);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Smelting",       "charm",  "bio",    "weight",       "Periodic makes target drop ammo.")#, statusEffect_smelting);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Busting",        "charm",  "cyber",  "weight",       "Periodic staggers target for 2-5 seconds.")#, statusEffect_busting);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Blinking",       "charm",  "zauber", "weight",       "Periodic teleports target to nearby location.")#, statusEffect_blinking);

	scr_combat_weapons_fusion_affixhood("create prefix2", "Heavy",          "bottom", "cosmic", "weight",       "Periodic raises target WEIGHT by 25%.")#, statusEffect_heavy);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Foggy",          "bottom", "mental", "weight",       "Periodic lowers target BRAIN by 50%.")#, statusEffect_foggy); 
	scr_combat_weapons_fusion_affixhood("create prefix2", "Risky",          "bottom", "bio",    "weight",       "Periodic lowers target DEFENSE by 25%.")#, statusEffect_risky);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Slippery",       "bottom", "cyber",  "weight",       "Periodic lowers target knockback resistence by 100%.")#, statusEffect_slippery);
	scr_combat_weapons_fusion_affixhood("create prefix2", "Goofy",          "bottom", "zauber", "weight",       "Periodic lowers target stagger resistence by 100%.")#, statusEffect_goofy);
#endregion
#region New Code Region

	scr_combat_weapons_fusion_affixhood("create suffix", "empty",                           "empty", "empty", "empty", "")#, statusEffect_null);
											 
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Dracula",                  "down", "bio", "aggressive",        "Slurp hitpoints from enemy.",)# statusEffect_dracula);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Healthy Youth",            "down", "bio", "passive",           "Bonus damage based on max hitpoints.")#, scr_combat_weapons_suffix_of_healthy);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Flicker",                      "down", "bio", "reactive",          "Bullets have a very short lifespan.")#, scr_combat_weapons_suffix_of_flicker);

	scr_combat_weapons_fusion_affixhood("create suffix", "of the Circus",                   "down", "cosmic", "aggressive",     "Rolling increases Periodic Meter.")#, scr_combat_weapons_suffix_of_circus);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Dying Youth",              "down", "cosmic", "passive",        "Bonus damage based on missing hitpoints.")#, scr_combat_weapons_suffix_of_dying);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Bad Aim",                  "down", "cosmic", "reactive",       "Braster's aim is terrible.")#, scr_combat_weapons_suffix_of_badaim);     

	scr_combat_weapons_fusion_affixhood("create suffix", "of the Clock",                    "down", "cyber", "aggressive",      "Bonus damage based on passage of time.")#, scr_combat_weapons_suffix_of_clock);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Today's Youth",            "down", "cyber", "passive",         "Bonus damage based on current hitpoints.")#, scr_combat_weapons_suffix_of_today);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Paintball",                "down", "cyber", "reactive",        "Adds a splash of paint to shots.")#, scr_combat_weapons_suffix_of_paintball);     

	scr_combat_weapons_fusion_affixhood("create suffix", "of Muramasa",                     "down", "mental", "aggressive",     "Target is pulled towards the braster.")#, statusEffect_muramasa);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Masamune",                     "down", "mental", "passive",        "Zero damage, increased knockback strength.")#, scr_combat_weapons_suffix_of_masamune);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Murasame",                     "down", "mental", "reactive",       "Braster and target are thrown about.")#, statusEffect_murasame);

	scr_combat_weapons_fusion_affixhood("create suffix", "cursed by a Wicca Hex",           "down", "zauber", "aggressive",     "Periodic Meter is broken.")#, scr_combat_weapons_suffix_cursed_by_wicca_hex);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Lich",                     "down", "zauber", "passive",        "Bonus damage based on total deaths.")#, scr_combat_weapons_suffix_of_lich);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Elements",                 "down", "zauber", "reactive",       "Bullets are imbued with elemental powers.")#, scr_combat_weapons_suffix_of_elements);
											 
	scr_combat_weapons_fusion_affixhood("create suffix", "of Leper's Digest",               "strange", "bio", "aggressive",     "While you have ammo, you lose health.")#, scr_combat_weapons_suffix_of_lepers_digest);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Chaining",                     "strange", "bio", "passive",        "Bullets chain to nearest enemy.")#, scr_combat_weapons_suffix_of_chaining);                
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Bazinga",                  "strange", "bio", "reactive",       "Bullets heal target.")#, statusEffect_bazinga);    

	scr_combat_weapons_fusion_affixhood("create suffix", "of Jeeper's Digest",              "strange", "cosmic", "aggressive",  "While you have ammo, you gain health.")#, scr_combat_weapons_suffix_of_jeepers_digest);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Dotlining",                    "strange", "cosmic", "passive",     "Bullets move in a dotline.")#, scr_combat_weapons_suffix_of_dotlining);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Sacrifice",                    "strange", "cosmic", "reactive",    "Shoot out your own lifeforce.",)# scr_combat_weapons_suffix_of_sacrifice);

	scr_combat_weapons_fusion_affixhood("create suffix", "with Nanomachines",               "strange", "cyber", "aggressive",   "Regain up to 20% of ammo.")#, scr_combat_weapons_suffix_with_nanomachines);    
	scr_combat_weapons_fusion_affixhood("create suffix", "of Ghosting",                     "strange", "cyber", "passive",      "Bullets pierce through targets.")#, scr_combat_weapons_suffix_of_ghosting);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Lets Play",                    "strange", "cyber", "reactive",     "Remember to like and subscribe.")#, scr_combat_weapons_suffix_of_letsplay);

	scr_combat_weapons_fusion_affixhood("create suffix", "with a Battery Charger",          "strange", "mental", "aggressive",  "Damage based on remaining ammo.")#, scr_combat_weapons_suffix_with_battery_charger);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Magicing",                     "strange", "mental", "passive",     "Bullets spawn from around the braster.")#, scr_combat_weapons_suffix_of_magicing);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Pacifist",                 "strange", "mental", "reactive",    "Bullets don't deal damage.")#, scr_combat_weapons_suffix_of_pacifist);

	scr_combat_weapons_fusion_affixhood("create suffix", "of Reaper's Digest",              "strange", "zauber", "aggressive",  "While you have ammo, everyone is immortal.")#, scr_combat_weapons_suffix_of_reapers_digest);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Surfing",                      "strange", "zauber", "passive",     "Bullets move in a wave pattern.")# scr_combat_weapons_suffix_of_surfing);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Triskelion",                   "strange", "zauber", "reactive",    "Deals 9999 damage while in Triskelion.")#, scr_combat_weapons_suffix_of_triskelion); 
											
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Entlord",                  "up", "bio", "aggressive",          "Bonus BIO damage.")#, scr_combat_weapons_suffix_of_entlord);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Iceman",                   "up", "bio", "passive",             "Bonus damage based on enemies defeated.")#, scr_combat_weapons_suffix_of_iceman);
	scr_combat_weapons_fusion_affixhood("create suffix", "with a hole in the Pocket",       "up", "bio", "reactive",            "Ammo depletes constantly.")#, scr_combat_weapons_suffix_with_hole_in_pocket);

	scr_combat_weapons_fusion_affixhood("create suffix", "of the Quasar",                   "up", "cosmic", "aggressive",       "Bonus KOSMIC damage.")#, scr_combat_weapons_suffix_of_quasar);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Perfectionist",            "up", "cosmic", "passive",          "Bonus damage when at full health.")#, scr_combat_weapons_suffix_of_perfectionist);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Eternity",                     "up", "cosmic", "reactive",         "Bullet have increased lifespans.")#, scr_combat_weapons_suffix_of_eternity);

	scr_combat_weapons_fusion_affixhood("create suffix", "of the Doxxer",                   "up", "cyber", "aggressive",        "Bonus CYBER damage.")#, scr_combat_weapons_suffix_of_doxxer);   
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Metallic Muscle",          "up", "cyber", "passive",           "Bonus damage based on Transhumanism.")#, scr_combat_weapons_suffix_of_muscle);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Planet of Vapes",          "up", "cyber", "reactive",          "Guns are of the Planet of the Vapes.")#, scr_combat_weapons_suffix_of_vaping);

	scr_combat_weapons_fusion_affixhood("create suffix", "of the Encephalon",               "up", "mental", "aggressive",       "Bonus MENTAL damage.")#, scr_combat_weapons_suffix_of_encephalon);    
	scr_combat_weapons_fusion_affixhood("create suffix", "from Heck",                       "up", "mental", "passive",          "Damage varies from 0x to 2.5x.")#, scr_combat_weapons_suffix_from_heck);
	scr_combat_weapons_fusion_affixhood("create suffix", "of Deep Welling",                 "up", "mental", "reactive",         "Periodic Meter increases constantly.")#, scr_combat_weapons_suffix_of_welling);

	scr_combat_weapons_fusion_affixhood("create suffix", "of the Ps. Pocus",                "up", "zauber", "aggressive",       "Bonus ZAUBER damage.")#, scr_combat_weapons_suffix_of_pseudohocus);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Becker",                   "up", "zauber", "passive",          "Damn slow, but damn hard-hitter!")#, scr_combat_weapons_suffix_of_becker);
	scr_combat_weapons_fusion_affixhood("create suffix", "of the Forever Man",              "up", "zauber", "reactive",         "Gun's sacrifices itself to save braster.")#, scr_combat_weapons_suffix_of_forever_man);
#endregion
	
	print( "const prefix_1 : Dictionary = %s" % str(prefix_1) )
	print( "const prefix_2 : Dictionary = %s" % str(prefix_2) )
	print( "const suffix : Dictionary = %s" % str(suffix) )
