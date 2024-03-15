extends Control

onready var player = get_tree().root.get_child(2).get_node("Player")
onready var level = get_tree().root.get_child(2)
onready var gui = get_tree().root.get_child(2).get_node("Player/UI/CashierGUI")
onready var bottom_gui = get_tree().root.get_child(2).get_node("Player/UI/BottomUI")
onready var update_items = get_parent().get_node("ContinueShoppingButton")

func _on_Button_pressed():
	print("finishing level!")
	update_items.update_items()
	level.finish_level()
	
