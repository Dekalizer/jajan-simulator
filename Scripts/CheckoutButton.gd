extends Control

onready var player = get_tree().root.get_child(1).get_node("Player")
onready var level = get_tree().root.get_child(1)
onready var gui = get_tree().root.get_child(1).get_node("Player/UI/CashierGUI")
onready var bottom_gui = get_tree().root.get_child(1).get_node("Player/UI/BottomUI")

func _on_Button_pressed():
	print("finishing level!")
	level.finish_level()
	
