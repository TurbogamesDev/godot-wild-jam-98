extends CharacterBody2D

enum State { WANDER, INVESTIGATE, CHASE }

@export var wander_speed := 40.0
@export var investigate_speed := 120.0
@export var chase_speed := 75.0
@export var lose_sight_time := 1.5
@export var hear_range := 480.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sight: Area2D = $SightArea
@onready var catch: Area2D = $CatchArea

@export var player: Node2D  # Only set while the player is inside the circle
var state := State.WANDER   # Switch between states easier idk
var lost_timer := 1.5       # Time the enemy sits still after losing you

var player_in_sight: bool = false

const LOSE_SCREEN := "res://assets/scenes/ui/death_screen.tscn"

func _ready() -> void:
	add_to_group("enemies") # Connecting different things
	sight.body_entered.connect(_on_sight_entered)
	sight.body_exited.connect(_on_sight_exited)
	catch.body_entered.connect(_on_catch_entered)
	nav.navigation_finished.connect(_on_arrived)
	nav.target_position = self.global_position

#Updating the player variable while in line of sight to chase it
func _on_sight_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_sight = true

func _on_sight_exited(body: Node2D) -> void:
	if body == player:
		player_in_sight = false
		
# Lose function
func _on_catch_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		BackgroundMusicManager.play_bgm(
			BackgroundMusicManager.MUSIC_TYPE.DEFEAT,
			false
		)

		get_tree().change_scene_to_file(LOSE_SCREEN)

# Investigate the map ping if relatively close
func investigate(pos: Vector2) -> void:
	if state == State.CHASE:
		return
	if global_position.distance_to(pos) > hear_range:
		return
	state = State.INVESTIGATE
	nav.target_position = pos

func _physics_process(delta: float) -> void:
	# If it sees the player:
	if player_in_sight or state == State.CHASE:
		state = State.CHASE # Start chase
		lost_timer = lose_sight_time if player_in_sight else lost_timer - delta

		if lost_timer <= 0.0:
			state = State.WANDER
			_pick_wander_target()

		nav.target_position = player.global_position # Pathfind
	# If it doesnt see the player and it was in a chase:
	
		

	if nav.is_navigation_finished():
		return

	# Setting the enemy speed and pathfinding
	var speed := wander_speed
	if state == State.INVESTIGATE:
		speed = investigate_speed
	elif state == State.CHASE:
		speed = chase_speed
	var next_pos := nav.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * speed
	var direction := velocity
	move_and_slide()
	update_animation(direction)

func _on_arrived() -> void: # When it finishes INVESTIGATE
	if state != State.CHASE:
		_pick_wander_target()
		state = State.WANDER

func _pick_wander_target() -> void:
	var start_point: Vector2 = lerp(player.global_position, Vector2(1250.0, 150.0), (randf() * 1.5) - 0.5)
	# Calculates some random point near it
	var point := start_point + Vector2.from_angle(randf() * TAU) * randf_range(0.0, 64.0)
	# Checks the closest valid position it can wander to near that point
	var closest_point: Vector2 = NavigationServer2D.map_get_closest_point(nav.get_navigation_map(), point)
	nav.target_position = closest_point

func update_animation(direction: Vector2) -> void:
	if direction:
		sprite.flip_h = direction.x < 0
