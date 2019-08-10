extends KinematicBody2D

export var selected = false setget set_selected

export var speed = 180

onready var box = $SelectionBox
onready var label = $UnitLabel
onready var lifebar = $LifeBar
onready var sprite = $BasicUnitSprite
onready var timer = $Timer

signal was_selected
signal was_unselected

var moveOnPath = false
var moveTo = Vector2()
var path = PoolVector2Array()
var initialPos = Vector2()

var life
var attack

var holdingResource
var hasTask

var must_take_shelter

func _ready():
	connect("was_selected", get_parent(), "select_unit")
	connect("was_unselected", get_parent(), "deselect_unit")
	
	life = 10
	attack = 5
	
	box.visible = false
	label.visible = false
	lifebar.visible = false
	label.text = name
	lifebar.value = 100
	sprite.texture = load("res://sprites/Unit/medievalUnit_23.png")
	
	holdingResource = false
	hasTask = false
	
	must_take_shelter = false

func _process(delta):
	if moveOnPath:
		path = get_viewport().get_node("world/nav").get_simple_path(position, moveTo)
		initialPos = position
		moveOnPath = false
	if path.size() > 0:
		move_towards(initialPos, path[0], delta)

# selection

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
		label.visible = value
		lifebar.visible = value
	if selected:
		emit_signal("was_selected", self)
	else:
		emit_signal("was_unselected", self)

func _on_unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			set_selected(not selected)

# movement

func move_towards(pos, point, delta):
	var v = (point - pos).normalized()
	v *= delta * speed
	position += v
	if position.distance_squared_to(point) < 9:
		path.remove(0)
		initialPos = position

func moveUnit(point):
	moveTo = point
	moveOnPath = true

# creation

func setup(pos, unitName):
	position = pos
	changeName(unitName)

func changeName(unitName):
	self.name = unitName
	name = unitName
	label.text = unitName

# work

func startTask(position):
	moveUnit(position)
	hasTask = true
	holdingResource = false
	timer.start()

func _on_Timer_timeout():
	if hasTask:
		holdingResource = true
		hasTask = false