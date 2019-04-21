extends KinematicBody2D

export var selected = false setget set_selected

onready var box = $SelectionBox

signal was_selected
signal was_unselected

func _ready():
	connect("was_selected", get_parent(), "select_cu")
	connect("was_unselected", get_parent(), "unselect_cu")
	box.visible = false

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
	if selected:
		emit_signal("was_selected")
	else:
		emit_signal("was_unselected")

func _on_building_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			set_selected(not selected)
