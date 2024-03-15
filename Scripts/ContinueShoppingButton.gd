extends Control

onready var player = get_tree().root.get_child(2).get_node("Player")
onready var gui = get_tree().root.get_child(2).get_node("Player/UI/CashierGUI")
onready var inventory = gui.get_node("Inventory/GridContainer").get_children()
onready var cashier = gui.get_node("Cashier/GridContainer").get_children()
onready var bottom_gui = get_tree().root.get_child(2).get_node("Player/UI/BottomUI")

func _on_Button_pressed():
	update_items()
	player.enable_move()
	player.set_gui_opened(false)
	gui.visible = false
	bottom_gui.visible = true

func update_items():
	gui.curr_inventory = gui.inventory_buffer
	player.set_cart(gui.inventory_buffer)
	player.update_inventory()
	player.update_weight()
	gui.cashier_items = gui.cashier_buffer
