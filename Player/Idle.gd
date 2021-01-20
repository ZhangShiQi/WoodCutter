# Player Idle state.

extends State


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)

	if abs(_parent.get_move_direction().x) < 0.1:
		_parent.max_speed = _parent.max_speed_default
		_parent.velocity = Vector2.ZERO
		_parent.snap_vector.y = _parent.snap_distance
		owner.skin.play("idle")


func exit() -> void:
	_parent.exit()
	
	
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)

func physics_process(delta) -> void:
	var is_on_floor = owner.is_on_floor()

	if is_on_floor and _parent.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Run")
	elif not is_on_floor:
		_state_machine.transition_to("Move/Air")
	else:
		_parent.physics_process(delta)
		
