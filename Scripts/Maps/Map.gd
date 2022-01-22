#tool
extends Spatial
class_name MapScene

onready var spawn_points = $SpawnPoints
onready var map_cameras = $Cameras
onready var environment = $Environment

var world_environment:WorldEnvironment

#music, this will likely be expanded on with more modes and/or when more tracks are in the game lol
export (Array, String) var available_music_tracks = [] #if empty, server picks random track. If filled in, server picks random track only from in this list. One track means that track always plays lol
export (String) var custom_hide_and_seek_music_track = "" #if a specific track for Hide & Seek mode

#DYNAMIC COLOR STUFF
export (bool) var use_dynamic_surfaces = false
export (bool) var use_dynamic_sky = false
export (bool) var match_dynamic_sky_to_surface = false
export (Dictionary) var dynamic_surfaces = {"Ground":0,"Walls":1}
export (NodePath) var map_mesh
export var ground_color = Color()
export var wall_color = Color()
export var sky_color = Color()


func _ready():	
	if !map_mesh is Mesh: #disable dynamic surface stuff if invalid mesh given
		map_mesh = null
		use_dynamic_surfaces = false
		match_dynamic_sky_to_surface = false
		
	if self.has_node("WorldEnvironment"):
		world_environment = get_node("WorldEnvironment")

func _physics_process(delta):
	#ONLY RELEVANT IF TOOL IS ENABLED
	if Engine.is_editor_hint():
		if use_dynamic_surfaces:
			set_dynamic_texture_colors()
			if use_dynamic_sky and match_dynamic_sky_to_surface:
				set_sky_colors()

func set_dynamic_texture_colors():
	#todo: make a separate "wall surfaces" array and iterate through all of them
	var mesh:MeshInstance
	var mat:SpatialMaterial
	mat = mesh.get_active_material(dynamic_surfaces["Ground"]) #this is dirty do not keep this
	mat.emission = ground_color
	mat.next_pass.emission = ground_color
	mat = mesh.get_active_material(dynamic_surfaces["Walls"])
	mat.emission = wall_color

	
func set_sky_colors():
	if world_environment != null and world_environment.environment.background_sky != null:
		var sky = world_environment.environment.background_sky
		#horizon
		sky.sky_top_color = sky_color
		sky.sky_horizon_color = wall_color
		sky.ground_horizon_color = ground_color	

