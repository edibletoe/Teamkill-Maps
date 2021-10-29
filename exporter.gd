extends Node
tool
signal export_done
signal export_failed
export (String) var file_name
export (String, DIR, GLOBAL) var texture_path
export (bool) var create_file
var file_formats = ["png","bmp","jpg", "import", "tres"] #add more if you need em
var generating = false
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if create_file and !generating:
		generating = true
		generate_texture_pck(file_name, texture_path)
		



func generate_texture_pck(file_name:String, target_dir=texture_path):
	print("Generating texture pack")
	var packer = PCKPacker.new()
	var files = []
	if !".pck" in file_name:
		file_name+=".pck"
	packer.pck_start("exports/"+file_name)
	files = search_dir(target_dir)
	if files == []:
		print("Couldn't find any files, for some reason?")
		emit_signal("export_failed")
		return
	var pck_target = "res://"+target_dir.right(target_dir.find("textures"))
	var output = []
	
	for i in files:
		if target_dir in i:
			print(i)
			print(i.get_file())
			if ".import" in i.get_file():
				var importfiles = locate_import(i.get_file().replace(".import",""))
				print("import file search: ", importfiles)
				for f in importfiles:
					var dest = "res://.import/"+f
					print("adding import file: ", dest)
					packer.add_file(dest, dest)
					output.append(dest)
			var dest = pck_target+"/"+i.get_file()
			print(dest)
			packer.add_file(dest, i)
			output.append(dest)
			print("adding to pck")
			print("dest: ",dest, " source file: ", i)
	packer.flush(true)
	print("outputted to: ", output)
	emit_signal("export_done")
	return
	
func search_dir(path):
	print("Searching for files in path: ", path)
	var dir = Directory.new()
	var files = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		#print(file_name)
		while file_name != "":
			if dir.current_is_dir():
				if file_name == "." or file_name == "..":
					pass
				else:
					print("opening subdir")
					files.append_array(search_dir(dir.get_current_dir().plus_file(file_name)))
			else:
				if file_name.get_extension() in file_formats:
					#print("Found file " + file_name)
					files.append(dir.get_current_dir().plus_file(file_name))
			file_name = dir.get_next()
	else:
		print("Couldn't open directory, doesn't exist")
		push_error("Couldn't open directory, doesn't exist")
		emit_signal("export_failed")
		return
	return files

func locate_import(search_file): #for finding file in .import/ that matches cur file
	var dir = Directory.new()
	var files = []
	print(search_file)
	if dir.open("res://.import") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			#print(file_name)
			if search_file in file_name:
				files.append(file_name)
			file_name = dir.get_next()
	else:
		return
	return files


func _on_exporter_export_done():
	print("Export success!")
	create_file = false


func _on_exporter_export_failed():
	print("Export failed!!")
	create_file = false
