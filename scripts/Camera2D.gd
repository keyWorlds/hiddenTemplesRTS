extends Camera2D

export var camera_speed = 5.0

func _ready():
	pass

func _process(delta):
	var xmov = (int(Input.is_action_pressed("ui_right"))
	                   - int(Input.is_action_pressed("ui_left")))
	var ymov = (int(Input.is_action_pressed("ui_down"))
	                   - int(Input.is_action_pressed("ui_up")))	
	position.x += xmov * camera_speed
	position.y += ymov * camera_speed
	pass