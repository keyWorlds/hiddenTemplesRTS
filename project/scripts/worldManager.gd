extends Node2D

var selected_units = []
var units = []
var buttons = []

var create_brave_b

onready var button = preload("res://scenes/Buttons.tscn")
onready var create_brave_button = preload("res://scenes/ButtonsCU.tscn")
onready var area2d = preload("res://scenes/Area2D.tscn")

func _ready():
	units = get_tree().get_nodes_in_group("units")
	print("unidades totales: " + str(units.size()))

# units

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	create_buttons()

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
		print("unidades seleccionadas: " + str(selected_units.size()))
	create_buttons()

# buildings

func select_cu(cu):
	create_cu_button()
	print("select cu, create button")

func unselect_cu(cu):
	delete_cu_button()
	print("unselect cu, delete button")

# area selection (wip)

func areaSelected(obj):
	var start = obj.start
	var end = obj.end
	
	var area = area2d.instance()

	get_tree().get_root().get_node("world").add_child(area)

	var body_list = area.get_overlapping_bodies()
	print(body_list)
	for i in body_list:
		if i.is_in_group("units"): 
			selected_units.append(i)
	
	if not Input.is_key_pressed(KEY_SHIFT):
		deselect_all()
	for u in selected_units:
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

func start_move_selection(obj):
	for unit in selected_units:
		unit.moveUnit(obj.moveToPoint)

# gui

func create_buttons():
	delete_buttons()
	for unit in selected_units:
		if not buttons.has(unit.name):
			var but = button.instance()
			but.connect_me(self, unit.name)
			but.rect_position = Vector2(buttons.size() * 100 , -90)
			$'UI/Base'.add_child(but)
			buttons.append(unit.name)

func delete_buttons():
	print("deleting!")
	for but in buttons:
		if $'UI/Base'.has_node(but):
			var b = $'UI/Base'.get_node(but)
			b.queue_free()
			$'UI/Base'.remove_child(b)
	buttons.clear()

func button_was_pressed(obj):
	print("unit button")
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break

func create_cu_button():
	create_brave_b = create_brave_button.instance()
	create_brave_b.connect_me(self, "Moar braves")
	create_brave_b.rect_position = Vector2(50, -90)
	$'UI/Base'.add_child(create_brave_b)

func delete_cu_button():
	create_brave_b.queue_free()
	$'UI/Base'.remove_child(create_brave_b)

func create_brave(obj):
	print("Brave was created!")
	