extends Control

onready var required_item_gui = get_parent().get_parent().get_node("ItemList")
onready var player = get_tree().root.get_child(2).get_node("Player")

func _on_Button_mouse_entered():
	if !player.gui_opened:
		required_item_gui.visible = true
		player.gui_opened = true

func _on_Button_mouse_exited():
	required_item_gui.visible = false
	player.gui_opened = false
