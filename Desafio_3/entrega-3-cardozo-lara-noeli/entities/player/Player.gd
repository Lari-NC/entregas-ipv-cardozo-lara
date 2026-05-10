extends CharacterBody2D
class_name Player

@onready var cannon: Node = $Cannon

@export var ACCELERATION: float = 20.0
@export var H_SPEED_LIMIT: float = 600.0
@export var FRICTION_WEIGHT: float = 0.1
@export var JUMP_SPEED: float = -500
@export var GRAVITY: float = 10

var projectile_container: Node

func initialize(projectile_container: Node) -> void:
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container
	
func _get_input():
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED

func _physics_process(delta: float) -> void:
	_get_input()
	
	velocity.y += GRAVITY
	
	# Cannon rotation
	var mouse_position: Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)
	
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()
	
	# Player movement
	var h_movement_direction: int = int(
		Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")
	)
	
	if h_movement_direction != 0:
		velocity.x = clamp(
			velocity.x + (h_movement_direction * ACCELERATION),
			-H_SPEED_LIMIT,
			H_SPEED_LIMIT
		)
	else:
		# Ternary if: {true code} if {condition} else {false code}
		velocity.x = lerp(velocity.x, 0.0, FRICTION_WEIGHT) if abs(velocity.x) > 1.0 else 0.0
	
	move_and_slide()
	
	# Aplicar impulso a RigidBody2D colisionados
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			var impulse_direction = collision.get_normal() * -1
			var impulse_strength = 200.0
			collider.apply_central_impulse(impulse_direction * impulse_strength)
