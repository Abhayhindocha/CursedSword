extends CharacterBody2D

#Dependencies
@onready var run_detect = $run_detect
@onready var run_detect_2 = $run_detect2

#State Pattern CRAP
enum States {IDLE, LEFT, RIGHT} #COLLIDING STATES
var state = States.IDLE

#Movement
@export var speed = 90
var direction = 0

#Health
@export var health = 1

func change_state(newState):
	state = newState

func _physics_process(delta):
	
	match state:
		States.LEFT:
			#print("LEFT")
			left()
			pass
		
		States.RIGHT:
			#print("RIGHT")
			right()
			pass
		
		States.IDLE:
			#print("idle")
			idle()
			pass
	
	if !is_on_floor():
		velocity.y+= 10
	
	
	move_and_slide()

func left():
	if !run_detect_2.is_colliding():
		change_state(States.IDLE)
	direction = -1
	velocity.x = direction * speed

func right():
	if !run_detect.is_colliding():
		change_state(States.IDLE)
	direction = 1
	velocity.x = direction * speed

func idle():
	if run_detect.is_colliding():
		change_state(States.RIGHT)

	if run_detect_2.is_colliding():
		change_state(States.LEFT)
	velocity.x = direction * speed

	direction = 0

func hurt():
	health -= health
	if health == 0:
		queue_free()

#func move(val):
	#if val:
		#direction = 1
		#if !run_detect.is_colliding():
			#direction = 0
	#else: 
		#direction = -1
		#if !run_detect_2.is_colliding():
			#direction = 0
