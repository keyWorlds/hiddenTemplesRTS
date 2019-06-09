extends Area2D

const RESOURCE = 10

onready var SLOT1 = get_node("Slots/Slot1")
onready var SLOT2 = get_node("Slots/Slot2")
onready var SLOT3 = get_node("Slots/Slot3")
onready var SLOT4 = get_node("Slots/Slot4")

# TODO: select all units in this task
# dont delete
var workingUnitsOnTask = []

func _on_Task_body_entered(body):
	if body.is_in_group("units"):
		var slot_setted = set_unit_in_slot(body)
		print(body.label.text + " is in slot " + str(slot_setted))

func set_unit_in_slot(unit):
	workingUnitsOnTask.append(unit)
	unit.set_selected(false)
	print("units in this source " + str(workingUnitsOnTask.size()))
	if (SLOT1.is_slot_free and not unit.hasTask):
		SLOT1.is_slot_free = false
		unit.startTask(SLOT1.get_global_position())
		return 1
	if (SLOT2.is_slot_free and not unit.hasTask):
		SLOT2.is_slot_free = false
		unit.startTask(SLOT2.get_global_position())
		return 2
	if (SLOT3.is_slot_free and not unit.hasTask):
		SLOT3.is_slot_free = false
		unit.startTask(SLOT3.get_global_position())
		return 3
	if (SLOT4.is_slot_free and not unit.hasTask):
		SLOT4.is_slot_free = false
		unit.startTask(SLOT4.get_global_position())
		return 4