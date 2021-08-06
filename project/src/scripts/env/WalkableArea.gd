extends Area2D

onready var navigation = $Navigation2D

func _on_WalkableArea_body_entered(body):
	if "Unit" in body.name:
			body.nav2d = navigation
	pass
