extends Area
class_name RespawnArea
var world

func _ready():
	connect("body_entered", self, "_on_RespawnArea_body_entered")
	world = get_tree().get_nodes_in_group("main")[0]


func _on_RespawnArea_body_entered(body):
	if NETWORK.is_server():
		if body is Player:
			world.respawn_player(body.player_owned_by_id)

