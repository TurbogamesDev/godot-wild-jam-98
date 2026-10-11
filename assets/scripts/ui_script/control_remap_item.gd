extends Control
class_name ControlRemapItem

const CONTROLLER_LABELS: Dictionary = {
	JoyButton.JOY_BUTTON_A: "🎮A",
	JoyButton.JOY_BUTTON_B: "🎮B",
	JoyButton.JOY_BUTTON_X: "🎮X",
	JoyButton.JOY_BUTTON_Y: "🎮Y",
	JoyButton.JOY_BUTTON_LEFT_SHOULDER: "LB",
	JoyButton.JOY_BUTTON_RIGHT_SHOULDER: "RB",
	JoyButton.JOY_BUTTON_LEFT_STICK: "L3",
	JoyButton.JOY_BUTTON_RIGHT_STICK: "R3",
	JoyButton.JOY_BUTTON_DPAD_UP: "🎮↑",
	JoyButton.JOY_BUTTON_DPAD_DOWN: "🎮↓",
	JoyButton.JOY_BUTTON_DPAD_LEFT: "🎮←",
	JoyButton.JOY_BUTTON_DPAD_RIGHT: "🎮→",
	JoyButton.JOY_BUTTON_START: "Start",
	JoyButton.JOY_BUTTON_GUIDE: "Select"
}

@export var actionName: String
@export var actionEventIndex: int

@export var remapButton: Button
@export var actionNameLabel: Label

func _ready() -> void:
	actionNameLabel.text = actionName

	remapButton.toggle_mode = true

	remapButton.text = get_current_control_keybind()

func get_current_control_keybind():
	var input = InputMap.action_get_events(actionName)[actionEventIndex]

	if input is InputEventJoypadButton:
		if CONTROLLER_LABELS.has(input.button_index):
			return CONTROLLER_LABELS.get(input.button_index)

		else:
			return "Btn" + str(input.button_index)

	elif InputEventKey:
		if input.physical_keycode == 0:
			return OS.get_keycode_string(input.keycode)

		else:
			return OS.get_keycode_string(input.physical_keycode)

func _on_button_toggled(toggled_on: bool) -> void:
	if !actionName or !InputMap.has_action(actionName):
		return

	if toggled_on:
		remapButton.text = "..."
		return

	if actionEventIndex >= InputMap.action_get_events(actionName).size():
		remapButton.text = "None"
		return

	remapButton.text = get_current_control_keybind()

func _unhandled_input(event: InputEvent) -> void:
	if !InputMap.has_action(actionName) or !remapButton.is_pressed():
		return

	if event.is_pressed() and (event is InputEventKey or event is InputEventJoypadButton):
		var action_events_list = InputMap.action_get_events(actionName)

		if actionEventIndex < action_events_list.size():
			InputMap.action_erase_event(actionName, action_events_list[actionEventIndex])

		InputMap.action_add_event(actionName, event)

		actionEventIndex = InputMap.action_get_events(actionName).size() - 1

		remapButton.button_pressed = false

		release_focus()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		remapButton.button_pressed = false

		release_focus()
