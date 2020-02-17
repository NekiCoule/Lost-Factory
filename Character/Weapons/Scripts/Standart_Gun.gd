extends "res://Character/Weapons/Scripts/WeaponBase.gd"



var smoke_path = "res://Particles/Scenes/Smoke_Shot.tscn"
var smoke_scene = load(smoke_path)
var smoke_node


func _ready():
	set_stats(name, filename)
	print(stats.get("scene_path"))


# Override flip_weapon function
func flip_weapon():
	flip_h = true
	offset.x = offset.x * - 1
	for node in get_children():
		if node is Sprite || node is Position2D:
			node.position.x = node.position.x * -1
	for particle in particle_array:
		particle.scale.x = particle.scale.x * -1
		particle.position.x = particle.position.x * -1
