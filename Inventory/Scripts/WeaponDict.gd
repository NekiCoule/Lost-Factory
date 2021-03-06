extends Node

var weapon_array
var starting_guns

func _ready():
	starting_guns = {
		"name": "Standart Gun",
		"scene_path": "res://Character/Weapons/Scenes/Standart_Gun.tscn",
		"damage": 1,
		"bullet_speed": 1200,
		"fire_rate": 0.15
	}
	weapon_array = [starting_guns, starting_guns]


# name: add_weapon
# parameters: (dict)
# returns: None
# description: Saves the weapon in the WeaponDict

func add_weapon(weapon_stats):
	var added = false
	for i in range(0,weapon_array.size()):
		if weapon_array[i] == null:
			weapon_array[i] = weapon_stats
			added = true
			print(weapon_array[i])
	
	if !added:
		weapon_array.append(weapon_stats)
		print(weapon_array[-1])

# name: check_index
# parameters: (int)
# returns: bool
# description: check if the index exists

func check_index(index):
	for i in weapon_array.size():
		if i == index:
			return true
		else:
			return false

# name: get_weapon
# parameters: (int)
# returns: dict
# description: return the weapon at index and remove it

func get_weapon(index):
	var weapon = weapon_array[index]
	weapon_array.remove(index)
	return weapon
