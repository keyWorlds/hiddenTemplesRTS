extends Area2D

const RESOURCE = 10

signal set_task
signal begin_task
signal task_ended

func _ready():
	connect("set_task", get_parent(), "set_task")
	connect("begin_task", get_parent(), "begin_task")
	connect("task_ended", get_parent(), "task_ended")

func _on_Task_body_entered(body):
	if body.is_in_group("units") and body.hasTask:
		emit_signal("begin_task", self)
		$Timer.start()

func _on_Timer_timeout():
	emit_signal("task_ended", self)
	$Timer.stop()

func _on_Task_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed and event.button_index == BUTTON_RIGHT):
		emit_signal("set_task", self)