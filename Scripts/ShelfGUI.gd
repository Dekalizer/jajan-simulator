extends Control

# item properties with the format = "Item Name": [price, weight, tile_number]
var item_properties = {
	"Noodle": [85, 12],
	"Corned Beef": [340, 13],
	"Bread": [370, 14],
	"Milk": [1000, 0],
	"Water": [600, 1],
	"Soda": [250, 2],
	"Carrot": [300, 6],
	"Onion": [280, 7],
	"Broccoli": [250, 8],
	"Apple": [200, 3],
	"Orange": [150, 4],
	"Banana": [100, 5],
	"Bucket": [400, 9],
	"Broom": [400, 10],
	"Mop": [500, 11],
	"Beef": [500, 21],
	"Chicken": [300, 16],
	"Fish": [400, 22],
	"Nugget": [250, 17],
	"Meatball": [150, 18],
	"Sausage": [300, 19]
}

onready var player = get_parent().get_node("Player")

func quit():
	queue_free()

# shelf_type, ["noodle", "corned beef", "bread"]
func populate_gui(shelf_type, shelf_items):
	var cart = player.get_cart()
	$ItemName1.text = shelf_items[0]
	$ItemName2.text = shelf_items[1]
	$ItemName3.text = shelf_items[2]
	
	$ItemImage.set_cell(5, 5, item_properties[shelf_items[0]][1])
	$ItemImage.set_cell(5, 100, item_properties[shelf_items[1]][1])
	$ItemImage.set_cell(5, 195, item_properties[shelf_items[2]][1])

	if cart.has(shelf_items[0]):
		$ItemQty1.text = str(cart[shelf_items[0]])
	else:
		$ItemQty1.text = "0"
	if cart.has(shelf_items[1]):
		$ItemQty2.text = str(cart[shelf_items[1]])
	else:
		$ItemQty2.text = "0"
	if cart.has(shelf_items[2]):
		$ItemQty3.text = str(cart[shelf_items[2]])
	else:
		$ItemQty3.text = "0"

func _on_PlusButton1_pressed():
	var qty = int($ItemQty1.text) + 1
	$ItemQty1.text = str(qty)

func _on_PlusButton2_pressed():
	var qty = int($ItemQty2.text) + 1
	$ItemQty2.text = str(qty)

func _on_PlusButton3_pressed():
	var qty = int($ItemQty3.text) + 1
	$ItemQty3.text = str(qty)

func _on_MinusButton1_pressed():
	var qty = int($ItemQty1.text) - 1
	if qty < 0:
		qty = 0
	$ItemQty1.text = str(qty)

func _on_MinusButton2_pressed():
	var qty = int($ItemQty2.text) - 1
	if qty < 0:
		qty = 0
	$ItemQty2.text = str(qty)

func _on_MinusButton3_pressed():
	var qty = int($ItemQty3.text) - 1
	if qty < 0:
		qty = 0
	$ItemQty3.text = str(qty)

func _on_AddToCartButton_pressed():
	update_cart()
	remove_empty_item()
	player.update_weight()
	player.update_inventory()
	print("cart updated!")
	print(player.get_cart())
	print("new weight")
	print(player.get_weight())
	
	player.enable_move()
	player.set_gui_opened(false)
	visible = false

func remove_empty_item():
	var cart = player.get_cart()
	var no_zero_item_cart = {}
	for item_name in cart.keys():
		if cart[item_name] > 0:
			no_zero_item_cart[item_name] = cart[item_name]
	player.set_cart(no_zero_item_cart)

func update_cart():
	update_item_cart($ItemName1.text, $ItemQty1.text)
	update_item_cart($ItemName2.text, $ItemQty2.text)
	update_item_cart($ItemName3.text, $ItemQty3.text)
	

func update_item_cart(item_name, item_qty):
	var cart = player.get_cart()
	var qty = int(item_qty)
	cart[item_name] = qty
	player.set_cart(cart)

func _on_CloseButton_pressed():
	player.enable_move()
	player.set_gui_opened(false)
	visible = false
