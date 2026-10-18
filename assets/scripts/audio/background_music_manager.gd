extends AudioStreamPlayer

enum MUSIC_TYPE {
	NO_EFFECT,
	NONE,
	MAIN_MENU,
	IN_GAME,
	VICTORY,
	DEFEAT
}

const MUSIC_PATHS: Dictionary[MUSIC_TYPE, String] = {
	MUSIC_TYPE.NONE: "",
	MUSIC_TYPE.MAIN_MENU: "res://assets/audio/bgm/main_menu_theme.ogg",
	MUSIC_TYPE.IN_GAME: "res://assets/audio/bgm/in_game_theme.ogg",
	MUSIC_TYPE.VICTORY: "res://assets/audio/bgm/victory_theme.ogg",
	MUSIC_TYPE.DEFEAT: "res://assets/audio/bgm/death_theme.ogg"
}

var looping = false

func _ready() -> void:
	self.finished.connect(func() -> void:
		if not looping:
			return

		self.play()
	)

	play_bgm(MUSIC_TYPE.MAIN_MENU, true)

func play_bgm(music_type_selected: MUSIC_TYPE, loop_music: bool):
	var music_path = MUSIC_PATHS[music_type_selected]

	if music_path == "":
		self.stop()

		return

	looping = loop_music

	self.stream = load(MUSIC_PATHS[music_type_selected])
	
	self.play()
