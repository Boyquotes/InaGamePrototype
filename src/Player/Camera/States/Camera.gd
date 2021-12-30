extends CameraState

export var is_y_inverted := false
export var is_x_inverted := false
export var fov_default := 70.0
export var deadzone_backward := 0.3

export var default_sensitivity_gamepad := Vector2(2.5, 2.5)
export var default_sensitivity_mouse := Vector2(1.5, 1.5)

var sensitivity_gamepad := Vector2(2.5, 2.5)
var sensitivity_mouse := Vector2(0.1, 0.1)

var _input_relative := Vector2.ZERO
var _is_aiming := false


func _ready() -> void:
	ConfigManager.connect("changed_setting", self, "_on_changed_setting")
	ConfigManager.connect("restored_settings", self, "load_from_settings")
	load_from_settings()


func load_from_settings() -> void:
	is_y_inverted = ConfigManager.get_setting("controls", "inverted")
	is_x_inverted = ConfigManager.get_setting("controls", "inverted")

	var float_controller_sens = ConfigManager.get_setting("controls", "controller_sensitivity")
	var float_mouse_sens = ConfigManager.get_setting("controls", "mouse_sensitivity")
	
	default_sensitivity_gamepad = Vector2(float_controller_sens, float_controller_sens)
	default_sensitivity_mouse = Vector2(float_mouse_sens, float_mouse_sens)

	sensitivity_gamepad = default_sensitivity_gamepad
	sensitivity_mouse = default_sensitivity_mouse


func _on_changed_setting(category: String, key: String, new_val) -> void:
	if category == "controls":
		match key:
			"inverted":
				is_y_inverted = new_val
				is_x_inverted = new_val
			"hold_for_aim":
				pass
			"mouse_sensitivity":
				default_sensitivity_mouse = Vector2(new_val, new_val)
				sensitivity_mouse = default_sensitivity_mouse
			"controller_sensitivity":
				default_sensitivity_gamepad = Vector2(new_val, new_val)
				sensitivity_gamepad = default_sensitivity_gamepad


func process(delta: float) -> void:
	camera_rig.global_transform.origin = (
		camera_rig.player.global_transform.origin
		+ camera_rig._position_start
	)

	var move_direction := get_move_direction()
	var look_direction := get_look_direction()

	# Mouse
	if _input_relative.length() > 0.0:
		update_rotation(_input_relative / 2500.0 * sensitivity_mouse)
		_input_relative = Vector2.ZERO

	# Gamepad
	if look_direction.length() > 0.0:
		update_rotation(look_direction * sensitivity_gamepad * delta)

	var is_moving_towards_camera: bool = (
		move_direction.x >= -deadzone_backward
		and move_direction.x <= deadzone_backward
	)
	if not is_moving_towards_camera and not _is_aiming:
		auto_rotate(move_direction, delta)

	camera_rig.rotation.y = wrapf(camera_rig.rotation.y, -PI, PI)


func unhandled_input(event: InputEvent) -> void:
	if event.get_action_strength("reset_camera"):
		camera_rig.rotation.y = camera_rig.player.rotation.y

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_input_relative += event.get_relative()

	if event.get_action_strength("zoom_in") or event.get_action_strength("zoom_out"):
		camera_rig.zoom += 0.1 if event.get_action_strength("zoom_in") else -0.1


func auto_rotate(_move_direction: Vector3, delta: float) -> void:
	var offset: float = camera_rig.player.rotation.y - camera_rig.rotation.y
	var target_angle: float = (
		camera_rig.player.rotation.y - 2 * PI
		if offset > PI
		else camera_rig.player.rotation.y + 2 * PI if offset < -PI else camera_rig.player.rotation.y
	)
	camera_rig.rotation.y = lerp(camera_rig.rotation.y, target_angle, 0.9 * delta)


func update_rotation(offset: Vector2) -> void:
	camera_rig.rotation.y -= offset.x
	camera_rig.rotation.x += offset.y * -1.0 if not is_y_inverted else offset.y
	camera_rig.rotation.y += offset.x * -1.0 if not is_x_inverted else offset.x
	camera_rig.rotation.x = clamp(camera_rig.rotation.x, -0.75, 1.25)
	camera_rig.rotation.z = 0


static func get_look_direction() -> Vector2:
	return Input.get_vector("look_left", "look_right", "look_up", "look_down", 0.25)


static func get_move_direction() -> Vector3:
	var input_direction = Input.get_vector("move_left", "move_right", "move_front", "move_back")
	return Vector3(input_direction.x, 0.0, input_direction.y)
