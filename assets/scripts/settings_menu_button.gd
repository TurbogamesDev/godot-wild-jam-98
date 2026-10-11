extends Button
class_name SettingsMenuButton

const SETTINGS_MENU_SCENE_PATH = "res://assets/scenes/settings_menu.tscn"

func _on_pressed() -> void:
    get_tree().change_scene_to_file(SETTINGS_MENU_SCENE_PATH)
