extends Control

onready var inventory = get_node("Inventory/GridContainer").get_children()
onready var cashier = get_node("Cashier/GridContainer").get_children()
onready var player = get_tree().root.get_child(1).get_node("Player")
onready var bottom_gui = get_tree().root.get_child(1).get_node("Player/UI/BottomUI")

var inventory_buffer = {}
var cashier_buffer = {}

var curr_inventory = {}
var cashier_items = {}

func reset_buffers():
	var cart = player.get_cart()
	inventory_buffer = {}
	for i in range(cart.size()):
		inventory_buffer[cart.keys()[i]] = cart.values()[i]
	
	cashier_buffer = {}
	for i in range(cashier_items.size()):
		cashier_buffer[cashier_items.keys()[i]] = cashier_items.values()[i]

func update_displayed_items():
	clear_displayed_items()
	remove_empty_item()
	for i in range(inventory_buffer.size()):
		inventory[i].get_node("CenterContainer/ItemImg").texture = load("res://Assets/Item Images/" + inventory_buffer.keys()[i] + ".png")
		inventory[i].get_node("ItemQty").text = str(inventory_buffer.values()[i])
		inventory[i].item_name = inventory_buffer.keys()[i]
		inventory[i].qty = inventory_buffer.values()[i]
		inventory[i].type = "Inventory"
		inventory[i].visible = true
	
	for i in range(cashier_buffer.size()):
		cashier[i].get_node("CenterContainer/ItemImg").texture = load("res://Assets/Item Images/" + cashier_buffer.keys()[i] + ".png")
		cashier[i].get_node("ItemQty").text = str(cashier_buffer.values()[i])
		cashier[i].item_name = cashier_buffer.keys()[i]
		cashier[i].qty = cashier_buffer.values()[i]
		cashier[i].type = "Cashier"
		cashier[i].visible = true

func clear_displayed_items():
	for i in range(inventory_buffer.size()):
		inventory[i].get_node("CenterContainer/ItemImg").texture = load("res://Assets/Item Images/" + inventory_buffer.keys()[i] + ".png")
		inventory[i].get_node("ItemQty").text = str(inventory_buffer.values()[i])
		inventory[i].item_name = inventory_buffer.keys()[i]
		inventory[i].qty = inventory_buffer.values()[i]
		inventory[i].type = "Inventory"
		inventory[i].visible = false
	
	for i in range(cashier_buffer.size()):
		cashier[i].get_node("CenterContainer/ItemImg").texture = null
		cashier[i].get_node("ItemQty").text = ""
		cashier[i].item_name = ""
		cashier[i].qty = 0
		cashier[i].type = "Cashier"
		cashier[i].visible = false

func remove_empty_item():
	var no_zero_item_inventory = {}
	var no_zero_item_cashier = {}
	for item_name in inventory_buffer.keys():
		if inventory_buffer[item_name] > 0:
			no_zero_item_inventory[item_name] = inventory_buffer[item_name]
	
	for item_name in cashier_buffer.keys():
		if cashier_buffer[item_name] > 0:
			no_zero_item_cashier[item_name] = cashier_buffer[item_name]
	
	inventory_buffer = no_zero_item_inventory
	cashier_buffer = no_zero_item_cashier



func open_gui():
	visible = true
	reset_buffers()
	update_displayed_items()

func save_items():
	# turn buffers into current inventories
	pass

func _on_CloseButton_pressed():
	clear_displayed_items()
	player.enable_move()
	player.set_gui_opened(false)
	visible = false
	bottom_gui.visible = true
