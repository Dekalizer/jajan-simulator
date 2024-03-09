extends KinematicBody2D

# Player properties
export var MOVE_SPEED = 150
export var SPRINT_SPEED_MULTIPLIER = 1.5
export var MAX_STAMINA = 100
export var STAMINA_REGEN_RATE = 20  # Amount of stamina regenerated per second

# Player state
var velocity = Vector2()
var stamina = MAX_STAMINA
var sprinting = false
var can_sprint = true
var can_move = true
var sprint_speed = MOVE_SPEED * SPRINT_SPEED_MULTIPLIER

var cart = {}

func _ready():
	pass

func _physics_process(delta):
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
				velocity.y -= MOVE_SPEED
			if Input.is_action_pressed("ui_down"):
				velocity.y += MOVE_SPEED
			if Input.is_action_pressed("ui_left"):
				velocity.x -= MOVE_SPEED
			if Input.is_action_pressed("ui_right"):
				velocity.x += MOVE_SPEED

		# Normalize velocity to ensure consistent speed in all directions
		if sprinting:
			velocity = velocity.normalized() * sprint_speed
		else:
			velocity = velocity.normalized() * MOVE_SPEED

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
