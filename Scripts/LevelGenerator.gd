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

onready var shelf_scene = preload("res://Scenes/Shelf.tscn")

export var SHELF_TOP = "ObjTopPart"
export var SHELF_BOT = "ObjBottomPart"
export var OBSTACLES = "Obstacle"

# uses bottom left of shelf tiles coords
# order is White, White, White, Black, Black, Freeze, Freeze
export var SHELF_COORD = [[2,10], [6,12], [12,8], [2,8], [10,4], [2,2], [10,2]] 
export var SHELF_RANGE = 5
export var OBSTACLE_COORD = [[5,4],[9,4],[15,5],[17,4],[3,5],[11,7],[1,8],[17,8],[1,10],[9,10]]
export var OBSTACLE_COUNT = 3

onready var shelf_gui = get_node("ShelfGUI")
onready var player = get_node("Player")

func _ready():
	randomize_section()
	place_shelf()
	if OBSTACLE_COUNT > 1:
		if OBSTACLE_COUNT > OBSTACLE_COORD.size():
			OBSTACLE_COUNT = OBSTACLE_COORD.size()
		place_obstacle()

func _process(delta):
	shelf_gui.rect_position = player.position - Vector2(269/2, 223/2)

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
	for i in range(0, OBSTACLE_COUNT):
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


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/MainLevel.tscn")
