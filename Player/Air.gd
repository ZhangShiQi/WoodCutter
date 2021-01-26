extends State

var is_jumping:bool = false
var acceleration_x_scale:float = 1.0

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	is_jumping = false
	
	_parent.enable_gravity = false
	_parent.acceleration.x *= acceleration_x_scale
	
	if "is_jumping" in msg:
		is_jumping = msg.is_jumping
	
	if "impulse" in msg:
		_parent.velocity += calculate_jump_velocity(msg.impulse)
	
	if is_jumping:
		owner.skin.play("jump")
		owner.skin.connect("animation_finished", self, "_on_anim_finished")
	else:
		owner.skin.play("air")

func physics_process(_delta):
	_parent.physics_process(_delta)

	if owner.is_on_floor():		
		if _parent.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
		else:
			_state_machine.transition_to("Move/Run")
		
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	
func exit() -> void:
	if is_jumping:
		owner.skin.disconnect("animation_finished", self, "_on_anim_finished")
	
	_parent.acceleration = _parent.acceleration_default
	_parent.enable_gravity = true
	_parent.exit()

func _on_anim_finished(_name:String):
	# jumping动画播放完后, 播放air动画. 
	if is_jumping:
		owner.skin.play("air")
		
		is_jumping = false
		owner.skin.disconnect("animation_finished", self, "_on_anim_finished")
		
		
	
func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return _parent.calculate_velocity(
			_parent.velocity,
			_parent.max_speed,
			Vector2(0, impulse),
			1.0,
			Vector2.UP
		)

