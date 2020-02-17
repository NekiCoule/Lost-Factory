extends Area2D


func _ready():
	pass 

func _process(_delta):
	
	# Make the chassis look at the mouse
	look_at(get_viewport().get_mouse_position())
	rotation = rotation + deg2rad(90)
