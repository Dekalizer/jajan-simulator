extends Node2D

var shelf_list1 = ["Food", "Drink", "Home"]
var shelf_list2 = ["Veg", "Fruit"]
var shelf_list3 = ["Meat", "Nugget"]
var shelf_list = []

# "tile_color_type":["bot_tile","top_tile"]
var tile_dict_empty = {"White":[37,29], "Black":[54,49], "Freeze":[97,95]}

# "tile_color_type":["bot_left", "top_left", "top_right", "bot_right"] basically going clockwise starting from bot left
var tile_dict_edge = {"White":[38,28,33,39], "Black":[53,48,52,57], "Freeze":[92,91,93,94]}

# "category":["bot_tile","top_tile","tile_color_type"]
var tile_dict = {"Food":[35,31,"White"], "Drink":[36,30,"White"], "Home":[34,32,"White"], "Veg":[55,50,"Black"], "Fruit":[56,51,"Black"], "Meat":[98,96,"Freeze"], "Nugget":[90,89,"Freeze"]}

# 22 = Box, 23 = Water
var tile_obstacle = [22, 23]
onready var shelf_top : TileMap = get_node(SHELF_TOP)
onready var shelf_bot : TileMap = get_node(SHELF_BOT)
onready var obstacle : TileMap = get_node(OBSTACLES)

onready var shelf_scene = preload("res://Scenes/Shelf/Shelf.tscn")

export var SHELF_TOP = "ObjTopPart"
export var SHELF_BOT = "ObjBottomPart"
export var OBSTACLES = "Obstacle"

# uses bottom left of shelf tiles coords
# order is White, White, White, Black, Black, Freeze, Freeze
export var SHELF_COORD = [[2,10], [6,12], [12,8], [2,8], [10,4], [2,2], [10,2]] 
export var SHELF_RANGE = 5
export var OBSTACLE_COORD = [[5,4],[9,4],[15,5],[17,4],[3,5],[11,7],[1,8],[17,8],[1,10],[9,10]]


onready var shelf_gui = get_node("ShelfGUI")
onready var player = get_node("Player")
onready var required_item_slots = get_node("Player/UI/ItemList/NinePatchRect/GridContainer").get_children()

var start_time = 0
var is_timer_running = false
var time_limit = 0
var required_item_types
var required_item_qty
var required_items = {}
var reward_multiplier
var obstacle_count

# Difficulty goes from 1 - 5.
# 1 = 2 obstacles are enabled, time limit is 180 seconds
# 2 = 4 obstacles are enabled, time limit is 150 seconds
# 3 = 6 obstacles are enabled, time limit is 120 seconds
# 4 = 8 obstacles are enabled, time limit is 90 seconds
# 5 = 10 obstacles are enabled, time limit is 60 seconds
var difficulty = global.difficulty

func _ready():
	set_difficulty()
	set_required_items()
	randomize_section()
	place_shelf()
	if obstacle_count > 1:
		if obstacle_count > OBSTACLE_COORD.size():
			obstacle_count = OBSTACLE_COORD.size()
		place_obstacle()
	start_time = OS.get_ticks_msec()
	update_item_list()

func _process(delta):
	shelf_gui.rect_position = player.position - Vector2(269/2, 223/2)

func set_required_items():
	var item_properties = global.item_properties
	var required_items = {}
	
	# Randomly select required_item_types amount of items
	var item_types = item_properties.keys()
	item_types.shuffle()
	print(item_types)
	for i in range(required_item_types):
		required_items[item_types[i]] = required_item_qty[0] + randi() % (required_item_qty[1] - required_item_qty[0] + 1)
	
	
	self.required_items = required_items
	
func set_difficulty():
	match global.difficulty:
		1:
			obstacle_count = 2
			time_limit = 180
			reward_multiplier = 1.0
			required_item_types = 5
			required_item_qty = [1, 3]  # Range from 1 to 3
		2:
			obstacle_count = 4
			time_limit = 150
			reward_multiplier = 1.2
			required_item_types = 6
			required_item_qty = [2, 4]  # Range from 2 to 4
		3:
			obstacle_count = 6
			time_limit = 120
			reward_multiplier = 1.4
			required_item_types = 8
			required_item_qty = [3, 5]  # Range from 3 to 5
		4:
			obstacle_count = 8
			time_limit = 90
			reward_multiplier = 1.6
			required_item_types = 10
			required_item_qty = [4, 6]  # Range from 4 to 6
		5:
			obstacle_count = 10
			time_limit = 60
			reward_multiplier = 2.0
			required_item_types = 12
			required_item_qty = [5, 7]  # Range from 5 to 7

func randomize_section():
	randomize()
	shelf_list1.shuffle()
	shelf_list2.shuffle()
	shelf_list3.shuffle()
	shelf_list = shelf_list1 + shelf_list2 + shelf_list3
	print("Generated shelf: " + str(shelf_list))
	return shelf_list

func randomize_obstacle():
	OBSTACLE_COORD.shuffle()
	var randomized_obstacle = []
	for i in range(0, obstacle_count):
		randomized_obstacle.append(OBSTACLE_COORD[i])
	return randomized_obstacle

func randomize_emptiness():
	var filled_shelf = 1 + randi() % SHELF_RANGE
	var shelf_order = []
	# Fill the array with zeros
	for i in range(SHELF_RANGE):
		shelf_order.append(0)

	# Place the required number of ones randomly
	for i in range(filled_shelf):
		var random_index = randi() % SHELF_RANGE
		shelf_order[random_index] = 1

	return shelf_order

func place_shelf():
	for i in range(shelf_list.size()):
		var emptiness_pattern = randomize_emptiness()
		print("Emptiness pattern generated for "+ shelf_list[i] + ": " + str(emptiness_pattern))
		var shelf_type = shelf_list[i]
		var shelf_color_type = tile_dict[shelf_type][2]
		var shelf_x = SHELF_COORD[i][0]
		var shelf_y = SHELF_COORD[i][1]
		
		# Fill in tile edges
		shelf_bot.set_cell(shelf_x-1, shelf_y, tile_dict_edge[shelf_color_type][0]) #bot left
		shelf_top.set_cell(shelf_x-1, shelf_y-1, tile_dict_edge[shelf_color_type][1]) #top left
		shelf_top.set_cell(shelf_x+SHELF_RANGE, shelf_y-1, tile_dict_edge[shelf_color_type][2]) #top right
		shelf_bot.set_cell(shelf_x+SHELF_RANGE, shelf_y, tile_dict_edge[shelf_color_type][3]) #bot right


		# Fill in the shelves with generated emptiness pattern
		for j in range(SHELF_RANGE):
			var is_filled = emptiness_pattern[j]
			
			# Placing filled shelves
			if is_filled == 1:
				shelf_bot.set_cell(shelf_x, shelf_y, tile_dict[shelf_type][0])
				shelf_top.set_cell(shelf_x, shelf_y-1, tile_dict[shelf_type][1])
				
				# Placing in Shelf.tscn inside filled shelves with the appropriate shelf type
				var shelf_area = shelf_scene.instance()
				shelf_area.shelf_type = shelf_type
				shelf_area.position = Vector2(shelf_x * shelf_bot.cell_size.x * 0.3, shelf_y * shelf_top.cell_size.y * 0.3 + 30)
				add_child(shelf_area)

			# Placing empty shelves
			else:
				shelf_bot.set_cell(shelf_x, shelf_y, tile_dict_empty[shelf_color_type][0])
				shelf_top.set_cell(shelf_x, shelf_y-1, tile_dict_empty[shelf_color_type][1])
			shelf_x += 1

func place_obstacle():
	var generated_obstacle = randomize_obstacle()
	print("Generated obstacles on: " + str(generated_obstacle))
	for i in range(generated_obstacle.size()):
		obstacle.set_cell(generated_obstacle[i][0], generated_obstacle[i][1], tile_obstacle[randi() % tile_obstacle.size() ])

func update_item_list():
	for i in range(required_items.size()):
		required_item_slots[i].get_node("CenterContainer/ItemImg").texture = load("res://Assets/Item Images/" + required_items.keys()[i] + ".png")
		required_item_slots[i].get_node("ItemQty").text = str(required_items.values()[i])
		required_item_slots[i].visible = true

func finish_level():
	var reward = evaluate_performance()
	print("congrats, you got: " + str(reward))

func evaluate_time():
	var reward = 0
	
	var time_taken = (OS.get_ticks_msec() - start_time) / 1000.0  # Convert milliseconds to seconds
	var time_remaining = time_limit - time_taken
	
	if time_remaining >= 0:
		# Calculate the reward based on the time saved
		reward = time_remaining / time_limit * 100
	
	return int(reward)

func evaluate_items():
	var penalties = 0
	var inventory = player.get_cart()
	var required_qty

	# Penalize for not enough/too much items
	for i in range(required_items.size()):
		if inventory.has(required_items.keys()[i]):
			# Check if the player has enough/too much of the required item
			required_qty = required_items.values()[i]
			var qty = inventory[required_items.keys()[i]]
			penalties -= abs(required_qty - qty)
		else:
			# Handle when player doesnt have the required item at all
			penalties -= required_items.values()[i]

	# Penalize for extra items
	for item in inventory.keys():
		if !required_items.has(item):
			penalties -= inventory[item]

	return penalties * 10

func evaluate_performance():
	var penalties = 0
	penalties += evaluate_items()
	if !(penalties < 0):
		print("reward from item: " + str(penalties))
		penalties += evaluate_time()
		print("reward from time: " + str(penalties))
	
	return penalties 

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/MainLevel.tscn")
