extends KinematicBody2D

export var selected = false setget set_selected
onready var box = $SelectionBox

signal was_selected
signal was_unselected

var unitname
var life
var attack

func _ready():
	connect("was_selected", get_parent(), "select_unit")
	connect("was_unselected", get_parent(), "unselect_unit")
	pass

func _process(delta):
	pass

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
	if selected:
		emit_signal("was_selected", self)
	else:
		emit_signal("was_selected", self)

func _on_unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			set_selected(true)
		if event.button_index == BUTTON_RIGHT:
			set_selected(false)
	pass
