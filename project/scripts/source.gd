extends Area2D

const RESOURCE = 10

signal source_is_selected

onready var SLOT1 = get_node("Slots/Slot1")
onready var SLOT2 = get_node("Slots/Slot2")
onready var SLOT3 = get_node("Slots/Slot3")
onready var SLOT4 = get_node("Slots/Slot4")

func _ready():
	connect("source_is_selected", get_parent().get_parent(), "select_source")

# TODO: select all units in this task
# dont delete
var workingUnitsOnTask = []

func _on_Task_body_entered(body):
	if body.is_in_group("units") and body.must_go_work:
		var slot_setted = set_unit_in_slot(body)
		body.must_go_work = false

func set_unit_in_slot(unit):
	if (SLOT1.is_slot_free and not unit.hasTask):
		unit_works_in_slot(SLOT1, unit)
		return 1
	if (SLOT2.is_slot_free and not unit.hasTask):
		unit_works_in_slot(SLOT2, unit)
		return 2
	if (SLOT3.is_slot_free and not unit.hasTask):
		unit_works_in_slot(SLOT3, unit)
		return 3
	if (SLOT4.is_slot_free and not unit.hasTask):
		unit_works_in_slot(SLOT4, unit)
		return 4

func unit_works_in_slot(slot, unit):
	slot.is_slot_free = false
	unit.startTask(slot.get_global_position())
	workingUnitsOnTask.append(unit)
	unit.set_selected(false)

func _on_Task_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_RIGHT:
			print("emit signal!")
			emit_signal("source_is_selected")
			
