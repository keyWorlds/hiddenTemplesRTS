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
var must_go_work

var nav2d

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
	sprite.texture = load("res://assets/art/sprites/Unit/medievalUnit_23.png")
	
	holdingResource = false
	hasTask = false
	
	must_take_shelter = false
	must_go_work = false

func _process(delta):
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta
	
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

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
