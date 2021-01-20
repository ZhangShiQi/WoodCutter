extends State

var last_is_walking := false

func play_anim():
	if last_is_walking:
		_parent.max_speed.x = _parent.max_speed_default.x * _parent.walk_speed_scale
		owner.skin.play("walk")
	else:
		_parent.max_speed.x = _parent.max_speed_default.x
		owner.skin.play("run")

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	last_is_walking = _parent.is_walking
	play_anim()
	
func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if _parent.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
		
	if _parent.is_walking != last_is_walking:
		last_is_walking = _parent.is_walking
		play_anim()
		
	_parent.physics_process(delta)

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	
