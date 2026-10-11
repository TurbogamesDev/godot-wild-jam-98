extends Button
class_name CloseButton

@export var controlToClose: Control

func _on_pressed() -> void:
	controlToClose.visible = false