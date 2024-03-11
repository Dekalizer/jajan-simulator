extends Control

var is_open = false

func _ready():
	close()

func open():
	self.visible = true
	is_open = true

func close():
	self.visible = false
	is_open = false
