extends TextureButton

signal button_was_pressed

func _pressed():
	emit_signal("button_was_pressed")

func connect_me(obj, unit_name):
	name = unit_name
	$Label.text = unit_name
	connect("button_was_pressed", obj, "button_was_pressed", [self])
