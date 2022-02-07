extends Spatial

var look_target:Player

func _process(delta):
	if look_target != null:
		look_at(look_target.global_transform.origin, Vector3.UP)

func _on_Area_body_entered(body):
	if body is Player:
		look_target = body

func _on_Area_body_exited(body):
	look_target = null
