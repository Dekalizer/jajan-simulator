extends Control

const SLIDESHOW_TIMER = 2.0

onready var slides = get_children()
var current_slide = 0

func _ready():
	start_slide_timer()

func _process(delta):
	pass

func start_slide_timer():
	var timer = Timer.new()
	timer.wait_time = SLIDESHOW_TIMER
	timer.one_shot = true 
	timer.connect("timeout", self, "_go_next")  
	add_child(timer)
	timer.start()

func _go_next():
	slides[current_slide].visible = false
	current_slide += 1
	if current_slide == slides.size():
		get_tree().change_scene("res://Scenes/Main Menu/MainMenu.tscn")
		queue_free()
	else:
		slides[current_slide].visible = true
		start_slide_timer()
	
