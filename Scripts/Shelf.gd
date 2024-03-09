extends Node2D

# Shelf properties
var shelf_items = {
	"Food": ["Instant Noodle", "Corned Beef", "Bread"],
	"Drink": ["Milk", "Mineral Water", "Soda"],
	"Veg": ["Carrot", "Onion", "Broccoli"],
	"Fruit": ["Apple", "Orange", "Banana"],
	"Meat": ["Beef", "Chicken", "Fish"],
	"Nugget": ["Nugget", "Meatball", "Sausage"],
	"Home": ["Bucket", "Broom", "Mop"]
}

var shelf_type : String
var player_in_range = false
var shelf_gui_scene = preload("res://Scenes/ShelfGUI.tscn")
onready var player = get_parent().get_node("Player")
onready var gui = get_parent().get_node("ShelfGUI")

func _ready():
	pass  # Initialization code here

func _process(delta):
	# Handle player interaction
	if player_in_range and Input.is_action_pressed("interact"):
		open_shelf_gui()
		print("opened gui!")
		player.disable_move()
		

func open_shelf_gui():
	gui.populate_gui(shelf_type, shelf_items[shelf_type])
	gui.visible = true
	
	print("current cart:")
	print(player.cart)
	

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		gui.visible = false
