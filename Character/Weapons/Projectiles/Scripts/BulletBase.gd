extends KinematicBody2D

var speed : int = 400
var damage : float = 1.0

var direction
var velocity

func _ready():
	pass


func spawn(parent_rotation, parent_position, _speed, _damage):
	rotation_degrees = parent_rotation
	position = parent_position
	speed = _speed
	damage = _damage
	velocity = Vector2(1, 0).rotated(rotation) * speed

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	

