extends Sprite

export (float) var damage = 1.0
export (int) var bullet_speed = 400
export (float) var fire_rate = 1
export (String) var bullet_path = "res://Character/Weapons/Projectiles/Scenes/StandartBullet.tscn"

var bullet_scene
var bullet

var particle_array

var timer_node

func _ready():
	bullet_scene = load(bullet_path)
	timer_node = get_node("Rate")
	timer_node.wait_time = fire_rate
	particle_array = get_node("Particles").get_children()
	
	
func flip_weapon():
	flip_h = true
#	get_node("Barrel").position.x = get_node("Barrel").position.x * -1


func shoot():
	bullet = bullet_scene.instance()
	get_node("/root").add_child(bullet)
	bullet.spawn(global_rotation_degrees - 90, get_node("Barrel").global_position, bullet_speed, damage)
	for particle in particle_array:
		particle.restart()
		particle.set_emitting(true)
		print(particle.is_emitting())

func get_input():
	if Input.is_action_pressed("primary_fire"):
		shoot()
		
func _process(delta):
	if Input.is_action_pressed("primary_fire") && timer_node.time_left == 0:
		shoot()
		timer_node.start(fire_rate)
