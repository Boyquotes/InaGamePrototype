extends CameraState

const DOT_APPROX = 0.025

onready var tween: Tween = $Tween

export var fov: = 40.0
export var offset_camera: = Vector3(0.75, -0.7, 0.0)

export(float, 0.1, 1.0, 0.05) var aim_sensitivity_percent = 0.8

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_aim"):
		_state_machine.transition_to("Camera/Default")
	
	elif event.is_action_pressed("fire"):
		camera_rig.aim_ray.force_raycast_update()
		if camera_rig.aim_ray.is_colliding():
			if not camera_rig.aim_ray.get_collider().is_in_group("AntiTentacle"):
				var dot = camera_rig.aim_ray.get_collision_normal().dot(Vector3.UP)
				if 1.0 - DOT_APPROX < dot and dot < 1.0 + DOT_APPROX:
					camera_rig.emit_signal("fired", camera_rig.aim_ray.get_collision_point())
	
	_parent.unhandled_input(event)


func process(delta: float) -> void:
	_parent.process(delta)
	camera_rig.aim_target.update(camera_rig.aim_ray)


func enter(_msg: Dictionary = {}) -> void:
	_parent.sensitivity_gamepad = _parent.sensitivity_gamepad * aim_sensitivity_percent
	_parent.sensitivity_mouse = _parent.sensitivity_mouse * aim_sensitivity_percent
	
	_parent._is_aiming = true
	camera_rig.aim_target.visible = true
	
	camera_rig.spring_arm.translation = camera_rig._position_start + offset_camera
	
	tween.interpolate_property(camera_rig.camera, "fov", camera_rig.camera.fov, fov, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()


func exit() -> void:
	_parent.sensitivity_gamepad = _parent.default_sensitivity_gamepad
	_parent.sensitivity_mouse = _parent.default_sensitivity_mouse
	
	_parent._is_aiming = false
	camera_rig.aim_target.visible = false
	
	camera_rig.spring_arm.translation = camera_rig.spring_arm._position_start
	
	tween.interpolate_property(camera_rig.camera, "fov", camera_rig.camera.fov, _parent.fov_default, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
