extends Control
class_name VolumeControlItem

enum AUDIO_TYPE_ENUM {
	BGM,
	SFX
}

const BGM_LABEL_TEXT = "BGM Vol."
const SFX_LABEL_TEXT = "SFX Vol."

@export var volume_multiplier: float = 1.0

@export var audio_type: AUDIO_TYPE_ENUM
@export var label: Label
@export var slider: HSlider

func _ready() -> void:
	if audio_type == AUDIO_TYPE_ENUM.BGM:
		label.text = BGM_LABEL_TEXT

	elif audio_type == AUDIO_TYPE_ENUM.SFX:
		label.text = SFX_LABEL_TEXT

func _on_h_slider_value_changed(value: float) -> void:
	if audio_type == AUDIO_TYPE_ENUM.BGM:
		BackgroundMusicManager.volume_linear = (value / 100) * volume_multiplier   # the "/ 100" is written in the blood of my ears

	elif audio_type == AUDIO_TYPE_ENUM.SFX:
		pass
