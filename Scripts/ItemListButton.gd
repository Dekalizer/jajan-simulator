extends Control

onready var required_item_gui = get_parent().get_parent().get_node("ItemList")

func _on_Button_mouse_entered():
	required_item_gui.visible = true

func _on_Button_mouse_exited():
	required_item_gui.visible = false
