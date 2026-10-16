extends CharacterBody2D

enum State { WANDER, INVESTIGATE, CHASE }

@export var wander_speed := 50.0
@export var chase_speed := 90.0
@export var lose_sight_time := 1.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sight: Area2D = $SightArea

var state := State.WANDER
var player: Node2D          # only set while the player is inside the circle
var lost_timer := 0.0

func _ready() -> void:
	add_to_group("enemies")
	sight.body_entered.connect(_on_sight_entered)
	sight.body_exited.connect(_on_sight_exited)
	nav.navigation_finished.connect(_on_arrived)
	_pick_wander_target()

func _on_sight_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_sight_exited(body: Node2D) -> void:
	if body == player:
		player = null

# Called by your map script
func investigate(pos: Vector2) -> void:
	if state == State.CHASE:
		return
	state = State.INVESTIGATE
	nav.target_position = pos

func _physics_process(delta: float) -> void:
	if player != null:
		state = State.CHASE
		lost_timer = lose_sight_time
		nav.target_position = player.global_position
	elif state == State.CHASE:
		lost_timer -= delta
		if lost_timer <= 0.0:
			state = State.WANDER
			_pick_wander_target()

	if nav.is_navigation_finished():
		return

	var speed := chase_speed if state == State.CHASE else wander_speed
	var next_pos := nav.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * speed
	move_and_slide()

func _on_arrived() -> void:
	if state != State.CHASE:
		state = State.WANDER
		_pick_wander_target()

func _pick_wander_target() -> void:
	var point := global_position + Vector2.from_angle(randf() * TAU) * randf_range(50.0, 200.0)
	nav.target_position = NavigationServer2D.map_get_closest_point(nav.get_navigation_map(), point)
