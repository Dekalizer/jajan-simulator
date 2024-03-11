extends Node

var difficulty

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



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
