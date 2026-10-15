extends Control

@onready var player: CharacterBody2D = $"../../player"
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

@onready var cam: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var marker: Sprite2D = $SubViewportContainer/SubViewport/Marker

var map_scale := 1.0
var is_in_range := false

signal map_open

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.zoom = Vector2(1.5, 1.5)
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map") and is_in_range:
		visible = not visible
		player.visible = not visible
		player.map_open = visible
		
		#Alert the enemies when map OPENS
		
		if visible:
			get_tree().call_group("enemies", "investigate", player.global_position)
		get_viewport().set_input_as_handled()

func _on_player_signal_changed(has_signal: bool) -> void:
	is_in_range = has_signal

func _process(delta: float) -> void:
	if not visible :
		return
	var map_pos = player.global_position * map_scale
	cam.position = map_pos
	marker.position = map_pos
