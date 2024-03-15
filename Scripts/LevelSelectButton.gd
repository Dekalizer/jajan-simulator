extends Control

onready var level_selection_menu = get_parent().get_parent()
onready var level_info = get_node("LevelInfo/VBoxContainer2").get_children()

var difficulty
var obstacle_count
var time_limit
var reward_multiplier
var required_item_types
var required_item_qty

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_difficulty():
	match difficulty:
		1:
			obstacle_count = 2
			time_limit = 180
			reward_multiplier = 0.5
			required_item_types = 4
			required_item_qty = [1, 3]  # Range from 1 to 3
		2:
			obstacle_count = 4
			time_limit = 150
			reward_multiplier = 1.0
			required_item_types = 6
			required_item_qty = [2, 4]  # Range from 2 to 4
		3:
			obstacle_count = 6
			time_limit = 120
			reward_multiplier = 1.5
			required_item_types = 8
			required_item_qty = [3, 5]  # Range from 3 to 5
		4:
			obstacle_count = 8
			time_limit = 90
			reward_multiplier = 2.0
			required_item_types = 10
			required_item_qty = [4, 6]  # Range from 4 to 6
		5:
			obstacle_count = 10
			time_limit = 60
			reward_multiplier = 2.5
			required_item_types = 12
			required_item_qty = [5, 7]  # Range from 5 to 7

func update_level_info_display():
	set_difficulty()
	level_info[0].text = str(time_limit) + " seconds"
	level_info[1].text = str(obstacle_count) + " pcs"
	level_info[2].text = str(reward_multiplier) + " x"
	level_info[3].text = str(required_item_types) + " types"
	level_info[4].text = str(required_item_qty[0]) + " - " + str(required_item_qty[1]) + " pcs"


func _on_LevelSelectButton_pressed():
	menu_bgm.click()
	update_level_info_display()
	level_selection_menu.close_other_level_detail()
	level_selection_menu.close_other_selection()
	level_selection_menu.set_difficulty(difficulty)
	$LevelInfo.visible = true
