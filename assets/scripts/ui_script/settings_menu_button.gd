extends Button
class_name SettingsMenuButton

@export var settingsMenuScene: Control

func _on_pressed() -> void:
	settingsMenuScene.visible = true
