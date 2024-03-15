extends Control

onready var player_coins = $CoinsTitle/PlayerCoins
onready var agility_buttons = $AgilityContainer.get_children()
onready var stamina_buttons = $StaminaContainer.get_children()
onready var strength_buttons = $StrengthContainer.get_children()

onready var agility_info = $AgilityInfo
onready var stamina_info = $StaminaInfo
onready var strength_info = $StrengthInfo

var selected_group
var selected_level

# level:[upgrade_percent,price]
var level_stats = global.level_stats

func _ready():
	close_other_item_info()
	close_other_selection()
	refresh_display()

func refresh_display():
	player_coins.text = str(global.player_coins)
	for i in range(agility_buttons.size()):
		agility_buttons[i].upgrade_group = "Agility"
		agility_buttons[i].upgrade_level = i+1
		agility_buttons[i].upgrade_percent = level_stats[i+1][0]
		agility_buttons[i].upgrade_price = level_stats[i+1][1]
		agility_buttons[i].upgrade_desc = "Your move speed will be increased by " + str(agility_buttons[i].upgrade_percent) + "%"
		agility_buttons[i].upgrade_bought = global.player_bought_stats[agility_buttons[i].upgrade_group][agility_buttons[i].upgrade_level]
		
		if agility_buttons[i].upgrade_bought:
			agility_buttons[i].get_node("ShopDisplay/Locked").visible = true
	
	for i in range(strength_buttons.size()):
		strength_buttons[i].upgrade_group = "Strength"
		strength_buttons[i].upgrade_level = i+1
		strength_buttons[i].upgrade_percent = level_stats[i+1][0]
		strength_buttons[i].upgrade_price = level_stats[i+1][1]
		strength_buttons[i].upgrade_desc = "Your max carry weight will be increased by " + str(strength_buttons[i].upgrade_percent) + "%"
		strength_buttons[i].upgrade_bought = global.player_bought_stats[strength_buttons[i].upgrade_group][strength_buttons[i].upgrade_level]

		if strength_buttons[i].upgrade_bought:
			strength_buttons[i].get_node("ShopDisplay/Locked").visible = true

	for i in range(stamina_buttons.size()):
		stamina_buttons[i].upgrade_group = "Stamina"
		stamina_buttons[i].upgrade_level = i+1
		stamina_buttons[i].upgrade_percent = level_stats[i+1][0]
		stamina_buttons[i].upgrade_price = level_stats[i+1][1]
		stamina_buttons[i].upgrade_desc = "Your max stamina will be increased by " + str(stamina_buttons[i].upgrade_percent) + "%"
		stamina_buttons[i].upgrade_bought = global.player_bought_stats[stamina_buttons[i].upgrade_group][stamina_buttons[i].upgrade_level]
		
		if stamina_buttons[i].upgrade_bought:
			stamina_buttons[i].get_node("ShopDisplay/Locked").visible = true
	
func close_other_item_info():
	$AgilityInfo.visible = false
	$StrengthInfo.visible = false
	$StaminaInfo.visible = false

func roman(upgrade_level):
	var upgrade_level_text
	match upgrade_level:
		1:
			upgrade_level_text = "I"
		2:
			upgrade_level_text = "II"
		3:
			upgrade_level_text = "III"
	
	return upgrade_level_text

func display_item_info(upgrade_group, upgrade_level, upgrade_price, upgrade_desc, upgrade_bought):
	var upgrade_level_text = roman(upgrade_level)
	
	match upgrade_group:
		"Agility":
			var title = agility_info.get_node("LabelTitle")
			title.text = upgrade_group + " " + upgrade_level_text
			
			var price = agility_info.get_node("Price")
			price.text = str(upgrade_price)
			
			var desc = agility_info.get_node("Label")
			desc.text = upgrade_desc
			
			if upgrade_bought:
				price.text = "Sold out!"
			
			agility_info.visible = true
		
		"Strength":
			var title = strength_info.get_node("LabelTitle")
			title.text = upgrade_group + " " + upgrade_level_text
			
			var price = strength_info.get_node("Price")
			price.text = str(upgrade_price)
			
			var desc = strength_info.get_node("Label")
			desc.text = upgrade_desc
			
			if upgrade_bought:
				price.text = "Sold out!"
			
			strength_info.visible = true
		
		"Stamina":
			var title = stamina_info.get_node("LabelTitle")
			title.text = upgrade_group + " " + upgrade_level_text
			
			var price = stamina_info.get_node("Price")
			price.text = str(upgrade_price)
			
			var desc = stamina_info.get_node("Label")
			desc.text = upgrade_desc
			
			if upgrade_bought:
				price.text = "Sold out!"
			
			stamina_info.visible = true

func close_other_selection():
	for i in range(agility_buttons.size()):
		agility_buttons[i].get_node("Selected").visible = false
	
	for i in range(strength_buttons.size()):
		strength_buttons[i].get_node("Selected").visible = false
	
	for i in range(stamina_buttons.size()):
		stamina_buttons[i].get_node("Selected").visible = false

func set_selection(upgrade_group, upgrade_level):
	match upgrade_group:
		"Agility":
			agility_buttons[upgrade_level-1].get_node("Selected").visible = true
		"Strength":
			strength_buttons[upgrade_level-1].get_node("Selected").visible = true
		"Stamina":
			stamina_buttons[upgrade_level-1].get_node("Selected").visible = true
	self.selected_group = upgrade_group
	self.selected_level = upgrade_level

func _on_BackButton_pressed():
	menu_bgm.click()
	get_tree().change_scene("res://Scenes/Main Menu/MainMenu.tscn")


func _on_BuyButton_pressed():
	menu_bgm.click()
	var player_coins = global.player_coins
	var price = level_stats[selected_level][1]
	
	if player_coins >= price:
		global.player_bought_stats[selected_group][selected_level] = 1
		global.player_coins -= price
		print("bought " + selected_group + " level " + str(selected_level))
		$Purchased.text = ""
		$Purchased.visible = false
		$NotEnoughMoney.visible = false
		$Purchased.text = selected_group + " " + roman(selected_level) + " purchased!"
		$Purchased.visible = true
		refresh_display()
		close_other_selection()
	else:
		$Purchased.visible = false
		$NotEnoughMoney.visible = true
		print("Not enough money!")
	
	yield(get_tree().create_timer(2), "timeout")
	$Purchased.visible = false
	$NotEnoughMoney.visible = false
	
