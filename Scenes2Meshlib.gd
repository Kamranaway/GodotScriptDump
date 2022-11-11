extends Node

export(String) var path = ""
export(String) var file_type = "FBX"
export(String) var lib_name = ""

func _ready():
	var meshlib = MeshLibrary.new()
	
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	print("Getting directory...")
	while (true):
		var file = dir.get_next()
		if file == "":
			break
		elif file.get_extension() == file_type:
			files.append(file)
			
	var index = 0
	
	print("Finding scenes...")
	for file in files:
		var loaded_scene = load(path+file)
		loaded_scene = loaded_scene.instance()
		meshlib.create_item(index)
		meshlib.set_item_name(index, file.get_basename())
		for child in get_all_nodes(loaded_scene):
			if child is MeshInstance:
				meshlib.set_item_mesh(index, child.mesh)
				
		loaded_scene.free()
		index += 1
	print("Loaded: ", str(index+1), " scenes")
	ResourceSaver.save("res://" + lib_name + ".meshlib", meshlib)
	print("Saving Complete")

var nodes = []
func get_all_nodes(node):
	nodes.clear()
	for N in node.get_children():
		nodes.append(N)
		if N.get_child_count() > 0:
			get_all_nodes(N)
		else:
			pass
	return nodes
