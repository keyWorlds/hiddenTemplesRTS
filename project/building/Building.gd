extends Area2D

export var selected = false setget set_selected

onready var box = $SelectionBox

signal was_selected
signal was_unselected
signal pop_sheltered_unit

var units_sheltered = []

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
		if event.button_index == BUTTON_RIGHT:
			emit_signal("was_selected")

func _on_CU_body_entered(body):
	if body.is_in_group("units") and body.must_take_shelter:
		units_sheltered.append(body)
		body.must_take_shelter = false
		body.set_selected(false)
		print("units sheltered " + String(units_sheltered.size()))
		body.queue_free()

func pop_sheltered_units():
	if units_sheltered.size() > 0:
		#var poped_unit = units_sheltered.pop_back()
		print("poped units! (" + String(units_sheltered.size()) + ")")