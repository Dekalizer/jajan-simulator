extends KinematicBody2D

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

# Player properties
export var DEFAULT_MOVE_SPEED = 150
export var SPRINT_SPEED_MULTIPLIER = 1.5
export var MAX_STAMINA = 100.0
export var STAMINA_REGEN_RATE = 20  # Amount of stamina regenerated per second
export var MAX_WEIGHT = 3000.0 # in grams

# Player state
var velocity = Vector2()
var stamina = MAX_STAMINA
var sprinting = false
var can_sprint = true
var can_move = true
var gui_opened = false
var move_speed = DEFAULT_MOVE_SPEED
var sprint_speed = move_speed * SPRINT_SPEED_MULTIPLIER
var cart = {}
var weight = 0

onready var weight_bar = get_node("UI/BottomUI/WeightBar")
onready var stamina_bar = get_node("UI/BottomUI/StaminaBar")
onready var weight_count = get_node("UI/BottomUI/WeightCount")
onready var stamina_count = get_node("UI/BottomUI/StaminaCount")

# The inventory that displays when pressing TAB
onready var inv_slots = get_parent().get_node("Player/UI/Inventory/NinePatchRect/GridContainer").get_children()

# The inventory that displays when on Cashier
onready var inv_2_slots = get_parent().get_node("Player/UI/CashierGUI/Inventory/GridContainer").get_children()


func _ready():
	pass

func _process(delta):
	update_bars()
	
	if Input.is_action_pressed("look_at_inventory") and !gui_opened:
		$UI/Inventory.visible = true
	else:
		$UI/Inventory.visible = false

func get_weight():
	return self.weight

func set_weight(updated_weight):
	self.weight = updated_weight

func get_cart():
	return self.cart

func set_cart(updated_cart):
	self.cart = updated_cart

func get_gui_opened():
	return self.gui_opened

func set_gui_opened(val):
	self.gui_opened = val

func update_weight():
	var cart = self.cart
	var updated_weight = 0
	for item in cart.keys():
		for qty in range(cart[item]):
			updated_weight += item_properties[item][0]
	
	set_weight(updated_weight)

func clear_inventory():
	for i in range(inv_slots.size()):
		inv_slots[i].get_node("CenterContainer/ItemImg").texture = null
		inv_slots[i].get_node("ItemQty").text = ""
		inv_slots[i].visible = false
		
		inv_2_slots[i].get_node("CenterContainer/ItemImg").texture = null
		inv_2_slots[i].get_node("ItemQty").text = ""
		inv_2_slots[i].item_name = ""
		inv_2_slots[i].qty = 0
		inv_2_slots[i].visible = false

func update_inventory():
	# Clear the inventory by setting values to null values
	clear_inventory()
	
	# Refill the inventory with the current items on player's hand
	var cart = self.cart
	for i in range(cart.size()):
		inv_slots[i].get_node("CenterContainer/ItemImg").texture = load("res://Assets/Item Images/" + cart.keys()[i] + ".png")
		inv_slots[i].get_node("ItemQty").text = str(cart.values()[i])
		inv_slots[i].visible = true

func update_bars():
	weight_bar.set_value(weight / MAX_WEIGHT * 100)
	stamina_bar.set_value(stamina / MAX_STAMINA * 100)
	
	weight_count.text = str(weight) + " / " + str(MAX_WEIGHT)
	stamina_count.text = str(int(stamina)) + " / " + str(MAX_STAMINA)

func _physics_process(delta):
	# Calculate the percentage of weight over the maximum weight
	var weight_percentage = weight / MAX_WEIGHT
	
	# If weight is under the maximum, no slowdown
	if weight_percentage <= 1.0:
		move_speed = DEFAULT_MOVE_SPEED
		sprint_speed = move_speed * SPRINT_SPEED_MULTIPLIER
	else:
		# Calculate the slowdown factor based on the weight percentage
		var slowdown_factor = (weight_percentage - 1.0) * 100

		# Apply the slowdown to the move speed
		move_speed = DEFAULT_MOVE_SPEED * (1.0 - min(1.0, weight_percentage - 1.0))

		# Update sprint speed based on the new move speed
		sprint_speed = move_speed * SPRINT_SPEED_MULTIPLIER
	
	if can_move:
		# Handle sprinting
		if Input.is_action_pressed("ui_sprint") and stamina > 0 and can_sprint:
			sprinting = true
			velocity.x = 0
			velocity.y = 0
			if Input.is_action_pressed("ui_up"):
				velocity.y -= sprint_speed
			if Input.is_action_pressed("ui_down"):
				velocity.y += sprint_speed
			if Input.is_action_pressed("ui_left"):
				velocity.x -= sprint_speed
			if Input.is_action_pressed("ui_right"):
				velocity.x += sprint_speed
		else:
			sprinting = false
			# Move the player at normal speed
			velocity.x = 0
			velocity.y = 0
			if Input.is_action_pressed("ui_up"):
				velocity.y -= move_speed
			if Input.is_action_pressed("ui_down"):
				velocity.y += move_speed
			if Input.is_action_pressed("ui_left"):
				velocity.x -= move_speed
			if Input.is_action_pressed("ui_right"):
				velocity.x += move_speed

		# Normalize velocity to ensure consistent speed in all directions
		if sprinting:
			velocity = velocity.normalized() * sprint_speed
		else:
			velocity = velocity.normalized() * move_speed

		# Move the player
		move_and_slide(velocity)

		# Update stamina
		if sprinting:
			stamina -= delta * 50  # Decrease stamina while sprinting
			if stamina <= 0:
				stamina = 0
				can_sprint = false

		else:
			stamina += delta * STAMINA_REGEN_RATE  # Regenerate stamina
			if stamina > MAX_STAMINA:
				stamina = MAX_STAMINA
				can_sprint = true

func disable_move():
	can_move = false
	
func enable_move():
	can_move = true
