extends Position3D
class_name SpawnPoint
var occupied = false

func _on_Area_body_entered(body):
	if body is Player:
		occupied = true


func _on_Area_body_exited(body):
	if body is Player:
		occupied = false
