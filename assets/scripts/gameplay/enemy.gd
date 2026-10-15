extends CharacterBody2D

@export var speed := 80.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	add_to_group("enemies")

func investigate(pos: Vector2) -> void:
	nav.target_position = pos

func _physics_process(_delta: float) -> void:
	if nav.is_navigation_finished():
		return
	var next_pos := nav.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * speed
	move_and_slide()
