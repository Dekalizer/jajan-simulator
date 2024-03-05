extends KinematicBody2D

# Player properties
export var MOVE_SPEED = 300

# Player state
var velocity = Vector2()

func _physics_process(delta):
	# Move the player
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
	velocity = velocity.normalized() * MOVE_SPEED

	# Move the player
	move_and_slide(velocity)
