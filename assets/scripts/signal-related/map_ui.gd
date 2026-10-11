extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map"):
		visible = not visible
		get_tree().paused = visible
		get_viewport().set_input_as_handled()
	
