extends "res://Character/Chassis/Scripts/ChassisBase.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	# Make the chassis look at the mouse
	look_at(get_viewport().get_mouse_position())
	rotation = rotation + deg2rad(90)
