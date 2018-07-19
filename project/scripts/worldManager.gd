extends Node2D

var selected_units = []
var buttons = []

var units = []

onready var button = preload("res://scenes/Buttons.tscn")

func _ready():
	units = get_tree().get_nodes_in_group("units")

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

func areaSelected(obj):
	var start = obj.start
	var end = obj.end
	var area = []
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	var ut = get_units_in_area(area)
	if not Input.is_key_pressed(KEY_SHIFT):
		deselect_all()
	for u in ut:
		u.selected = not u.selected

func get_units_in_area(area):
	var u = []
	for unit in units:
		if unit.position.x > area[0].x and unit.position.x < area[1].x:
			if unit.position.y > area[0].y and unit.position.y < area[1].y:
				u.append(unit)
	return u

func deselect_all():
	while selected_units.size() > 0:
		selected_units[0].set_selected(false)