extends Area
class_name Checkpoint

signal activated_checkpoint()

onready var audio_player = $Audio
onready var respawn_point: Position3D = $RespawnPoint
onready var global_respawn_coord: Vector3 = respawn_point.global_transform.origin


func _on_CheckPoint_body_entered(body: Node) -> void:
	if body is Player:
		audio_player.play()
		emit_signal("activated_checkpoint", self)
