extends Node

var difficulty
var player_coins = 0

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
