extends CharacterBody2D
class_name Player

@export var speed = 120
@onready var _animated_sprite = $AnimatedSprite2D

signal signal_changed(has_signal: bool)

var signal_zones := 0
var map_open := false
var has_signal := false
## Signal related functions

func enter_signal_zone() -> void:
	signal_zones += 1
	_update_signal()

func exit_signal_zone() -> void:
	signal_zones -= 1
	_update_signal()

func _update_signal() -> void:
	var new_state := signal_zones > 0
	if new_state != has_signal:
		has_signal = new_state
		signal_changed.emit(has_signal)

## Movement and sprite related functions
func _ready():
	_animated_sprite.play("front")

func _physics_process(_delta: float) -> void:
	#Disables player movement while map is open
	if map_open:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	#Player movement
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()
	update_animation(input_direction)

func update_animation(direction: Vector2) -> void:
	if direction:
		if abs(direction.x) > abs(direction.y):
			_animated_sprite.play("side")
			_animated_sprite.flip_h = direction.x < 0
		elif direction.y > 0:
			_animated_sprite.play("front")
		else:
			_animated_sprite.play("back")
