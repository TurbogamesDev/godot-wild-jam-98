extends Button
class_name PlayMenuButton

const MAIN_SCENE_PATH = "res://assets/scenes/levels/test_level.tscn"

func _on_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)
