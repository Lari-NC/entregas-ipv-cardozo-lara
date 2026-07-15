extends Sprite2D

@onready var fire_position: Node2D = $FirePosition
@onready var fire_timer: Timer = $FireTimer

@export var projectile_scene: PackedScene

var projectile_container: Node
var target: Node2D

func _ready() -> void:
	fire_timer.connect("timeout", fire_at_player)

func initialize(turret_pos: Vector2, projectile_container: Node) -> void:
	global_position = turret_pos
	self.projectile_container = projectile_container

func fire_at_player() -> void:
	var proj_instance = projectile_scene.instantiate()
	proj_instance.initialize(
		projectile_container,
		fire_position.global_position,
		fire_position.global_position.direction_to(target.global_position)
	)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if target == null:
		target = body 
		fire_timer.start()

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		fire_timer.stop()
		
