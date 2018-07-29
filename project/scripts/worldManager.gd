extends Node2D

var selected_units = []
var units = []
var buttons = []

onready var button = preload("res://scenes/Buttons.tscn")
onready var area2d = preload("res://scenes/Area2D.tscn")

func _ready():
	units = get_tree().get_nodes_in_group("units")
	print("unidades seleccionadas: " + str(units.size()))

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)

func button_was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break

func areaSelected(obj):
	var start = obj.start
	var end = obj.end
	
	var area = area2d.instance()
	area.x = obj.start.x
	area.y = obj.end.y

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