extends Control

var player_credits = 0

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Main Menu/LevelSelection.tscn")

func _on_ShopButton_pressed():
	pass 

func _on_QuitButton_pressed():
	get_tree().quit()





