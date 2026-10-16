extends AudioStreamPlayer

const MAIN_MENU_MUSIC_PATH = "res://assets/audio/bgm/main_menu_theme.ogg"

func _ready() -> void:
    play_bgm(MAIN_MENU_MUSIC_PATH)

func play_bgm(path_name: String):
    self.stream = load(path_name)
    
    self.play()