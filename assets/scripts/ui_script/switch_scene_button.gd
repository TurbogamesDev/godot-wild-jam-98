extends Button
class_name PlayMenuButton

@export var button_text: String
@export var scene_path: String

@export var music_type_after_click: BackgroundMusicManager.MUSIC_TYPE = BackgroundMusicManager.MUSIC_TYPE.NO_EFFECT
@export var loop_music_after_click: bool = true

func _ready() -> void:
	$Text.text = button_text

func _on_pressed() -> void:
	if music_type_after_click != BackgroundMusicManager.MUSIC_TYPE.NO_EFFECT:
		BackgroundMusicManager.play_bgm(music_type_after_click, loop_music_after_click)

	get_tree().change_scene_to_file(scene_path)
