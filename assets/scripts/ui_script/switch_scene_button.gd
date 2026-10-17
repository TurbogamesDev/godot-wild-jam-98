extends Button
class_name PlayMenuButton

@export var button_text: String
@export var scene_path: String

func _ready() -> void:
	$Text.text = button_text

func _on_pressed() -> void:
	BackgroundMusicManager.play_bgm(BackgroundMusicManager.IN_GAME_MUSIC_PATH)

	get_tree().change_scene_to_file(scene_path)
