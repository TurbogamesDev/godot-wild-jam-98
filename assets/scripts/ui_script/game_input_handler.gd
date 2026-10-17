extends Node2D
class_name GameInputHandler

@export var settingsMenu: SettingsMenu

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("settings"):
		settingsMenu.toggle()
