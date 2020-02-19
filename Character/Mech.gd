extends KinematicBody2D

# ---- VARIABLES -----

var speed = 50
var friction = 0.08
var acceleration = 0.08

var velocity = Vector2.ZERO
var direction = Vector2()

# nodes
var animation_node
var legs_node
var chassis_node
var weapons

# nodes name

var chassis_name
var legs_name

# ---- ONREADY -----

func _ready():
	chassis_name = ""
	legs_name = ""
	
	add_leg("res://Character/Legs/Scenes/StandartLegs.tscn")
	animation_node = get_node(legs_name + "/WalkAnimation")
	animation_node.play("Walk")
	animation_node.set_speed_scale(0)
	
#	chassis_node = get_node("Chassis")
#	chassis_name = chassis_node.name
	
#	weapons = get_node(chassis_node.name + "/Weapons")
	
	add_chassis("res://Character/Chassis/Scenes/StandartChassis.tscn")
	
	
#	get_node(chassis_name + "/Weapons/Left_Weapon").set_left()
	

# ----- FUNCTIONS -----

# function : add_legs
# parameters : (node path)
# returns : none
# description : Check if there is a leg and remove it, then add the new node as LegsBase to the mech

func add_leg(node_path):
	var new_legs = load(node_path).instance()
	
	if has_node(legs_name):
		get_node(legs_name).queue_free()
		
	add_child(new_legs)
	
	legs_name = new_legs.name
	legs_node = get_node(legs_name)
	
	speed = legs_node.speed
	friction = legs_node.friction
	acceleration = legs_node.acceleration
	
	
# function : add_chassis
# parameters : (node path)
# returns : none
# description : Check if there is a chassis and unequip any weapons attached, then remove it and add the new node as ChassisBase to the mechs

func add_chassis(node_path):
	var new_chassis = load(node_path).instance()
	
	if has_node(chassis_name):
		for weapon in weapons.get_children():
			weapon.unequip()
		
		get_node(chassis_name).queue_free()
		
	add_child(new_chassis)
	chassis_name = new_chassis.name
	chassis_node = get_node(chassis_name)
	
	var node_2d = load("res://Character/Weapons.tscn").instance()
	chassis_node.add_child(node_2d)
	print(node_2d.name)
	weapons = get_node(chassis_name + "/Weapons")


# function : equip
# parameters : (int, bool, position)
# returns : None
# description : attach the weapon from inventory

func equip_weapon(index, left, point_pos):
	var dict = get_node("/root/WeaponDict")
	if dict.check_index(index):
		var weapon = dict.get_weapon(index)
		var new_weapon = load(weapon.get("scene_path")).instance()
		weapons.add_child(new_weapon)
		
		if left:
			new_weapon.set_name("Left_Weapon")
			new_weapon.set_left()
		else:
			new_weapon.set_name("Right_Weapon")
		
	else:
		print("No weapon at index!")


# function : move
# parameters : None
# returns : None
# description : Movement handle called during the tick process

func move():
	
	# If there's input, accelerate to the input velocity
	if direction.length() > 0:
		velocity = velocity.linear_interpolate(direction, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	# Move the physic body
	velocity = move_and_slide(velocity)
	
	# Play anitmation depending of velocity
	animation_node.set_speed_scale((abs(velocity.x) + abs(velocity.y)) * 0.017)
	legs_node.rotation = velocity.angle() + deg2rad(90)


# function : toggle_weapons
# parameters : bool
# description : Check all weapons and toggle the left or right depending of the bool

func toggle_weapons(left):
	for weapon in weapons.get_children():
		if left:
			weapon.toggle_left()
		else:
			weapon.toggle_right()

# ----- INPUT -----

func get_input():
	direction = Vector2()
	if Input.is_action_pressed('ui_right'):
		direction.x += 0.5
		
	if Input.is_action_pressed('ui_left'):
		direction.x -= 0.5
		
	if Input.is_action_pressed('ui_down'):
		direction.y += 0.5
		
	if Input.is_action_pressed('ui_up'):
		direction.y -= 0.5
		
	direction = direction.normalized() * speed
	
	if Input.is_action_just_pressed("toggle_weapon_left"):
		toggle_weapons(true)
		
	if Input.is_action_just_pressed("toggle_weapon_right"):
		toggle_weapons(false)
	

# ----- TICK PROCESS -----

func _physics_process(_delta):
	get_input()
	move()
	
