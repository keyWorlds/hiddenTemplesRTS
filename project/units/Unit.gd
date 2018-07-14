extends Node

export var selected = false
onready var box = $SelectionBox

var unitname
var life
var attack

func _process(delta):
	if selected and box.visible == false:
		box.visible = true
	else:
		if box.visible:
			box.visible = false

func _on_unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			selected = true
		if event.button_index == BUTTON_RIGHT:
			selected = false
	pass
