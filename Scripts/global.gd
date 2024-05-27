extends Node

var difficulty
var player_coins = 0

onready var cheat_text = preload("res://Scenes/UI/CheatText.tscn")

# "StatGroup":{Level:0 = Haven't bought 1 = Bought}
var player_bought_stats = {
	"Agility":{1:0, 2:0, 3:0}, 
	"Strength":{1:0, 2:0, 3:0},
	"Stamina":{1:0, 2:0, 3:0}
	}

var level_stats = {0:[0,0], 1:[20,1000], 2:[35,2000], 3:[50,3000]}

var last_game_req_item = {}
var last_game_cashier_item = {}
var last_game_start_time = 0
var last_game_time_limit = 0
var last_game_reward_mult = 0
var last_game_end_time = 0

var temp_move_speed = 0
var temp_weight = 0

# item properties with the format = "Item Name": [price, weight, tile_number]
var item_properties = {
	"Noodle": [85, 12],
	"Corned Beef": [340, 13],
	"Bread": [370, 14],
	"Milk": [1000, 0],
	"Water": [600, 1],
	"Soda": [250, 2],
	"Carrot": [300, 6],
	"Onion": [280, 7],
	"Broccoli": [250, 8],
	"Apple": [200, 3],
	"Orange": [150, 4],
	"Banana": [100, 5],
	"Bucket": [400, 9],
	"Broom": [400, 10],
	"Mop": [500, 11],
	"Beef": [500, 21],
	"Chicken": [300, 16],
	"Fish": [400, 22],
	"Nugget": [250, 17],
	"Meatball": [150, 18],
	"Sausage": [300, 19]
}

var cheat_codes = ["imrich", "superfast", "bodybuilder"]
var input_buffer = ""

var cheat_functions = {
	"imrich": "activate_rich",
	"superfast": "activate_superfast",
	"bodybuilder": "activate_bodybuilder"
}

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var typed_char = OS.get_scancode_string(event.scancode).to_lower()
		input_buffer += typed_char
		
		if input_buffer.length() > 11: 
			input_buffer = input_buffer.substr(1, 11)

		for cheat_code in cheat_codes:
			if input_buffer.ends_with(cheat_code):
				activate_cheat(cheat_code)

func activate_cheat(cheat_code):
	var curr_scene = get_tree().current_scene
	match cheat_code:
		"imrich":
			if curr_scene.name == "MainMenu" or curr_scene.name == "Shop" or curr_scene.name == "LevelSelection" or curr_scene.name == "Tutorial":
				player_coins += 5000
				
				var cheat_label = cheat_text.instance()
				cheat_label.get_child(1).get_node("Label2").text = "Gained 5000 coins!"
				cheat_label.get_child(1).get_node("Label3").text = ""
				cheat_label.visible = true
				
				curr_scene.add_child(cheat_label)
				start_cheat_label_rich_timer()
				
				print("Cheat code activated: Im Rich!")
			
		"superfast":
			if curr_scene.name == "MainLevel":
				var player = curr_scene.get_node("Player")
				temp_move_speed = player.DEFAULT_MOVE_SPEED
				player.DEFAULT_MOVE_SPEED = 450
				
				var cheat_label = cheat_text.instance()
				cheat_label.get_child(1).get_node("Label2").text = "Increased player movement speed"
				cheat_label.get_child(1).get_node("Label3").text = "for 15 seconds!"
				cheat_label.visible = true
				player.get_node("UI").add_child(cheat_label)
				
				start_cheat_label_timer()
		
				print("Cheat code activated: Super Fast!")
				return_to_normal("superfast")
			
		"bodybuilder":
			if curr_scene.name == "MainLevel":
				var player = curr_scene.get_node("Player")
				temp_weight = player.MAX_WEIGHT
				player.MAX_WEIGHT = 6000
				
				var cheat_label = cheat_text.instance()
				cheat_label.get_child(1).get_node("Label2").text = "Increased maximum carry weight"
				cheat_label.get_child(1).get_node("Label3").text = "for 15 seconds!"
				cheat_label.visible = true
				player.get_node("UI").add_child(cheat_label)
				
				start_cheat_label_timer()
				
				print("Cheat code activated: Bodybuilder!")
				return_to_normal("bodybuilder")

func start_cheat_label_timer():
	var timer = Timer.new()
	timer.wait_time = 3.0  
	timer.one_shot = true
	timer.connect("timeout", self, "_erase_label")  
	add_child(timer)
	timer.start()

func start_cheat_label_rich_timer():
	var timer = Timer.new()
	timer.wait_time = 1.0  
	timer.one_shot = true
	timer.connect("timeout", self, "_erase_label")  
	add_child(timer)
	timer.start()

func return_to_normal(cheat):
	var timer = Timer.new()
	timer.wait_time = 15.0  
	timer.one_shot = true 
	if cheat == "superfast":
		timer.connect("timeout", self, "_normal_speed")  
	elif cheat == "bodybuilder":
		timer.connect("timeout", self, "_normal_weight")  
	add_child(timer)
	timer.start()
	
func _erase_label():
	var curr_scene = get_tree().current_scene
	if curr_scene.name == "MainLevel":
		var player = curr_scene.get_node("Player")
		player.get_node("UI/CheatText").queue_free()
	else:
		curr_scene.get_node("CheatText").queue_free()
	
func _normal_speed():
	var curr_scene = get_tree().current_scene
	if curr_scene.name == "MainLevel":
		var player = curr_scene.get_node("Player")
		player.DEFAULT_MOVE_SPEED = temp_move_speed
		print("Cheat code deactivated: Super Fast!")
		
func _normal_weight():
	var curr_scene = get_tree().current_scene
	if curr_scene.name == "MainLevel":
		var player = curr_scene.get_node("Player")
		player.MAX_WEIGHT = temp_weight
		print("Cheat code deactivated: Bodybuilder!")
