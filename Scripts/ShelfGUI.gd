extends Control

# item properties with the format = "Item Name": [price, weight, tile_number]
var item_properties = {
	"Instant Noodle": [100, 100, 12],
	"Corned Beef": [100, 100, 13],
	"Bread": [100, 100, 14],
	"Milk": [100, 100, 0],
	"Mineral Water": [100, 100, 1],
	"Soda": [100, 100, 2],
	"Carrot": [100, 100, 6],
	"Onion": [100, 100, 7],
	"Broccoli": [100, 100, 8],
	"Apple": [100, 100, 3],
	"Orange": [100, 100, 4],
	"Banana": [100, 100, 5],
	"Bucket": [100, 100, 9],
	"Broom": [100, 100, 10],
	"Mop": [100, 100, 11],
	"Beef": [100, 100, 21],
	"Chicken": [100, 100, 16],
	"Fish": [100, 100, 22],
	"Nugget": [100, 100, 17],
	"Meatball": [100, 100, 18],
	"Sausage": [100, 100, 19]
}

onready var player = get_parent().get_node("Player")
onready var cart = player.cart

signal shelf_gui_opened
signal shelf_gui_closed

func quit():
	queue_free()

# shelf_type, ["noodle", "corned beef", "bread"]
func populate_gui(shelf_type, shelf_items):
	$ItemName1.text = shelf_items[0]
	$ItemName2.text = shelf_items[1]
	$ItemName3.text = shelf_items[2]
	
	$ItemImage.set_cell(5, 5, item_properties[shelf_items[0]][2])
	$ItemImage.set_cell(5, 100, item_properties[shelf_items[1]][2])
	$ItemImage.set_cell(5, 195, item_properties[shelf_items[2]][2])

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
	var qty = int($ItemQty1.text)
	if qty > 0:
		qty -= 1
	$ItemQty1.text = str(qty)

func _on_MinusButton2_pressed():
	var qty = int($ItemQty2.text)
	if qty > 0:
		qty -= 1
	$ItemQty2.text = str(qty)

func _on_MinusButton3_pressed():
	var qty = int($ItemQty3.text)
	if qty > 0:
		qty -= 1
	$ItemQty3.text = str(qty)

func _on_AddToCartButton_pressed():
	update_cart()
	player.enable_move()
	visible = false

func update_cart():
	cart.clear()
	update_item_cart($ItemName1.text, $ItemQty1.text)
	update_item_cart($ItemName2.text, $ItemQty2.text)
	update_item_cart($ItemName3.text, $ItemQty3.text)

func update_item_cart(item_name, item_qty):
	var qty = int(item_qty)
	if qty > 0:
		cart[item_name] = qty

func _on_CloseButton_pressed():
	player.enable_move()
	visible = false
