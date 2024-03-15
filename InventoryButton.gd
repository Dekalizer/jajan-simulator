extends Control

onready var inventory = get_parent().get_parent().get_node("Inventory")
onready var player = get_tree().root.get_child(2).get_node("Player")

func _on_Button_mouse_entered():
	if !player.gui_opened:
		inventory.visible = true
		player.gui_opened = true

func _on_Button_mouse_exited():
	inventory.visible = false
	player.gui_opened = false
