extends Sprite

export (float) var damage = 1.0
export (int) var bullet_speed = 400
export (float) var fire_rate = 1
export (String) var bullet_path = "res://Character/Weapons/Projectiles/Scenes/StandartBullet.tscn"

var anim_rate

var bullet_scene
var bullet

var particle_array

var timer_node
var anim_node

func _ready():
	anim_rate = 1 / fire_rate
	bullet_scene = load(bullet_path)
	timer_node = get_node("Rate")
	timer_node.wait_time = fire_rate
	particle_array = get_node("Particles").get_children()
	anim_node = get_node("Shoot_Animation")
	anim_node.set_speed_scale(anim_rate)
	print(anim_node.get_speed_scale())
	set_particle_rates()
	
	
func flip_weapon():
	flip_h = true
#	get_node("Barrel").position.x = get_node("Barrel").position.x * -1

func set_particle_rates():
	for particle in particle_array:
		if particle.is_in_group("Solo_Particle"):
			particle.set_amount(anim_rate)

func shoot():
	bullet = bullet_scene.instance()
	get_node("/root").add_child(bullet)
	bullet.spawn(global_rotation_degrees - 90, get_node("Barrel").global_position, bullet_speed, damage)
	emit_particles(true)
	anim_node.play("shoot_anim")
	
	
func emit_particles(state):
	for particle in particle_array:
		if !particle.is_in_group("Solo_Particle"):
			particle.restart()
		particle.set_emitting(state)

func get_input():
	if Input.is_action_pressed("primary_fire") && timer_node.time_left == 0:
		shoot()
		timer_node.start(fire_rate)
	if Input.is_action_just_released("primary_fire"):
		emit_particles(false)
		anim_node.stop(true)
		
func _process(delta):
	get_input()
	
