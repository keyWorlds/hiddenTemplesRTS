extends Area2D

const RESOURCE = 10

# TODO: select all units in this task
# dont delete
var workingUnitsOnTask = []

func _on_Task_body_entered(body):
	if body.is_in_group("units"):
		body.startTask()