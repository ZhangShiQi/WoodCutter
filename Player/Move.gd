# 定义move state
# 
extends State

export var max_speed_default := Vector2(150.0, 500.0)
export var acceleration_default := Vector2(500.0, 500.0)
export var walk_speed_scale := 0.5
export var jump_impulse := 180.0


var is_walking = false

var acceleration := acceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO

var snap_distance = 320
var snap_vector = Vector2(0, snap_distance)


func enter(_msg:Dictionary = {}) -> void:
	pass
	
	
func physics_process(delta) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, get_move_direction())
	velocity = owner.move_and_slide_with_snap(velocity, snap_vector, owner.FLOOR_NORMAL)
	
	if velocity.x > 0.1:
		owner.skin.scale.x = 1
	elif velocity.x < -0.1:
		owner.skin.scale.x = -1
		
	print(velocity)
	
func unhandled_input(event: InputEvent) -> void:
	if event.is_action("player_walk"):
		is_walking = true
	else:
		is_walking = false
		
#	if event.is_action_released("player_walk"):
#		is_walking = false
	
	if owner.is_on_floor():
		if event.is_action_pressed("player_jump"):
			_state_machine.transition_to("Move/Air", {is_jumping = true, impulse = jump_impulse})
	

static func calculate_velocity(
		_old_velocity: Vector2,
		_max_speed: Vector2,
		_acceleration: Vector2,
		_delta: float,
		_move_dir: Vector2
	) -> Vector2:
	
	var new_velocity := _old_velocity
	
	new_velocity += _move_dir * _acceleration * _delta
	new_velocity.x = clamp(new_velocity.x, -_max_speed.x, _max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -_max_speed.y, _max_speed.y)
	
	return new_velocity
	

static func get_move_direction():
	return Vector2(
		Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left"),
		1.0
	)
