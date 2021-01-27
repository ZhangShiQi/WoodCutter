extends State

var continue_attack = false
export var continue_attack_scale = 0.5

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	continue_attack = false

	owner.skin.connect("animation_finished", self, "_on_anim_finished")
	
	if _parent.velocity.x != 0.0:
		_parent.is_walking = true
		_parent.max_speed.x = _parent.max_speed_default.x * _parent.walk_speed_scale
		
		owner.skin.play("attack_3")
	else:
		if randi() % 2 == 0:
			owner.skin.play("attack_2")
		else:
			owner.skin.play("attack_1")

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_anim_finished")
	_parent.is_walking = false

	_parent.exit()
	
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	if event.is_action_pressed("player_attack"):
		if owner.skin.get_play_percent() >= continue_attack_scale:
			continue_attack = true

func physics_process(delta) -> void:
	_parent.physics_process(delta)
#	print(owner.skin.get_play_percent())
	
func _on_anim_finished(name):
	if continue_attack:
		_state_machine.transition_to("Move/Attack")
	else:
		_state_machine.transition_to("Move/Idle")
	
		

