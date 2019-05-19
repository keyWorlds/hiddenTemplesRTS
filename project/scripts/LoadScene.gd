extends Control

var loadedGames
var selectedGame

func _ready():
	# load games and list
	pass

func _on_LoadedGames_item_selected(index):
	selectedGame = loadedGames[index]

func _on_CancelButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_LoadButton_pressed():
	# load selected game info
	# pass it to main scene, start game!
	get_tree().change_scene("res://scenes/Main.tscn")
