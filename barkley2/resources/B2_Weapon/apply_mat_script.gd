extends Resource
# @tutorial(https://www.youtube.com/watch?v=IdAmkx8eAos)
# check scr_combat_weapons_applyMaterial

## This is a direct copy of the scr_combat_weapons_applyMaterial script. Cant think of a better way to deal with this.
# What a mess...

const c_white := Color.WHITE

static func apply_material( gun : B2_Weapon, material : B2_Gun.MATERIAL ) -> void:
	
	var _pow 		: float= 1; # Power Modifier
	var _pmx 		: float= 1; # Power Max Modifier
	var _spd 		: float= 1; # Speed Modifier
	var _acc 		: float= 1; # Accuracy Modifier
	var _rng 		: float= 1; # Range Modifier
	var _amm 		: float= 1; # Ammo Modifier
	var _afx 		: float= 1; # Affix Modifier

	var _wgt 		: float= 1; # Weight Modifier

	var _kbc 		: float= 1; # Knockback Modifier
	var _stn 		: float= 1; # Stagger Modifier

	var _pattern 	:= "";
	var col 		:= c_white;
	var gunheldcol 	:= c_white;
	
	match B2_Gun.MATERIAL_NAMES.get(material):
		"Candy":
			_pow = 0.700;
			_pmx = 0.760;
			_spd = 0.881;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.520;
			_afx = 2.200;
			_wgt = 1.700;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 0;
			col = c_white;
			
		"3D Printed":
			_pow = 0.700;
			_pmx = 0.730;
			_spd = 0.880;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.760;
			_afx = 0.670;
			_wgt = 1.050;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 1;
			col = c_white;
			
		"Soiled":
			_pow = 0.712;
			_pmx = 0.742;
			_spd = 0.887;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.712;
			_afx = 0.712;
			_wgt = 1.031;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 2;
			col = c_white;
			
		"Rotten":
			_pow = 0.720;
			_pmx = 0.724;
			_spd = 0.890;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.720;
			_afx = 0.720;
			_wgt = 1.040;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 3;
			col = c_white;
			
		"Broken":
			_pow = 0.718;
			_pmx = 0.742;
			_spd = 0.892;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.728;
			_afx = 0.728;
			_wgt = 1.048;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 4;
			col = c_white;
			
		"Carbon":
			_pow = 0.718;
			_pmx = 0.745;
			_spd = 0.893;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.730;
			_afx = 0.732;
			_wgt = 1.100;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 5;
			col = c_white;
			
		"Mythril":
			_pow = 0.640;
			_pmx = 0.743;
			_spd = 0.850;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.740;
			_afx = 0.740;
			_wgt = 1.500;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 6;
			col = c_white;
			
		"Rusty":
			_pow = 0.748;
			_pmx = 0.748;
			_spd = 0.897;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.748;
			_afx = 0.748;
			_wgt = 1.070;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 7;
			col = c_white;
			
		"Junk":
			_pow = 0.759;
			_pmx = 0.940;
			_spd = 0.850;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.759;
			_afx = 0.759;
			_wgt = 1.084;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 8;
			col = c_white;
			
		"Neon":
			_pow = 0.700;
			_pmx = 0.700;
			_spd = 0.901;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.778;
			_afx = 0.700;
			_wgt = 0.890;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 9;
			col = c_white;
			
		"Salt":
			_pow = 0.766;
			_pmx = 0.784;
			_spd = 0.904;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.775;
			_afx = 0.775;
			_wgt = 1.101;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 10;
			col = c_white;
			
		"Wood":
			_pow = 0.868;
			_pmx = 0.946;
			_spd = 0.946;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.820;
			_afx = 0.580;
			_wgt = 1.400;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 11;
			col = c_white;
			
		"Aluminum":
			_pow = 0.791;
			_pmx = 0.791;
			_spd = 0.909;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.791;
			_afx = 0.791;
			_wgt = 1.119;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 12;
			col = c_white;
			
		"Glass":
			_pow = 0.795;
			_pmx = 0.795;
			_spd = 0.910;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.795;
			_afx = 0.795;
			_wgt = 1.123;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 13;
			col = c_white;
			
		"Plastic":
			_pow = 0.700;
			_pmx = 0.760;
			_spd = 0.913;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.844;
			_afx = 0.706;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 14;
			col = c_white;
			
		"Leather":
			_pow = 0.811;
			_pmx = 0.811;
			_spd = 0.914;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.811;
			_afx = 0.811;
			_wgt = 1.141;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 15;
			col = c_white;
			
		"Studded":
			_pow = 0.998;
			_pmx = 0.998;
			_spd = 0.917;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.836;
			_afx = 0.790;
			_wgt = 1.390;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 16;
			col = c_white;
			
		"Dual":
			_pow = 0.843;
			_pmx = 0.843;
			_spd = 0.922;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.843;
			_afx = 0.843;
			_wgt = 1.176;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 17;
			col = c_white;
			
		"Plantain":
			_pow = 0.839;
			_pmx = 0.839;
			_spd = 0.921;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.820;
			_afx = 0.892;
			_wgt = 1.172;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 18;
			col = c_white;
			
		"Bone":
			_pow = 0.958;
			_pmx = 0.958;
			_spd = 0.922;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.580;
			_afx = 0.616;
			_wgt = 1.100;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 19;
			col = c_white;
			
		"Aluminium":
			_pow = 0.760;
			_pmx = 0.760;
			_spd = 0.928;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.736;
			_afx = 0.820;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 20;
			col = c_white;
			
		"Titanium":
			_pow = 1.360;
			_pmx = 1.360;
			_spd = 0.931;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.976;
			_afx = 0.622;
			_wgt = 1.211;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 21;
			col = c_white;
			
		"Stone":
			_pow = 0.826;
			_pmx = 0.826;
			_spd = 0.934;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.790;
			_afx = 1.150;
			_wgt = 1.330;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 22;
			col = c_white;
			
		"Chrome":
			_pow = 0.940;
			_pmx = 0.940;
			_spd = 0.935;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.850;
			_afx = 0.850;
			_wgt = 1.230;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 23;
			col = c_white;
			
		"Frankincense":
			_pow = 0.902;
			_pmx = 0.902;
			_spd = 0.938;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.902;
			_afx = 0.902;
			_wgt = 1.242;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 24;
			col = c_white;
			
		"Iron":
			_pow = 0.906;
			_pmx = 0.906;
			_spd = 0.939;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.906;
			_afx = 0.906;
			_wgt = 1.247;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 25;
			col = c_white;
			
		"Cobalt":
			_pow = 0.918;
			_pmx = 0.918;
			_spd = 0.942;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.918;
			_afx = 0.918;
			_wgt = 1.260;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 26;
			col = c_white;
			
		"Nickel":
			_pow = 0.918;
			_pmx = 0.918;
			_spd = 0.942;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.918;
			_afx = 0.918;
			_wgt = 1.260;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 27;
			col = c_white;
			
		"Copper":
			_pow = 0.938;
			_pmx = 0.938;
			_spd = 0.948;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.938;
			_afx = 0.938;
			_wgt = 1.282;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 28;
			col = c_white;
			
		"Zinc":
			_pow = 0.942;
			_pmx = 0.942;
			_spd = 0.949;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.942;
			_afx = 0.942;
			_wgt = 1.286;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 29;
			col = c_white;
			
		"Fiberglass":
			_pow = 0.962;
			_pmx = 0.962;
			_spd = 0.954;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.962;
			_afx = 0.962;
			_wgt = 1.308;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 30;
			col = c_white;
			
		"Grass":
			_pow = 0.974;
			_pmx = 0.974;
			_spd = 0.957;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.974;
			_afx = 0.974;
			_wgt = 1.322;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 31;
			col = c_white;
			
		"Soy":
			_pow = 0.981;
			_pmx = 0.981;
			_spd = 0.959;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.981;
			_afx = 0.981;
			_wgt = 1.330;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 32;
			col = c_white;
			
		"Steel":
			_pow = 1.000;
			_pmx = 1.000;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.000;
			_afx = 1.000;
			_wgt = 1.350;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 33;
			col = c_white;
			
		"Brass":
			_pow = 1.001;
			_pmx = 1.001;
			_spd = 0.965;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.001;
			_afx = 1.001;
			_wgt = 1.352;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 34;
			col = c_white;
			
		"Orichalcum":
			_pow = 1.017;
			_pmx = 1.017;
			_spd = 1.060;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.850;
			_afx = 1.180;
			_wgt = 1.200;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 35;
			col = c_white;
			
		"Napalm":
			_pow = 1.021;
			_pmx = 1.021;
			_spd = 0.970;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.021;
			_afx = 1.021;
			_wgt = 1.374;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 36;
			col = c_white;
			
		"Origami":
			_pow = 0.880;
			_pmx = 0.880;
			_spd = 0.973;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 0.880;
			_afx = 0.580;
			_wgt = 0.500;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 37;
			col = c_white;
			
		"Offal":
			_pow = 1.037;
			_pmx = 1.037;
			_spd = 0.974;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.037;
			_afx = 1.037;
			_wgt = 1.392;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 38;
			col = c_white;
			
		"Crystal":
			_pow = 1.045;
			_pmx = 1.045;
			_spd = 0.976;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.045;
			_afx = 1.045;
			_wgt = 1.401;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 39;
			col = c_white;
			
		"Adamantium":
			_pow = 1.053;
			_pmx = 1.053;
			_spd = 0.978;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.053;
			_afx = 1.053;
			_wgt = 1.410;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 40;
			col = c_white;
			
		"Silk":
			_pow = 1.065;
			_pmx = 1.065;
			_spd = 0.981;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.065;
			_afx = 1.065;
			_wgt = 1.423;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 41;
			col = c_white;
			
		"Marble":
			_pow = 1.073;
			_pmx = 1.073;
			_spd = 0.984;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.073;
			_afx = 1.073;
			_wgt = 1.432;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 42;
			col = c_white;
			
		"Rubber":
			_pow = 1.085;
			_pmx = 1.085;
			_spd = 0.987;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.085;
			_afx = 1.085;
			_wgt = 1.445;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 43;
			col = c_white;
			
		"Foil":
			_pow = 1.093;
			_pmx = 1.093;
			_spd = 0.989;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.093;
			_afx = 1.093;
			_wgt = 1.454;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 44;
			col = c_white;
			
		"Blood":
			_pow = 1.104;
			_pmx = 1.104;
			_spd = 0.992;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.104;
			_afx = 1.104;
			_wgt = 1.467;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 45;
			col = c_white;
			
		"Silver":
			_pow = 1.112;
			_pmx = 1.112;
			_spd = 0.994;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.112;
			_afx = 1.112;
			_wgt = 1.476;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 46;
			col = c_white;
			
		"Chitin":
			_pow = 1.128;
			_pmx = 1.128;
			_spd = 0.998;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.128;
			_afx = 1.128;
			_wgt = 1.493;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 47;
			col = c_white;
			
		"Sinew":
			_pow = 1.140;
			_pmx = 1.140;
			_spd = 1.002;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.140;
			_afx = 1.140;
			_wgt = 1.507;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 48;
			col = c_white;
			
		"Tin":
			_pow = 1.156;
			_pmx = 1.156;
			_spd = 1.006;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.156;
			_afx = 1.156;
			_wgt = 1.524;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 49;
			col = c_white;
			
		"Obsidian":
			_pow = 1.168;
			_pmx = 1.168;
			_spd = 1.009;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.168;
			_afx = 1.168;
			_wgt = 1.537;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 50;
			col = c_white;
			
		"Fungus":
			_pow = 1.192;
			_pmx = 1.192;
			_spd = 1.015;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.192;
			_afx = 1.192;
			_wgt = 1.564;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 51;
			col = c_white;
			
		"Damascus":
			_pow = 1.188;
			_pmx = 1.188;
			_spd = 1.014;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.188;
			_afx = 1.188;
			_wgt = 1.559;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 52;
			col = c_white;
			
		"Analog":
			_pow = 1.204;
			_pmx = 1.204;
			_spd = 1.019;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.204;
			_afx = 1.204;
			_wgt = 1.577;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 53;
			col = c_white;
			
		"Digital":
			_pow = 1.211;
			_pmx = 1.211;
			_spd = 1.021;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.211;
			_afx = 1.211;
			_wgt = 1.586;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 54;
			col = c_white;
			
		"Brain":
			_pow = 1.227;
			_pmx = 1.227;
			_spd = 1.025;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.227;
			_afx = 1.227;
			_wgt = 1.604;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 55;
			col = c_white;
			
		"Chobham":
			_pow = 1.235;
			_pmx = 1.235;
			_spd = 1.027;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.235;
			_afx = 1.235;
			_wgt = 1.612;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 56;
			col = c_white;
			
		"Bronze":
			_pow = 1.390;
			_pmx = 1.390;
			_spd = 1.068;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.390;
			_afx = 1.390;
			_wgt = 1.784;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 57;
			col = c_white;
			
		"Blaster":
			_pow = 1.402;
			_pmx = 1.402;
			_spd = 1.071;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.402;
			_afx = 1.402;
			_wgt = 1.797;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 58;
			col = c_white;
			
		"Tungsten":
			_pow = 1.414;
			_pmx = 1.414;
			_spd = 1.075;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.414;
			_afx = 1.414;
			_wgt = 1.811;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 59;
			col = c_white;
			
		"Itano":
			_pow = 1.422;
			_pmx = 1.422;
			_spd = 1.077;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.422;
			_afx = 1.422;
			_wgt = 1.819;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 60;
			col = c_white;
			
		"Pearl":
			_pow = 1.420;
			_pmx = 1.540;
			_spd = 1.081;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.540;
			_afx = 1.300;
			_wgt = 1.837;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 61;
			col = c_white;
			
		"Myrrh":
			_pow = 1.445;
			_pmx = 1.445;
			_spd = 1.083;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.445;
			_afx = 1.445;
			_wgt = 1.846;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 62;
			col = c_white;
			
		"Platinum":
			_pow = 1.457;
			_pmx = 1.457;
			_spd = 1.086;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.457;
			_afx = 1.457;
			_wgt = 1.859;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 63;
			col = c_white;
			
		"Gold":
			_pow = 1.465;
			_pmx = 1.465;
			_spd = 1.088;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.465;
			_afx = 1.465;
			_wgt = 1.868;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 64;
			col = c_white;
			
		"Mercury":
			_pow = 1.477;
			_pmx = 1.477;
			_spd = 1.091;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.477;
			_afx = 1.477;
			_wgt = 1.881;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 65;
			col = c_white;
			
		"Imaginary":
			_pow = 1.493;
			_pmx = 1.493;
			_spd = 1.096;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.493;
			_afx = 1.493;
			_wgt = 1.899;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 66;
			col = c_white;
			
		"Lead":
			_pow = 1.505;
			_pmx = 1.505;
			_spd = 1.099;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.505;
			_afx = 1.505;
			_wgt = 1.912;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 67;
			col = c_white;
			
		"Diamond":
			_pow = 1.513;
			_pmx = 1.513;
			_spd = 1.101;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.513;
			_afx = 1.513;
			_wgt = 1.921;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 68;
			col = c_white;
			
		"Polenta":
			_pow = 1.513;
			_pmx = 1.513;
			_spd = 1.101;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.513;
			_afx = 1.513;
			_wgt = 1.921;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 69;
			col = c_white;
			
		"Yggdrasil":
			_pow = 1.517;
			_pmx = 1.517;
			_spd = 1.102;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.517;
			_afx = 1.517;
			_wgt = 1.925;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 70;
			col = c_white;
			
		"Pinata":
			_pow = 1.564;
			_pmx = 1.564;
			_spd = 1.115;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.564;
			_afx = 1.564;
			_wgt = 1.978;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 71;
			col = c_white;
			
		"Francium":
			_pow = 1.568;
			_pmx = 1.568;
			_spd = 1.116;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.568;
			_afx = 1.568;
			_wgt = 1.982;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 72;
			col = c_white;
			
		"Orb":
			_pow = 1.580;
			_pmx = 1.660;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.510;
			_afx = 1.810;
			_wgt = 1.996;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 73;
			col = c_white;
			
		"Nanotube":
			_pow = 1.540;
			_pmx = 1.660;
			_spd = 1.120;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.584;
			_afx = 1.584;
			_wgt = 2.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 74;
			col = c_white;
			
		"Taxidermy":
			_pow = 1.000;
			_pmx = 1.000;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.000;
			_afx = 1.000;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 75;
			col = c_white;
			
		"Porcelain":
			_pow = 1.000;
			_pmx = 1.000;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.000;
			_afx = 1.000;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 76;
			col = c_white;
			
		"Anti-Matter":
			_pow = 1.000;
			_pmx = 1.000;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.000;
			_afx = 1.000;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 77;
			col = c_white;
			
		"Aerogel":
			_pow = 1.000;
			_pmx = 1.000;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.000;
			_afx = 1.000;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 78;
			col = c_white;
			
		"Denim":
			_pow = 1.000;
			_pmx = 1.000;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.000;
			_afx = 1.000;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 79;
			col = c_white;
			
		"Untamonium":
			_pow = 1.000;
			_pmx = 1.000;
			_spd = 1.000;
			_acc = 1.000;
			_rng = 1.000;
			_amm = 1.000;
			_afx = 1.000;
			_wgt = 1.000;
			col = Color8(190,200,190);
			gunheldcol = col;
			# gun[?"hudIconFrame"] = 80;
			col = c_white;
		_:
			push_error( "Unknown material: %s" % B2_Gun.MATERIAL_NAMES.get(material) )
			breakpoint
			
	if _pattern != "":
		gun.weapon_stats.pPattern		= _pattern
	gun.weapon_stats.pPowerMod 		*= _pow
	gun.weapon_stats.pPowerMaxMod 	*= _pmx
	gun.weapon_stats.pSpeedMod 		*= _spd

	gun.weapon_stats.pRangeMod		= _rng
	gun.weapon_stats.pAmmoMod 		*= _amm
	gun.weapon_stats.pAffixMod 		*= _afx

	gun.weapon_stats.pWeightMod 	*= _wgt

	gun.weapon_stats.pKnockback 	*= _kbc
	gun.weapon_stats.pStagger 		*= _stn
	
	## Weird, the script doesnt seem to add some variables, like colors, to the gun...
