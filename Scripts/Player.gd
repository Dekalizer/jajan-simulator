extends KinematicBody2D

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

onready var weight_bar = get_node("UI/WeightBar")
onready var stamina_bar = get_node("UI/StaminaBar")


func _ready():
	pass

func _process(delta):
	update_bars()

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

func update_bars():
	weight_bar.set_value(weight / MAX_WEIGHT * 100)
	stamina_bar.set_value(stamina / MAX_STAMINA * 100)

func _physics_process(delta):
	if weight > MAX_WEIGHT:
		move_speed = DEFAULT_MOVE_SPEED*0.6
	else:
		move_speed = DEFAULT_MOVE_SPEED
	
	if can_move:
		# Handle sprinting
		if Input.is_action_pressed("ui_sprint") and stamina > 0 and can_sprint:
			sprinting = true
			sprint_speed = move_speed * SPRINT_SPEED_MULTIPLIER
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
