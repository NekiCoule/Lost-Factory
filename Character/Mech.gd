extends KinematicBody2D

# ---- VARIABLES -----

var speed = 50
var friction = 0.08
var acceleration = 0.08

var velocity = Vector2.ZERO
var direction = Vector2()

# nodes
var animation_node
var leg_node
var chassis_node

# ---- ONREADY -----

func _ready():
	add_leg("res://Character/Legs/Scenes/StandartLegs.tscn")
	animation_node = get_node("LegsBase/WalkAnimation")
	animation_node.play("Walk")
	animation_node.set_speed_scale(0)
	
	leg_node = get_node("LegsBase")
	
	chassis_node = get_node("ChassisBase")
	
	get_node("Chassis/Left_Weapon").flip_weapon()
	

# ----- FUNCTIONS -----

# function : add_legs
# parameters : (node path)
# returns : none
# description : Check if there is a leg and remove it, then add the new node as LegsBase to the mech

func add_leg(node_path):
	var new_leg = load(node_path).instance()
	
	if has_node("LegsBase"):
		get_node("LegsBase").queue_free()
		
	add_child(new_leg)
	new_leg.set_name("LegsBase")
	
	leg_node = get_node("LegsBase")
	
	speed = leg_node.speed
	friction = leg_node.friction
	acceleration = leg_node.acceleration
	
	
# function : add_chassis
# parameters : (node path)
# returns : none
# description : Check if there is a chassis and unequip any weapons attached, then remove it and add the new node as ChassisBase to the mechs

func add_chassis(node_path):
	var new_chassis = load(node_path).instance()
	
	if has_node("ChassisBase"):
		# unequip weapons !!
		
		
		get_node("ChassisBase").queue_free()
		
	add_child(new_chassis)
	new_chassis.set_name("ChassisBase")


# function : unequip
# parameters : (node)
# returns : None
# description : remove the weapon and put it in the inventory

func unequip_weapon(node):
	get_node(node).queue_free()


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
	leg_node.rotation = velocity.angle() + deg2rad(90)

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
	

# ----- TICK PROCESS -----

func _physics_process(delta):
	get_input()
	move()
	
