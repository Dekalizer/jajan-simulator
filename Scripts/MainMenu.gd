extends Control

func _ready():
	if !menu_bgm.get_node("BGM").playing:
		menu_bgm.play_music()

func _on_PlayButton_pressed():
	menu_bgm.click()
	get_tree().change_scene("res://Scenes/Main Menu/LevelSelection.tscn")

func _on_ShopButton_pressed():
	menu_bgm.click()
	get_tree().change_scene("res://Scenes/Main Menu/Shop.tscn")

func _on_HowToPlayButton_pressed():
	menu_bgm.click()
	get_tree().change_scene("res://Scenes/Main Menu/Tutorial.tscn")

func _on_QuitButton_pressed():
	menu_bgm.click()
	get_tree().quit()
