extends PlayerState

@export var jumps_limit: int = 1
var jumps: int = 0

# Al entrar se activa primero la animación "jump"
func enter() -> void:
	#character.snap_vector = Vector2.ZERO
	character.velocity.y -= character.jump_speed
	character._play_animation(&"jump")

func exit() -> void:
	jumps = 0


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && jumps < jumps_limit:
		jumps += 1
		character.velocity.y -= character.jump_speed
		character._play_animation("jump")


# En esta función vamos a manejar las acciones apropiadas para este estado
func update(delta: float) -> void:
	character._handle_move_input(delta)
	character._apply_movement(delta)
	
	if character.h_movement_direction == 0:
		character._handle_deacceleration(delta)
	character._apply_movement(delta)
	
	if character.is_on_floor():
		if character.h_movement_direction == 0:
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "walk")
	else:
		if character.velocity.y > 0:
			character._play_animation(&"fall")
		else:
			character._play_animation(&"jump")


func _on_animation_finished(anim_name: StringName) -> void:
	return


# En este callback manejamos, por el momento, solo los impactos
func handle_event(event: StringName, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
			if character.dead:
				emit_signal("finished", "dead")
