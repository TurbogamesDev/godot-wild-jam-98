extends CharacterBody2D

@export var speed = 120
@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	_animated_sprite.play("front")

func _physics_process(_delta: float) -> void:
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
