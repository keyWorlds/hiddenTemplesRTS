extends TextureButton

signal pop_unit

func _pressed():
	emit_signal("pop_unit")

func connect_me(obj, text):
	$Label.text = text
	connect("pop_unit", obj, "pop_unit")