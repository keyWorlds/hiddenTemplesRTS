extends Control

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_LoadButton_pressed():
	# change to load scene
	pass

func _on_ExitButton_pressed():
	get_tree().quit()
