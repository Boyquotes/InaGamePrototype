extends KinematicBody
class_name Follower

export var target_path: NodePath

onready var state_machine: StateMachine = $StateMachine
onready var test: MeshInstance = $Test
onready var animation_player = $AnimationPlayer

var target_node: Spatial

func _ready() -> void:
	animation_player.play("Idle")
	target_node = get_node(target_path)
	test.set_as_toplevel(true)
