extends Control

const MENU_WPN_DATA = preload("uid://cnkroip8gbsn1")

signal selected_enemy( enemy : B2_EnemyCombatActor )
signal weapon_selected

@onready var weapon_stats_vbox: VBoxContainer = $weapon_stats/MarginContainer/weapon_stats_vbox
