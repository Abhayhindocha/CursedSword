extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#@onready var t = TextEdit.new()

#var arr = []



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if TextEdit.text

#SAVIN

#extends CharacterBody2D
#
##Dependencies
#@onready var run_detect = $run_detect
#@onready var run_detect_2 = $run_detect2
#
##State Pattern CRAP
#enum States {IDLE, LEFT, RIGHT} #COLLIDING STATES
#var state = States.IDLE
#
##Movement
#@export var speed = 80
#var direction = 0
#
#func change_state(newState):
	#state = newState
#
#func _physics_process(delta):
	#
	#match state:
		#States.LEFT:
			#print("LEFT")
			#left()
			#pass
		#
		#States.RIGHT:
			#print("RIGHT")
			#right()
			#pass
		#
		#States.IDLE:
			#print("idle")
			#idle()
			#pass
	#
	#if !is_on_floor():
		#velocity.y+= 10
	#
	#velocity.x = direction * speed
	#move_and_slide()
#
#func left():
	#if !run_detect_2.is_colliding():
		#change_state(States.IDLE)
	#direction = 1
#
#func right():
	#if !run_detect.is_colliding():
		#change_state(States.IDLE)
	#direction = -1
#
#func idle():
	#if run_detect.is_colliding():
		#change_state(States.RIGHT)
		#direction = 1
	#if run_detect_2.is_colliding():
		#change_state(States.LEFT)
		#direction = -1
	#direction = 0
#
##func move(val):
	##if val:
		##direction = 1
		##if !run_detect.is_colliding():
			##direction = 0
	##else: 
		##direction = -1
		##if !run_detect_2.is_colliding():
			##direction = 0
