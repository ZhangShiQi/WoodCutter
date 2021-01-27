extends State

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	owner.skin.connect("animation_finished", self, "_anim_finished")
	owner.skin.play("hurt")

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_anim_finished")
	_parent.exit()
	
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)

func physics_process(delta) -> void:
	_parent.physics_process(delta)
		

func _anim_finished(name):
	_state_machine.transition_to("Move/Idle")

