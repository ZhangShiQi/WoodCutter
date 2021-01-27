extends State

onready var timer := $Timer

var is_jumping:bool = false
var acceleration_x_scale:float = 1.0

# 中断跳跃时间阀
export var break_jumping_duration = 1.5

# 中断跳跃时间 这个时间会不断的降低, 在到0之前, 只要你松开跳跃键, 就可以是向上的加速度削减
var break_jumping_timer = 0.0

# 中断跳跃系数, 中断时向上的加速度将会被乘以该值
var break_jumping_scale = 0.5


var continue_jump = false

func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	is_jumping = false
	continue_jump = false
	
	break_jumping_timer = 1.5
	
	_parent.enable_gravity = false
	_parent.acceleration.x *= acceleration_x_scale
	
	if "is_jumping" in msg:
		is_jumping = msg.is_jumping
#		timer.connect("timeout", self, _ch)
	
	if "impulse" in msg:
		_parent.velocity += calculate_jump_velocity(msg.impulse)
	
	if is_jumping:
		owner.skin.play("jump")
		owner.skin.connect("animation_finished", self, "_on_anim_finished")
	else:
		owner.skin.play("air")

func physics_process(_delta):
	_parent.physics_process(_delta)
	
	break_jumping_timer -= _delta

	if owner.is_on_floor():
		if continue_jump:
			_state_machine.transition_to("Move/Air", {is_jumping = true, impulse = _parent.jump_impulse})
		else:
			if _parent.get_move_direction().x == 0.0:
				_state_machine.transition_to("Move/Idle")
			else:
				_state_machine.transition_to("Move/Run")
		
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)

	if break_jumping_timer > 0:
		if event.is_action_released("player_jump"):
			_parent.velocity.y *= break_jumping_scale
	
	if event.is_action_pressed("player_jump"):
		continue_jump = true
		
	if event.is_action_pressed("player_attack"):
		pass
	
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

