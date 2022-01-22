extends Spatial
signal teleported
signal tele_queue_updated
signal tele_ready
onready var coll_area = $Area
onready var cooldown_timer = $Cooldown
onready var tp_dest = $Destination
export var cooldown = 1.0
var can_tp = true
var tele_queue = []
var teleporting = false

