extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Main Menu/LevelSelection.tscn")

func _on_ShopButton_pressed():
	get_tree().change_scene("res://Scenes/Main Menu/Shop.tscn")

func _on_HowToPlayButton_pressed():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	get_tree().quit()
