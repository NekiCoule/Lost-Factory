extends Sprite


# ---- VARIABLES ----

export (String) var weapon_name = "BaseWeapon"
export (float) var damage = 1.0
export (int) var bullet_speed = 400
export (float) var fire_rate = 1
export (String) var bullet_path = "res://Character/Weapons/Projectiles/Scenes/StandartBullet.tscn"

var left

var particle_rate : int

var bullet_scene
var bullet

var particle_array

var timer_node
var anim_node

var shoot_sound_node




var stats = {
	"name": weapon_name,
	"file_path": "Base_Script",
	"damage": damage,
	"bullet_speed": bullet_speed,
	"fire_rate": fire_rate,
}

var armed

# ---- READY ----

func _ready():
	
	# Set all variables
	
	armed = false	
	left = false
	
	shoot_sound_node = get_node("Shoot_Sound")
	
	# warning-ignore:narrowing_conversion
	particle_rate = round(1 / fire_rate)
	bullet_scene = load(bullet_path)
	
	timer_node = get_node("Rate")
	timer_node.wait_time = fire_rate
	
	particle_array = get_node("Particles").get_children()
	anim_node = get_node("Shoot_Animation")
	anim_node.set_speed_scale(particle_rate)
	set_particle_rates()
	
	armed = true
	
	


# ---- FUNCTIONS ----

# name: set_stats
# parameters : string, string
# description : set the dictionary stat

func set_stats(scene_path):
	stats.clear()
	stats = {
		"name": weapon_name,
		"scene_path": scene_path,
		"damage": damage,
		"bullet_speed": bullet_speed,
		"fire_rate": fire_rate,
	}


# name: update_stats
# parameters: dictionary
# description: update weapon stats with inventory dict stats

func update_stats(dict):
	damage = dict.get("damage")
	bullet_speed = dict.get("bullet_speed")
	fire_rate = dict.get("fire_rate")
	
	# warning-ignore:narrowing_conversion
	particle_rate = round(1 / fire_rate)
	timer_node.wait_time = fire_rate
	
	anim_node.set_speed_scale(particle_rate)
	set_particle_rates()


# name : set_left
# description : the weapon is in a left spot, set the bool to true and flip the weapon

func set_left():
	left = true
	flip_weapon()

# name : flip_weapon
# description : used to flip the weapon if it's on the left side

func flip_weapon():
	flip_h = true


# name : set_particle_rates
# description : for particle emitters to emit properly depending of fire rate

func set_particle_rates():
	for particle in particle_array:
		if particle.is_in_group("Solo_Particle"):
			particle.set_amount(particle_rate)


# name : shoot
# description : shoot a bullet

func shoot():
	bullet = bullet_scene.instance()
	get_node("/root").add_child(bullet)
	bullet.spawn(global_rotation_degrees - 90, get_node("Barrel_Point").global_position, bullet_speed, damage)
	
	shoot_sound_node.play()
	
	anim_node.play("shoot_anim")
	emit_particles(true)
	

# name : emit_particles
# description : play all particles

func emit_particles(state):
	for particle in particle_array:
		if !particle.is_in_group("Solo_Particle"):
			particle.restart()
		if !state:
			particle.set_emitting(state)
			
# name : toggle_left
# description : toggle on or off the weapon if it's on the left side

func toggle_left():
	if left:
		armed = !armed
		emit_particles(false)

# name : toggle_right
# description : toggle on or off the weapon if it's on the right side

func toggle_right():
	if !left:
		armed = !armed
		emit_particles(false)


# name : unequip
# description : add the weapon to the inventory and remove it

func unequip():
	get_node("/root/WeaponDict").add_weapon(stats)
	queue_free()

# ---- INPUT ----

func get_input():
	if Input.is_action_pressed("primary_fire") && timer_node.time_left == 0:
		shoot()
		timer_node.start(fire_rate)
	if Input.is_action_just_released("primary_fire"):
		emit_particles(false)
		anim_node.stop()
		anim_node.seek(0.0, true)


# ---- PROCESS ----

func _process(_delta):
	if armed:
		
		get_input()
	
		# Make the weapon look at the mouse
		look_at(get_viewport().get_mouse_position())
		rotation = rotation + deg2rad(90)
	
