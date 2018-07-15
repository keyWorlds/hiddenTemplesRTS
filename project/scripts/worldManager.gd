extends Node2D

var selected_units = []
var buttons = []

onready var button = preload("res://scenes/Buttons.tscn")

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
		print("you have selected a unit!")
	create_buttons()

func unselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
		print("you have selected a unit!")
	create_buttons()

func create_buttons():
	delete_buttons()
	for unit in selected_units:
		if not buttons.has(unit.name):
			var but = button.instance()
			but.connect_me(self, unit.name)
			but.rect_position = Vector2(buttons.size() * 64 + 32 , -120)
			$'UI/Base'.add_child(but)
			buttons.append(unit.name)

func delete_buttons():
	for but in buttons:
		if $'UI/Base'.has_node(but):
			var b = $'UI/Base'.get_node(but)
			$'UI/Base'.remove_child(b)
			b.queue_free()
	buttons.clear()
	print("buttons must be cleared! but they arent... :shrug:")

func button_was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break