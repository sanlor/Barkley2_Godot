extends Control

## CHaracter creation. Lots of objects are involved in this.

# o_cc_data holds some important data
# o_cc_effect_crystal - Some kind of effect, not sure
# o_cc_effect_backdrop - Some kind of effect, particules, aparently
# 
# Events are in this order:
# o_cc_wizard - wizar apears, moves hands and talk:
# o_cc_name - Player adds its name and handles text displaying
## FOCUS ON THESE ONES ^^^^^^^^

#// Draw wizard //
#if timer_ready_to_proceed <= 0 then 
	#{
	#draw_sprite_ext(s_cc_wizard_base, 6, 192, 120, 1, 1, 0, c_white, alpha);
	#if alpha = 1 then draw_sprite_ext(s_cc_wizard_talk, image_index_head, 195, 75, 1, 1, 0, c_white, 1);
	#if emote = true then draw_sprite_ext(s_cc_wizard_emote, image_index_emote, 195, 75, 1, 1, 0, c_white, 1);
	#}
#else draw_sprite_ext(s_cc_wizard_base, image_index_intro, 192, 120, 1, 1, 0, c_white, alpha);
#
#// Draw a screen for charcreation intro //
#if alpha_2 > 0 then
	#{
	#draw_set_alpha(alpha_2);
	#draw_set_color(c_black);
	#draw_rectangle(-2, -2, 386, 242, false);
	#}


#ds_list_add(dsl, o_cc_rune, o_cc_hand_scanner, o_cc_inkblots, o_cc_multiple, o_cc_palm_reading, o_cc_lottery, o_cc_likes_favorites);
#//stage[i] = o_cc_crest; i += 1;
#stage[i] = o_cc_name; i += 1;
#stage[i] = o_cc_zodiac; i += 1;
#stage[i] = o_cc_blood; i += 1;
#stage[i] = o_cc_gender; i += 1;
#stage[i] = o_cc_alignment; i += 1;
#stage[i] = o_cc_crest; i += 1;
#stage[i] = o_cc_tarot; i += 1;
#stage[i] = o_cc_gumball; i += 1;
#stage[i] = o_cc_placenta; i += 1;
#stage[i] = ds_list_find_value(dsl, 0); i += 1;
#stage[i] = o_cc_placenta; i += 1;
#stage[i] = ds_list_find_value(dsl, 1); i += 1;
#stage[i] = o_cc_placenta; i += 1;
#stage[i] = ds_list_find_value(dsl, 2); i += 1;
#stage[i] = o_cc_placenta; i += 1;
#stage[i] = ds_list_find_value(dsl, 3); i += 1;
#stage[i] = o_cc_placenta; i += 1;
#stageIndex = 0;
#ds_list_destroy(dsl);
#
#sprite_index_head = s_cc_wizard_talk;
