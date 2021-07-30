extends TextureButton

signal create_brave

func _pressed():
	emit_signal("create_brave")

func connect_me(obj, text):
	$Label.text = text
	connect("create_brave", obj, "create_brave", [self])
