extends State

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	_parent.max_speed.x = msg.max_speed
	owner.skin.play("walk")
	
func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if _parent.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		pass
		
	_parent.physics_process(delta)
