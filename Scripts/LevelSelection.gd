extends Control

onready var level_buttons = get_node("HBoxContainer").get_children()

var difficulty
var obstacle_count
var time_limit
var reward_multiplier
var required_item_types
var required_item_qty

# Called when the node enters the scene tree for the first time.
func _ready():
	close_other_level_detail()
	close_other_selection()
	# Set the level's difficulty for each level selection button
	for i in range(level_buttons.size()):
		level_buttons[i].difficulty = i+1

func set_difficulty(diff):
	difficulty = diff
	level_buttons[diff-1].get_node("SelectItem").visible = true
	match diff:
		1:
			obstacle_count = 2
			time_limit = 180
			reward_multiplier = 0.5
			required_item_types = 5
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

func close_other_level_detail():
	for level in level_buttons:
		level.get_node("LevelInfo").visible = false

func close_other_selection():
	for level in level_buttons:
		level.get_node("SelectItem").visible = false

func _on_StartGameButton_pressed():
	menu_bgm.click()
	if !difficulty == null:
		global.difficulty = self.difficulty
		get_tree().change_scene("res://Scenes/MainLevel.tscn")

func _on_BackButton_pressed():
	menu_bgm.click()
	get_tree().change_scene("res://Scenes/Main Menu/MainMenu.tscn")
