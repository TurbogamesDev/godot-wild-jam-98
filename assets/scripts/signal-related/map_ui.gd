extends Control

signal map_open
var is_in_range := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map") and is_in_range:
		visible = not visible
		get_tree().paused = visible
		get_viewport().set_input_as_handled()

func _on_player_signal_changed(has_signal: bool) -> void:
	is_in_range = has_signal
