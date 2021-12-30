tool
extends KinematicBody
class_name Player
# Helper class for the Player scene's scripts to be able to have access to the
# camera and its orientation.

onready var camera: CameraRig = $CameraRig
onready var state_machine: StateMachine = $StateMachine

export(PackedScene) var tentacle_scene

func _ready() -> void:
	camera.connect("fired", self, "_on_camera_fired")


func _on_camera_fired(global_position: Vector3) -> void:
	get_tree().call_group("Tentacle", "delete")
	
	var new_tentacle: KinematicBody = tentacle_scene.instance()
	get_parent().add_child(new_tentacle)
	new_tentacle.global_transform.origin = global_position


func _get_configuration_warning() -> String:
	return "Missing camera node" if not camera else ""
