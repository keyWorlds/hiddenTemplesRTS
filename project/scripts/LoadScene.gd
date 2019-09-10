extends Control

var loadedGames = [] 
var selectedGame

var SAVING_PATH = "user://saves"

onready var list = get_node("LoadedGames")

func _ready():
	# load games and list
	read_files()

func read_files():
	var dir = Directory.new()
	dir.open("user://")
	if not dir.dir_exists(SAVING_PATH):
		dir.make_dir(SAVING_PATH)
	dir.open(SAVING_PATH)
	
	dir.list_dir_begin()
	var file = dir.get_next()
	while dir.get_next():
		file = dir.get_next()
		if file != "":
			loadedGames.append(file)
	dir.list_dir_end()
	
	load_saves_board()

func load_saves_board():
	# create label instances to add file name nodes
	for file in loadedGames:
		print(file)

func _on_LoadedGames_item_selected(index):
	selectedGame = loadedGames[index]

func _on_CancelButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_LoadButton_pressed():
	# load selected game info
	# pass it to main scene, start game!
	get_tree().change_scene("res://scenes/Main.tscn")
