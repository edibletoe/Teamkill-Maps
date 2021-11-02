extends Spatial
export (Globals.POWERUPS) var powerup_type
export var effect_length = 15
export var cooldown = 30
signal powerup_touched(touched_by)
var touched = false
var world
onready var timer = $Timer
func _ready():
	timer.wait_time = cooldown
	world = get_tree().get_nodes_in_group("main")[0]


func _on_CollArea_body_entered(body):
	if !NETWORK.is_server(): #if this isn't happening serverside, ignore it 
		return
	if touched: 
		return
	if body is Player:
		emit_signal("powerup_touched", body.player_owned_by_id)
		


func _on_Powerup_powerup_touched(touched_by): #TODO: FIX THIS, only works once for some reason
	if !NETWORK.is_server():
		return
	if world == null:
		push_error("POWERUP: Powerup doesn't know how to find world node, probably failed to initialized somehow")
		return
	#print("powerup touched")
	world.handle_powerup(self, touched_by, powerup_type, effect_length, cooldown)
	
	
remotesync func powerup_taken():
	if !get_tree().get_rpc_sender_id() <= 1:
		return
	$CollArea/CollisionShape.disabled = true
	self.hide()
	touched = true
	timer.start()
	
remotesync func powerup_ready():
	if !get_tree().get_rpc_sender_id() <= 1:
		return
	$CollArea/CollisionShape.disabled = false
	self.show()
	touched = false


func _on_Timer_timeout():
	if NETWORK.is_server():
		rpc("powerup_ready") #should probably put this in state manager at some point
