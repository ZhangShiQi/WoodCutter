extends State

var is_jumping:bool = false
var acceleration_x_scale:float = 1.0

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	is_jumping = false
	
	_parent.snap_vector.y = 0
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
		_state_machine.transition_to("Move/Idle")
	
func exit() -> void:
	if is_jumping:
		owner.skin.disconnect("animation_finished", self, "_on_anim_finished")
	
	_parent.acceleration = _parent.acceleration_default
	_parent.snap_vector.y = _parent.snap_distance
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

