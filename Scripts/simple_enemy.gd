extends Area2D

#Dependencies
@onready var floordetect = $Floordetect
@onready var floordetect_2 = $Floordetect2

#Moving
@export var speed = -1

#Properties
@export var health = 1

func _physics_process(delta):
	grounded()
	global_position+= Vector2(speed, 0)

func grounded():
	if !floordetect.is_colliding() or !floordetect_2.is_colliding():
		change_direction()

func change_direction():
	speed = -speed

func _on_area_entered(area):
	if area.is_in_group("simpleEnemy"): 
		change_direction()

func hurt():
	health -= health
	if health == 0:
		queue_free()

