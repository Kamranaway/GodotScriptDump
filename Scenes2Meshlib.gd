@tool
extends EditorScript

@export var path = "res://lowpolykitdungeon/lowpolykitdungeon/fbx/"
@export var file_type = "FBX"
@export var lib_name = "scifi_kit_alpha"
@export var write_path = "res://assets/"

var meshes = []

func _run():
	var meshlib = MeshLibrary.new()
	var tilemap = TileMap.new()
	
	var files = []
	var dir = DirAccess.open(path)
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
		loaded_scene = loaded_scene.instantiate()
		meshlib.create_item(index)
		meshlib.set_item_name(index, file.get_basename())
		
		for child in get_all_nodes(loaded_scene):
			if child is MeshInstance3D:
				
				#Generate collision
				child.create_trimesh_collision()
				
				#var new_form = child.transform.scaled(Vector3(0.01, 0.01, 0.01))
				#new_form = new_form.translated(Vector3(0, -.005, 0))
				#meshlib.set_item_mesh_transform(index, new_form)
				
				meshlib.set_item_mesh(index, child.mesh)
				meshes.append(child.mesh)
				var collision = null

				for child_j in get_all_nodes(loaded_scene):
					if child_j is CollisionShape3D:
						collision = child_j
						break
				
				meshlib.set_item_shapes(index, [collision.get_shape()])
		loaded_scene.free()
		index += 1
		
	var texes = get_editor_interface().make_mesh_previews(meshes, 100)
	var i = 0
	for tex in texes:
		meshlib.set_item_preview(i, tex)
		i += 1
	print("Loaded: ", str(index+1), " scenes")
	ResourceSaver.save(meshlib, "res://" + lib_name + ".meshlib")
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
