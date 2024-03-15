extends Panel

onready var cashier_gui = get_tree().root.get_child(2).get_node("Player/UI/CashierGUI")

var inventory_buffer = {}
var cashier_buffer = {}
var item_name = ""
var qty = 0
var type

func _on_Button_pressed():
	menu_bgm.click()
	inventory_buffer = cashier_gui.inventory_buffer
	cashier_buffer = cashier_gui.cashier_buffer
	print("pressed: " + item_name)
	print("on a " + self.type + " type item")
	
	if type == "Inventory":
		if !cashier_buffer.has(item_name):
			cashier_buffer[item_name] = 0
		cashier_buffer[item_name] += 1
		inventory_buffer[item_name] -= 1
	
	elif type == "Cashier":
		if !inventory_buffer.has(item_name):
			inventory_buffer[item_name] = 0
		cashier_buffer[item_name] -= 1
		inventory_buffer[item_name] += 1
	
	cashier_gui.update_displayed_items()
	print(inventory_buffer)
	print(cashier_buffer)
