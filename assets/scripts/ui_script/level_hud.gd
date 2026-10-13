extends Control
class_name LevelHUD

@export var player: Player
@export var label: Label

const HAS_SIGNAL_TEXT = "CONNECTED"
const NO_SIGNAL_TEXT = "NO SIGNAL"

func _ready() -> void:
	player.signal_changed.connect(_on_signal_changed)

func _on_signal_changed(has_signal: bool) -> void:
	label.text = HAS_SIGNAL_TEXT if has_signal else NO_SIGNAL_TEXT
