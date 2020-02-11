extends "res://Character/Weapons/Scripts/WeaponBase.gd"



func _ready():
	pass 


func flip_weapon():
	flip_h = true
	offset.x = offset.x * - 1
	get_node("Barrel").position.x = get_node("Barrel").position.x * -1
	for particle in particle_array:
		particle.scale.x = particle.scale.x * -1
		particle.position.x = particle.position.x * -1
#		particle.rotation_degrees = particle.rotation_degrees + 180
