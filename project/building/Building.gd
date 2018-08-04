extends KinematicBody2D

export var selected = false setget set_selected

onready var box = $SelectionBox

signal was_selected
signal was_unselected

func _ready():
	connect("was_selected", get_parent(), "cu_selected")
	connect("was_unselected", get_parent(), "cu_unselected")
	box.visible = false

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value

func _on_building_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			set_selected(not selected)
