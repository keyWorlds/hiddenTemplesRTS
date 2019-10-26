extends Control

func _on_StartButton_pressed():
	get_tree().change_scene("res://src/scenes/ui/Main.tscn")

func _on_LoadButton_pressed():
	get_tree().change_scene("res://src/scenes/ui/Load.tscn")
	pass

func _on_ExitButton_pressed():
	get_tree().quit()
