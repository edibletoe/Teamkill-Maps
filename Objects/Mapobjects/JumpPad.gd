extends Spatial
signal launched
signal launch_queue_updated
signal launch_ready

onready var coll_area = $Area
onready var launch_point = $LaunchPoint
onready var sound = $LaunchSound
onready var cooldown = $LaunchCooldown


export var use_rotation = true
export var launch_dir = Vector3.UP
export var launch_force = 50
export var launch_cooldown = 1.0
var launch_vec = Vector3()
var can_launch = true
var launch_queue = []
var launching = false
