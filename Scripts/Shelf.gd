extends Node2D

# Shelf properties
var shelf_items = {
	"Food": ["Noodle", "Corned Beef", "Bread"],
	"Drink": ["Milk", "Water", "Soda"],
	"Veg": ["Carrot", "Onion", "Broccoli"],
	"Fruit": ["Apple", "Orange", "Banana"],
	"Meat": ["Beef", "Chicken", "Fish"],
	"Nugget": ["Nugget", "Meatball", "Sausage"],
	"Home": ["Bucket", "Broom", "Mop"]
}

var shelf_type : String
var player_in_range = false
var shelf_gui_scene = preload("res://Scenes/Shelf/ShelfGUI.tscn")
onready var player = get_parent().get_node("Player")
onready var gui = get_parent().get_node("ShelfGUI")

func _ready():
	pass  # Initialization code here

func _process(delta):
	# Handle player interaction
	if player_in_range and Input.is_action_pressed("interact") and !player.get_gui_opened():
		player.set_gui_opened(true)
		open_shelf_gui()
		print("opened " + shelf_type + " gui!")
		player.disable_move()
		

func open_shelf_gui():
	gui.populate_gui(shelf_type, shelf_items[shelf_type])
	gui.visible = true

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		gui.visible = false
