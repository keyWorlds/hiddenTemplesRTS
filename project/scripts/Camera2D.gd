extends Camera2D

export var camera_speed = 15.0
export var panSpeed = 10.0
export var zoomspeed = 10.0
export var zoommargin = 0.1
export var zoommin = 0.5
export var zoommax = 3.0

export var marginX = 200.0
export var marginY = 100.0

var initialPos
var currentPos

var mousepos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startv = Vector2()
var end = Vector2()
var endv = Vector2()

var isDragging = false

var zoompos = Vector2()
var zoomfactor = 1.0
var zooming = false

var moveToPoint = Vector2()

onready var rectd = $"../UI/Base/drawRect"

signal areaSelected
signal start_move_selection

func _ready():
	connect("areaSelected", get_parent(), "areaSelected", [self])
	connect("start_move_selection", get_parent(), "start_move_selection", [self])

func _process(delta):
	# smooth camera movement
	var xmov = (int(Input.is_action_pressed("ui_right"))
	                   - int(Input.is_action_pressed("ui_left")))
	var ymov = (int(Input.is_action_pressed("ui_down"))
	                   - int(Input.is_action_pressed("ui_up")))	
	position.x = lerp(position.x, position.x + xmov * camera_speed * zoom.x, camera_speed * delta)
	position.y = lerp(position.y, position.y + ymov * camera_speed * zoom.y, camera_speed * delta)
	
	if Input.is_key_pressed(KEY_CONTROL):
		#check mousepos
		if mousepos.x < marginX:
			position.x = lerp(position.x, position.x - abs(mousepos.x - marginX)/marginX * panSpeed * zoom.x, panSpeed * delta)
		elif mousepos.x > OS.window_size.x - marginX:
			position.x = lerp(position.x, position.x + abs(mousepos.x - OS.window_size.x + marginX)/marginX *  panSpeed * zoom.x, panSpeed * delta)
		if mousepos.y < marginY:
			position.y = lerp(position.y, position.y - abs(mousepos.y - marginY)/marginY * panSpeed * zoom.y, panSpeed * delta)
		elif mousepos.y > OS.window_size.y - marginY:
			position.y = lerp(position.y, position.y + abs(mousepos.y - OS.window_size.y + marginY)/marginY * panSpeed * zoom.y, panSpeed * delta)

	# draggin!
	if Input.is_action_just_pressed("ui_left_mouse_button"):
		start = mousePosGlobal
		startv = mousepos
		isDragging = true
	if isDragging:
		end = mousePosGlobal
		endv = mousepos
		draw_area()
	if Input.is_action_just_released("ui_left_mouse_button"):
		if startv.distance_to(mousepos) > 20:
			end = mousePosGlobal
			endv = mousepos
			isDragging = false
			draw_area(false)
			emit_signal("areaSelected")
		else:
			end = start
			isDragging = false
			draw_area(false)
	
	if Input.is_action_just_released("ui_right_mouse_button"):
		moveToPoint = mousePosGlobal
		emit_signal("start_move_selection")

	# zoom management
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
	
	zoom.x = clamp(zoom.x, zoommin, zoommax)
	zoom.y = clamp(zoom.y, zoommin, zoommax)
	
	if not zooming:
		zoomfactor = 1.0

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		zooming = true
		if event.button_index == BUTTON_WHEEL_UP:
			zoomfactor -= 0.01 * zoomspeed
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoomfactor += 0.01 * zoomspeed
		zoompos = get_global_mouse_position()
	else:
		zooming = false
		
	if event is InputEventMouse:
		mousepos = event.position
		mousePosGlobal = get_global_mouse_position()

func draw_area(s = true):
		rectd.rect_size = Vector2(abs(startv.x - endv.x), abs(startv.y - endv.y))

		var pos = Vector2()
		pos.x = min(startv.x, endv.x)
		pos.y = min(startv.y, endv.y)
		pos.y -= OS.window_size.y
		rectd.rect_position = pos

		rectd.rect_size *= int(s)