tool
extends Spatial
#class_name MapScene

signal map_loaded
signal map_failed
var previous_load_vars = []
var is_loaded = false
var map_path

onready var spawn_points = $SpawnPoints
onready var map_cameras = $Cameras
onready var environment = $Environment

var world_environment:WorldEnvironment
export (bool) var qodot_map = false
export (bool) var has_custom_spawns = false
export (bool) var use_customs_and_imports = false
export (bool) var use_dynamic_surfaces = false
export (bool) var use_dynamic_sky = false
export (bool) var match_dynamic_sky_to_surface = false
export var ground_color = Color()
export var wall_color = Color()
export var sky_color = Color()
export (Dictionary) var dynamic_surfaces = {"Ground":0,"Walls":1}

func _ready():
	if qodot_map:
		environment.connect("build_complete", self, "on_build_complete")
		environment.connect("build_failed", self, "on_build_failed")
	if self.has_node("WorldEnvironment"):
		world_environment = get_node("WorldEnvironment")


func _physics_process(delta):
	if Engine.is_editor_hint():
		if use_dynamic_surfaces:
			set_dynamic_grid_colors()
			if use_dynamic_sky and match_dynamic_sky_to_surface:
				set_sky_colors()

func set_dynamic_grid_colors():
	#todo: make a separate "wall surfaces" array and iterate through all of them
	var mesh:MeshInstance
	var mat:SpatialMaterial
	if qodot_map:
		mesh = environment.get_node("entity_0_worldspawn/entity_0_mesh_instance")
	mat = mesh.get_active_material(dynamic_surfaces["Ground"]) #this is dirty do not keep this
	mat.emission = ground_color
	mat.next_pass.emission = ground_color
	mat = mesh.get_active_material(dynamic_surfaces["Walls"])
	mat.emission = wall_color
	#mat.next_pass.emission = ground_color
	
func set_sky_colors():
	if world_environment != null and world_environment.environment.background_sky != null:
		var sky = world_environment.environment.background_sky
		#horizon
		sky.sky_top_color = sky_color
		sky.sky_horizon_color = wall_color
		#sky.horizon_color = ground_color
		sky.ground_horizon_color = ground_color
	


