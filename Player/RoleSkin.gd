class_name RoleSkin extends Position2D


# 动画播放完成信号.
signal animation_finished(name)

onready var anim: AnimatedSprite = $AnimatedSprite
onready var floor_detector: FloorDetector = $FloorDetector
onready var shadow: Sprite  = $Shadow


export var show_shadow: bool = true
export var shadow_origin_scale: float = 0.1


func play(name:String) -> void:
	anim.play(name, false)


func _on_AnimatedSprite_animation_finished():
	emit_signal("animation_finished", name)


func _calc_shadow_transform():
	# 根据距离影响阴影的大小和显示
	floor_detector.force_raycast_update()
	shadow.visible = floor_detector.is_close_to_floor()
	var ratio := floor_detector.get_floor_distance_ratio()
	shadow.scale = Vector2(ratio, ratio) * shadow_origin_scale
	shadow.global_position = floor_detector.get_floor_position()


func _physics_process(_delta):
	if show_shadow:
		_calc_shadow_transform()

