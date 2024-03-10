extends Area2D

var player_in_range = false

onready var player = get_parent().get_node("Player")
onready var gui = get_parent().get_node("Player/UI/CashierGUI")
onready var bottom_gui = get_parent().get_node("Player/UI/BottomUI")

func _process(delta):
	# Handle player interaction
	if player_in_range and Input.is_action_pressed("interact") and !player.get_gui_opened():
		player.set_gui_opened(true)
		bottom_gui.visible = false
		open_cashier_gui()
		print("opened cashier gui!")
		player.disable_move()

func _on_Cashier_body_entered(body):
	if body.name == "Player":
		player_in_range = true


func _on_Cashier_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		gui.visible = false
		bottom_gui.visible = true


func open_cashier_gui():
	gui.open_gui()
