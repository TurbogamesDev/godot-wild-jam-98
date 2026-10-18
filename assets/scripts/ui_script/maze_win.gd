extends Area2D

const WIN_SCREEN = "res://assets/scenes/ui/win_screen.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		BackgroundMusicManager.play_bgm(
			BackgroundMusicManager.MUSIC_TYPE.VICTORY,
			true
		)

		get_tree().change_scene_to_file(WIN_SCREEN)
