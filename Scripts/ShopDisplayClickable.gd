extends Control

onready var shop = get_parent().get_parent()

var upgrade_group
var upgrade_percent 
var upgrade_level
var upgrade_desc
var upgrade_price
var upgrade_bought


func _on_BuyItemButton_pressed():
	if !upgrade_bought:
		shop.close_other_selection()
		shop.set_selection(upgrade_group, upgrade_level)

func _on_BuyItemButton_mouse_entered():
	shop.close_other_item_info()
	shop.display_item_info(upgrade_group, upgrade_level, upgrade_price, upgrade_desc, upgrade_bought)

func _on_BuyItemButton_mouse_exited():
	shop.close_other_item_info()
