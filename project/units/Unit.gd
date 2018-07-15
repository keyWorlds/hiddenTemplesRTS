extends KinematicBody2D

export var selected = false setget set_selected

onready var box = $SelectionBox
onready var label = $UnitLabel
onready var lifebar = $LifeBar

signal was_selected
signal was_unselected

var unitname
var life
var attack

func _ready():
	connect("was_selected", get_parent(), "select_unit")
	connect("was_unselected", get_parent(), "unselect_unit")
	box.visible = false
	label.visible = false
	lifebar.visible = false
	label.text = name
	lifebar.value = 100
	pass

func _process(delta):
	pass

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
		label.visible = value
		lifebar.visible = value
	if selected:
		emit_signal("was_selected", self)
	else:
		emit_signal("was_selected", self)

func _on_unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			set_selected(not selected)
	pass
