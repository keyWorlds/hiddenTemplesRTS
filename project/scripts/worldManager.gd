extends Node2D

var selected_units = []

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
		print("you have selected a unit!")
	pass

func unselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
		print("you have selected a unit!")
	pass