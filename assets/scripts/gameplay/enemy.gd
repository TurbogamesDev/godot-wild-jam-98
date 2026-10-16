extends CharacterBody2D

enum State { WANDER, INVESTIGATE, CHASE }

@export var wander_speed := 40.0
@export var investigate_speed := 60.0
@export var chase_speed := 80.0
@export var lose_sight_time := 1.5
@export var hear_range := 320.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var sight: Area2D = $SightArea
@onready var catch: Area2D = $CatchArea

var state := State.WANDER   # Switch between states easier idk
var player: Node2D          # Only set while the player is inside the circle
var lost_timer := 1.0       # Time the enemy sits still after losing you

func _ready() -> void:
	add_to_group("enemies") # Connecting different things
	sight.body_entered.connect(_on_sight_entered)
	sight.body_exited.connect(_on_sight_exited)
	catch.body_entered.connect(_on_catch_entered)
	nav.navigation_finished.connect(_on_arrived)
	_pick_wander_target()  # Making the enemy wander at the start

#Updating the player variable while in line of sight to chase it
func _on_sight_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_sight_exited(body: Node2D) -> void:
	if body == player:
		player = null
		
# Lose function
func _on_catch_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("you are dead")

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
	if player != null:
		state = State.CHASE # Start chase
		lost_timer = lose_sight_time # Update lost timer
		nav.target_position = player.global_position # Pathfind
	# If it doesnt see the player and it was in a chase:
	elif state == State.CHASE: 
		# Wait the timer then wander
		lost_timer -= delta 
		if lost_timer <= 0.0:
			state = State.WANDER
			_pick_wander_target()

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
	move_and_slide()

func _on_arrived() -> void: # When it finishes INVESTIGATE
	if state != State.CHASE:
		state = State.WANDER
		_pick_wander_target()

func _pick_wander_target() -> void:
	# Calculates some random point near it
	var point := global_position + Vector2.from_angle(randf() * TAU) * randf_range(50.0, 200.0)
	# Checks the closest valid position it can wander to near that point
	nav.target_position = NavigationServer2D.map_get_closest_point(nav.get_navigation_map(), point)
