extends Control

onready var pages = $Pages.get_children()
var page_index = 0
var max_page = 5
var min_page = 0



func _on_PreviousButton_pressed():
	menu_bgm.click()
	pages[page_index].visible = false
	page_index -= 1
	if page_index < min_page:
		page_index = max_page
	pages[page_index].visible = true


func _on_NextButton_pressed():
	menu_bgm.click()
	pages[page_index].visible = false
	page_index += 1
	if page_index > max_page:
		page_index = min_page
	pages[page_index].visible = true


func _on_BackButton_pressed():
	menu_bgm.click()
	get_tree().change_scene("res://Scenes/Main Menu/MainMenu.tscn")
