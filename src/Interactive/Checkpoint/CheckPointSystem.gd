extends Spatial

export var death_area: NodePath
export var player: NodePath

var _active_checkpoint: Checkpoint
var _player_node: Player
var _death_area_node: Area

func _ready() -> void:
	_player_node = get_node(player)
	_death_area_node = get_node(death_area)
	
	_death_area_node.connect("body_entered", self, "respawn_player")
	
	for child in get_children():
		if child is Checkpoint:
			child.connect("activated_checkpoint", self, "_on_activated_checkpoint")

func respawn_player(body: Node) -> void:
	if body is Player:
		if _active_checkpoint != null:
			_player_node.global_transform.origin = _active_checkpoint.global_respawn_coord
			_player_node.global_transform.basis = _active_checkpoint.respawn_point.global_transform.basis
		else:
			_player_node.global_transform.origin = Vector3.ZERO

func _on_activated_checkpoint(checkpoint: Checkpoint) -> void:
	_active_checkpoint = checkpoint
