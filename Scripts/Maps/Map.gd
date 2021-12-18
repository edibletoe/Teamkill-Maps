#tool
extends Spatial
class_name MapScene

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
var spawnpoint = preload("res://Objects/Mapobjects/Spawnpoint.tscn")
var spawns = []
var max_retries = 69
var cur_retries = 0



func _ready():
	if qodot_map:
		environment.connect("build_complete", self, "on_build_complete")
		environment.connect("build_failed", self, "on_build_failed")
	if self.has_node("WorldEnvironment"):
		world_environment = get_node("WorldEnvironment")

func map_init():
	yield(get_spawnpoints(), "completed")
	if use_dynamic_surfaces:
		set_dynamic_grid_colors()
		if use_dynamic_sky and match_dynamic_sky_to_surface:
			set_sky_colors()
	if spawns == []:
		push_error("MAP: NO SPAWNS FOUND")
		if qodot_map:
			if cur_retries < max_retries:
				if previous_load_vars != []:
					cur_retries += 1
					print("Retrying map loading.. Attempt ", cur_retries, " of ", max_retries)
					reload_qodotmap(previous_load_vars)
					yield(get_tree(),"idle_frame")
					load_map_qodot(previous_load_vars[0],previous_load_vars[1],previous_load_vars[2],previous_load_vars[3])
					return
				else:
					if map_path != null:
						cur_retries +=1
						reload_qodotmap()
						yield(get_tree(),"idle_frame")
						load_map_qodot(map_path)
						return
					else:
						push_error("MAP: Retried, but received no map variables, WTF??")
						emit_signal("map_failed")
						
			else:
				print("MAP: Map failed to load after ", max_retries, " tries.")
				emit_signal("map_failed")
		else:
			emit_signal("map_failed")
	else:
		emit_signal("map_loaded")

func reload_qodotmap(prev_vars=[]):
	print("Reloading/respawning QodotMap..")
	environment.queue_free()
	yield(get_tree(),"idle_frame")
	environment = null
	var env_inst = QodotMap.new()
	add_child(env_inst)
	env_inst.name = "Environment"
	environment = env_inst
	environment.connect("build_complete", self, "on_build_complete")
	environment.connect("build_failed", self, "on_build_failed")
	if prev_vars != []:
		yield(get_tree(),"idle_frame")
		set_qodotmap_vars(previous_load_vars[0],previous_load_vars[1],previous_load_vars[2],previous_load_vars[3])
	return

func _physics_process(delta):
	if Engine.is_editor_hint():
		if use_dynamic_surfaces:
			set_dynamic_grid_colors()
			if use_dynamic_sky and match_dynamic_sky_to_surface:
				set_sky_colors()

func load_map_tscn(): #lol
	map_init()
	#emit_signal("map_loaded")

func load_map_qodot(_map_path, texture_path_dir=MapFinder.texture_dir, texture_file_ext=["png","bmp"], texture_wads=[]):
	print("Loading Qodot .map file: ", _map_path)
	if MapFinder.check_valid_map_path(_map_path):
		map_path = _map_path
	else:
		push_error(str("MAP SCRIPT: MAP PATH IS INVALID: ", _map_path))
		return
	set_qodotmap_vars(map_path, texture_path_dir, texture_file_ext, texture_wads)
	yield(get_tree(),"idle_frame")
	previous_load_vars = [map_path, texture_path_dir, texture_file_ext, texture_wads]
	environment.verify_and_build()
	

	
func set_qodotmap_vars(_map_path, texture_path_dir, texture_file_ext, texture_wads=[]):
	print("Setting Qodot Map variables ", _map_path, texture_path_dir, texture_file_ext, texture_wads)
	environment.set_map_file(_map_path)
	environment.set_texture_wads(texture_wads)
	environment.base_texture_dir = texture_path_dir
	#print(texture_path_dir)
	environment.texture_file_extensions = PoolStringArray(texture_file_ext)
	environment.use_trenchbroom_group_hierarchy = false
	#environment.should_add_children = true
	#environment.set_qodot_entity_definitions()
	#environment.should_set_owners = true

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
	
func get_spawnpoints():
	print("Checking spawns")
	yield(get_tree(),"idle_frame")
	if !qodot_map or has_custom_spawns:
		for i in spawn_points.get_children():
			if !i is SpawnPoint:
				var new_i = create_spawn(i.global_transform.origin, i.rotation_degrees)
				spawns.append(new_i)
				i.queue_free()
			else:
				spawns.append(i)
		if !use_customs_and_imports:
			return
	#TODO: delete these
	if qodot_map or use_customs_and_imports:
		#print("grabbing spawnpoints from Qodot info")
		if environment.has_node("Spawns"):
			for i in environment.get_node("Spawns").get_children():
				if i.name.find("info_player_deathmatch") != -1:
					spawns.append(create_spawn(i.global_transform.origin, i.rotation_degrees))
				elif i.name.find("info_player_start") != -1:
					spawns.append(create_spawn(i.global_transform.origin, i.rotation_degrees))
				elif i.name.ends_with("Player"):
					spawns.append(create_spawn(i.global_transform.origin, i.rotation_degrees))
					
		else:
			for i in environment.get_children():
				#print(i)
				if i.name.find("info_player_deathmatch") != -1:
					spawns.append(create_spawn(i.global_transform.origin, i.rotation_degrees))
				elif i.name.find("info_player_start") != -1:
					spawns.append(create_spawn(i.global_transform.origin, i.rotation_degrees))
				elif i is Position3D:
					spawns.append(create_spawn(i.global_transform.origin, i.rotation_degrees))
				elif i is SpawnPoint:
					spawns.append(i)
				elif i.name.ends_with("Player"):
					spawns.append(create_spawn(i.global_transform.origin, i.rotation_degrees))
	print("...Done")
	return
	
func create_spawn(spawnpos, spawnrot=Vector3.ZERO):
	print("Creating spawn")
	var spawn_inst:SpawnPoint = spawnpoint.instance()
	spawn_points.add_child(spawn_inst)
	spawn_inst.global_transform.origin = spawnpos
	if spawnrot != Vector3.ZERO:
		#print("rot not zero")
		spawn_inst.rotation_degrees = spawnrot
	return spawn_inst
	
	
func on_build_complete():
	#yield(get_tree().create_timer(2), "timeout")
	#print("MAP: Waiting 2 seconds before starting init, this is a test to see if 'build complete' triggers before the nodes are actually present..")
	map_init()

func on_build_failed():
	emit_signal("map_failed")



func _on_Map_map_loaded():
	is_loaded = true
