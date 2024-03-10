extends Node2D

@onready var player = $Player
@onready var simple_enemy = $SimpleEnemy
@onready var ranged_enemy = $Ranged_enemy

func _physics_process(delta):
	pass
	#if player.position.x > simple_enemy.position.x:
		#pass
		#print("left")
	#else:
		#pass
		#print("right")
