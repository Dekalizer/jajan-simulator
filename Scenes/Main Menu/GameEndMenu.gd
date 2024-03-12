extends Control

var start_time = global.last_game_start_time
var end_time = global.last_game_end_time
var cashier_items = global.last_game_cashier_item
var required_items = global.last_game_req_item
var time_limit = global.last_game_time_limit
var reward_mult = float(global.last_game_reward_mult)

var total_coins_gained

# Missing item is -20
# Too much item is -10
var penalties = [0,0,0]
onready var calculation = get_node("LevelInfo/Calculation").get_children()
onready var total_calc = get_node("LevelInfo/Total").get_children()

var back_button_disabled = true

func _ready():
	enable_back_button_timer()
	evaluate_performance()
	global.player_coins += total_coins_gained

func evaluate_items():
	var penalties_missing_item_count = 0
	var penalties_too_much_item_count = 0
	var cashier_inventory = cashier_items
	var required_qty

	# Penalize for not enough/too much items
	for i in range(required_items.size()):
		
		# Check if the player has the item
		if cashier_inventory.has(required_items.keys()[i]):
			
			# Check if the player doesnt have enough/too much of the required item
			required_qty = required_items.values()[i]
			var qty_on_cashier = cashier_inventory[required_items.keys()[i]]
			var qty_diff = required_qty - qty_on_cashier
			
			# Handle if not enough item qty
			if qty_diff > 0:
				penalties_missing_item_count += qty_diff
			
			# Handle if too much item qty
			elif qty_diff < 0:
				penalties_too_much_item_count += qty_diff
		else:
			# Handle when player doesnt have the required item at all
			penalties_missing_item_count += required_items.values()[i]

	# Penalize for extra items
	for item in cashier_inventory.keys():
		if !required_items.has(item):
			penalties_too_much_item_count += cashier_inventory[item]
	
	penalties[0] = penalties_missing_item_count
	penalties[1] = penalties_too_much_item_count

func evaluate_time():
	var reward = 0
	
	var time_taken = (end_time - start_time) / 1000.0  # Convert milliseconds to seconds
	var time_remaining = time_limit - time_taken
	
	if time_remaining >= 0:
		# Calculate the reward based on the time saved
		reward = time_remaining / time_limit * 1000.0
	
	penalties[2] = int(reward)

func evaluate_performance():
	evaluate_items()
	evaluate_time()
	update_report_display()

func update_report_display():
	update_total()
	update_calculation()
	

func update_calculation():
	calculation[0].text = str(penalties[0]) + " * (-20)"
	calculation[1].text = str(penalties[1]) + " * (-10)"
	calculation[2].text = str(penalties[2])
	calculation[4].text = str(penalties[0]*(-20) + penalties[1]*(-10) + penalties[2]) + " * " + str(reward_mult)

func update_total():
	total_calc[0].text = str(penalties[0]*-20)
	total_calc[1].text = str(penalties[1]*-10)
	total_calc[2].text = str(penalties[2])
	total_calc[3].text = str(reward_mult)
	total_calc[4].text = str((penalties[0]*-20 + penalties[1]*-10 + penalties[2]) * reward_mult)
	total_coins_gained = (penalties[0]*-20 + penalties[1]*-10 + penalties[2]) * reward_mult
	if total_coins_gained < 0:
		total_coins_gained = 0
		total_calc[4].text = str(0)

func enable_back_button_timer():
	var timer = Timer.new()
	timer.wait_time = 3.0  
	timer.one_shot = true 
	timer.connect("timeout", self, "_enable_button")  
	add_child(timer)
	timer.start()

func _enable_button():
	back_button_disabled = false

func _on_BackButton_pressed():
	if !back_button_disabled:
		queue_free()
		get_tree().change_scene("res://Scenes/Main Menu/MainMenu.tscn")
