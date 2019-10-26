extends Node2D

var selected_units = []
var units = []
var unit_buttons = []

var cu
var create_brave_b
var pop_button
var spawner

var resources = 0

onready var brave = preload("res://src/scenes/units/unit_basic.tscn")

onready var button = preload("res://src/scenes/ui/Buttons.tscn")
onready var create_brave_button = preload("res://src/scenes/ui/ButtonsCU.tscn")
onready var popunit_button = preload("res://src/scenes/ui/ButtonPop.tscn")
onready var area2d = preload("res://src/scenes/ui/Area2D.tscn")
onready var exitDialog = get_node("UI/Base/ExitDialog")

func _ready():
	units = get_tree().get_nodes_in_group("units")
	cu = get_node("CU")
	spawner = get_node("UnitSpawner")
	
	resources = 0

# units

func select_unit(unit):
	if (cu.selected):
		cu.set_selected(false)
	if not selected_units.has(unit):
		selected_units.append(unit)
	create_unit_buttons()

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
	create_unit_buttons()

# buildings

func select_cu():
	if selected_units.empty():
		deselect_all_units()
		create_cu_button()
	else:
		units_take_shelter()

func unselect_cu():
	delete_cu_button()
	
func units_take_shelter():
	for unit in selected_units:
		unit.must_take_shelter = true

func select_source():
	print("source is selected!")
	if not selected_units.empty():
		units_go_work()
		print("units go work!")

func units_go_work():
	for unit in selected_units:
		unit.must_go_work = true

# area selection (wip)

func areaSelected(obj):
	var start = obj.start
	var end = obj.end
	
	var area = area2d.instance()
	add_child(area)

	var body_list = area.get_overlapping_bodies()
	print(body_list)
	for i in body_list:
		if i.is_in_group("units"): 
			selected_units.append(i)
	
	if not Input.is_key_pressed(KEY_SHIFT):
		deselect_all_units()
	for u in selected_units:
		u.selected = not u.selected

func get_units_in_area(area):
	var u = []
	for unit in units:
		if unit.position.x > area[0].x and unit.position.x < area[1].x:
			if unit.position.y > area[0].y and unit.position.y < area[1].y:
				u.append(unit)
	return u

func deselect_all_units():
	while selected_units.size() > 0:
		selected_units[0].set_selected(false)

func start_move_selection(obj):
	for unit in selected_units:
		unit.moveUnit(obj.moveToPoint)

# gui

## exit game controller

func _on_ExitButton_pressed():
	exitDialog.popup()

func _on_ExitDialog_confirmed():
	get_tree().change_scene("res://scenes/Menu.tscn")
	pass

## units

func create_unit_buttons():
	delete_unit_buttons()
	for unit in selected_units:
		if not unit_buttons.has(unit.name):
			var but = button.instance()
			but.connect_me(self, unit.name)
			but.rect_position = Vector2(unit_buttons.size() * 100 , -90)
			$'UI/Base'.add_child(but)
			unit_buttons.append(unit.name)

func delete_unit_buttons():
	for but in unit_buttons:
		if $'UI/Base'.has_node(but):
			var b = $'UI/Base'.get_node(but)
			b.queue_free()
			$'UI/Base'.remove_child(b)
	unit_buttons.clear()

func button_was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break

## buildings

func create_cu_button():
	create_brave_b = create_brave_button.instance()
	create_brave_b.connect_me(self, "Create brave")
	create_brave_b.rect_position = Vector2(50, -90)
	
	pop_button = popunit_button.instance()
	pop_button.connect_me(self, "Pop unit")
	pop_button.rect_position = Vector2(200, -90) 
	
	$'UI/Base'.add_child(create_brave_b)
	$'UI/Base'.add_child(pop_button)

func delete_cu_button():
	create_brave_b.queue_free()
	pop_button.queue_free()
	$'UI/Base'.remove_child(create_brave_b)
	$'UI/Base'.remove_child(pop_button)

func create_brave(obj):
	var newUnit = brave.instance()
	units.append(newUnit)
	var unitName = "Brave" + str(units.size())
	add_child(newUnit)
	newUnit.setup(spawner.position, unitName)

func pop_unit():
	cu.pop_sheltered_units()