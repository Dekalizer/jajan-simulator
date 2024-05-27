extends KinematicBody2D

var item_properties = global.item_properties

# Player properties
export var DEFAULT_MOVE_SPEED = 150.0
export var SPRINT_SPEED_MULTIPLIER = 1.5
export var MAX_STAMINA = 100.0
export var STAMINA_REGEN_RATE = 20  # Amount of stamina regenerated per second
export var MAX_WEIGHT = 3000.0 # in grams

# Player state
var velocity = Vector2()
var last_movement_direction = Vector2()
var stamina = MAX_STAMINA
var sprinting = false
var can_sprint = true
var can_move = true
var gui_opened = false
var move_speed = DEFAULT_MOVE_SPEED
var sprint_speed = move_speed * SPRINT_SPEED_MULTIPLIER
var cart = {}
var weight = 0
var default_animation_speed = 2
var stamina_can_decrease = true
var applied_upgrades = {}

onready var weight_bar = get_node("UI/BottomUI/WeightBar")
onready var stamina_bar = get_node("UI/BottomUI/StaminaBar")
onready var weight_count = get_node("UI/BottomUI/WeightCount")
onready var stamina_count = get_node("UI/BottomUI/StaminaCount")

# The inventory that displays when pressing TAB
onready var inv_slots = get_parent().get_node("Player/UI/Inventory/NinePatchRect/GridContainer").get_children()

# The inventory that displays when on Cashier
onready var inv_2_slots = get_parent().get_node("Player/UI/CashierGUI/Inventory/GridContainer").get_children()

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

func _ready():
	last_movement_direction = Vector2.ZERO
	apply_upgrades()

func _process(delta):
	update_bars()
	
		# Determine last movement direction
	if velocity.x > 0:
		last_movement_direction = Vector2.RIGHT
	elif velocity.x < 0:
		last_movement_direction = Vector2.LEFT
	elif velocity.y > 0:
		last_movement_direction = Vector2.DOWN
	elif velocity.y < 0:
		last_movement_direction = Vector2.UP

func apply_upgrades():
	var highest_levels = {}
	var upgrades_bought = global.player_bought_stats
	var level_stats = global.level_stats
	
	# Taking the highest level of the purchased upgrades
	# Iterate over each stat
	for stat in upgrades_bought.keys():
		var highest_level = 0
		
		# Iterate over each level bought for the current stat
		for level in upgrades_bought[stat].keys():
			# Check if the level bought is greater than the current highest level
			if upgrades_bought[stat][level] == 1 and level > highest_level:
				highest_level = level
		
		# Add the highest level to the new dictionary {"Agility":1, "Stamina":0}
		highest_levels[stat] = highest_level
	
	self.applied_upgrades = highest_levels
	DEFAULT_MOVE_SPEED = (1 + level_stats[highest_levels["Agility"]][0]/100.0) * DEFAULT_MOVE_SPEED
	MAX_WEIGHT = (1 + level_stats[highest_levels["Strength"]][0]/100.0) * MAX_WEIGHT
	MAX_STAMINA = (1 + level_stats[highest_levels["Stamina"]][0]/100.0) * MAX_STAMINA

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
		$AnimatedSprite.speed_scale = default_animation_speed
	else:
		$AnimatedSprite.speed_scale = max(0.5, 1.0 - weight_percentage) * default_animation_speed

		# Apply the slowdown to the move speed
		move_speed = DEFAULT_MOVE_SPEED * (1.0 - min(1.0, weight_percentage - 1.0))

		# Update sprint speed based on the new move speed
		sprint_speed = move_speed * SPRINT_SPEED_MULTIPLIER
	
	# Handle idle sprite
	if velocity == Vector2.ZERO:
		match last_movement_direction:
			Vector2.UP:
				$AnimatedSprite.play("CharacterUpIdle")
			Vector2.DOWN:
				$AnimatedSprite.play("CharacterDownIdle")
			Vector2.LEFT:
				$AnimatedSprite.play("CharacterLeftIdle")
			Vector2.RIGHT:
				$AnimatedSprite.play("CharacterRightIdle")
	
	if can_move:
		# Handle sprinting
		if Input.is_action_pressed("ui_sprint") and stamina > 0 and can_sprint:
			sprinting = true
			velocity.x = 0
			velocity.y = 0
			if Input.is_action_pressed("ui_up"):
				$AnimatedSprite.play("CharacterUp")
				velocity.y -= sprint_speed
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite.play("CharacterDown")
				velocity.y += sprint_speed
			elif Input.is_action_pressed("ui_left"):
				$AnimatedSprite.play("CharacterLeft")
				velocity.x -= sprint_speed
			elif Input.is_action_pressed("ui_right"):
				$AnimatedSprite.play("CharacterRight")
				velocity.x += sprint_speed
		else:
			sprinting = false
			# Move the player at normal speed
			velocity.x = 0
			velocity.y = 0
			if Input.is_action_pressed("ui_up"):
				$AnimatedSprite.play("CharacterUp")
				velocity.y -= move_speed
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite.play("CharacterDown")
				velocity.y += move_speed
			elif Input.is_action_pressed("ui_left"):
				$AnimatedSprite.play("CharacterLeft")
				velocity.x -= move_speed
			elif Input.is_action_pressed("ui_right"):
				$AnimatedSprite.play("CharacterRight")
				velocity.x += move_speed

		# Normalize velocity to ensure consistent speed in all directions
		if sprinting:
			velocity = velocity.normalized() * sprint_speed
		else:
			velocity = velocity.normalized() * move_speed

		# Move the player
		move_and_slide(velocity)

		# Update stamina
		if sprinting and stamina_can_decrease:
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
