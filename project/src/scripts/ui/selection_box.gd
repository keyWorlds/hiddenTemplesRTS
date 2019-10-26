extends Control

var initialPos
var currentPos

var camera
var selectableObjects = []

func _ready(true):
	set_process(true)

func createBox(pos):
	print("lol")
	if Input.is_action_just_pressed("ui_left_mouse_button"):
		initialPos = pos
		set_begin(initialPos)
	if Input.is_action_pressed("ui_left_mouse_button"):
		currentPos = pos
		set_begin(Vector2(min(initialPos.x, currentPos.x), min(initialPos.y, currentPos.y)))
		set_end(Vector2(max(initialPos.x, currentPos.x), max(initialPos.y, currentPos.y)))
	if Input.is_action_just_released("ui_left_mouse_button"):
		selectObjects()
		set_begin(Vector2(0, 0))
		set_end(Vector2(0, 0))

func selectObjects():
	var selectionRect = get_rect()
	for u in selectableObjects:
			u.emit_signal("set_selected", selectionRect.has_point(u.get_pos()))