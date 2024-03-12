extends Control

onready var main = get_tree().root.get_child(1)

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_ResumeButton_pressed():
	main.pause_menu.visible = false
	Engine.time_scale = 1
	main.resume_game()


func _on_BackToMenuButton_pressed():
	main.pause_menu.visible = false
	Engine.time_scale = 1
	main.resume_game()
	main.queue_free()
	get_tree().change_scene("res://Scenes/Main Menu/MainMenu.tscn")
