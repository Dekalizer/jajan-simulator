extends Node2D

# Shelf properties
export var shelf_type : String = "Food"
export var items : Array = ["Chips", "Ramen", "Cookies"]
export var item_prices : Dictionary = {"Chips": 2, "Ramen": 1.5, "Cookies": 3}

var player_in_range = false
var shelf_gui_scene = preload("res://Scenes/ShelfGUI.tscn")

func _ready():
	pass  # Initialization code here

func _process(delta):
	# Handle player interaction
	if player_in_range and Input.is_action_pressed("interact"):
		open_shelf_gui()
	elif not player_in_range:
		queue_free()

func open_shelf_gui():
	var gui_instance = shelf_gui_scene.instance()
	gui_instance.setup(shelf_type)  # Pass the shelf type to the GUI instance
	add_child(gui_instance)
	# Position and display the GUI instance
	# You can customize the positioning based on your game's layout and design

func _on_item_selected(item_name):
	# Add the selected item to the player's cart or perform any other action
	print("Selected item:", item_name)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_in_range = false
