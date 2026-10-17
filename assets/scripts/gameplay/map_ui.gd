extends Control

@onready var player: CharacterBody2D = $"../../player"
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

@onready var cam: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var marker: Sprite2D = $SubViewportContainer/SubViewport/Marker

var map_scale := 1.0
var is_in_range := false
var ping_timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.zoom = Vector2(1.25, 1.25)
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_map") and is_in_range:
		visible = not visible
		player.visible = not visible
		player.map_open = visible
		
		#Alert the enemies when map OPENS
		
		if visible:
			var current_pos = player.global_position

			await get_tree().create_timer(1.5).timeout
			get_tree().call_group("enemies", "investigate", current_pos)
		get_viewport().set_input_as_handled()

func _on_player_signal_changed(has_signal: bool) -> void:
	is_in_range = has_signal

func _process(delta: float) -> void:
	#Update your position to the enemies every X seconds
	if player.map_open and player.has_signal:
		ping_timer -= delta
		if ping_timer <= 0.0:
			get_tree().call_group("enemies", "investigate", player.global_position)
			ping_timer = 2.0
	
	if not visible :
		return
	
	var map_pos = player.global_position * map_scale
	cam.position = map_pos
	marker.position = map_pos
