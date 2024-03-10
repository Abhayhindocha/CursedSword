extends CharacterBody2D
class_name Player

# Debug shit
@onready var label = $Label

#State Pattern shit
enum States {IDLE, WALK, JUMP, DOGE, SHILD, ATTACK, HURT, RECOVERY}
var state = States.IDLE

#Player Veriables
var input:Vector2 = Vector2.ZERO
var direction : int #to check where is player looking at

#Dependencies
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hurtcol = $HurtBox/Hurtcol

#Walk State Veriables
@export var SPEED:int = 200
@export var accel:int = 30

#Jump Veriables
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_decent: float

#Jump Calculation
@onready var jump_velocity :float = ((2.0 * jump_height) / jump_time_to_peak ) * -1
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_decent * jump_time_to_decent)) * -1 

#Jump Extra
var can_jump:bool = false

#Doge Variabals
var doge_dir: int

#Hurt Variables
var hurter

#State Functions
func change_state(newState):
	state = newState

#Comon Functions
func _physics_process(delta):
	# Debug Shit
	match(state):
		States.IDLE:
			label.text = "IDLE"
		States.WALK:
			label.text = "WALK"
		States.DOGE:
			label.text = "DOGE"
		States.JUMP:
			label.text = "JUMP"
		States.SHILD:
			label.text = "SHILD"
		States.ATTACK:
			label.text = "ATTACK"
		States.HURT:
			label.text = "HURT"
		_:
			label.text = "UNDEF"
	
	#Stuff to run independently from states
	applay_gravity(delta)
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		change_state(States.JUMP)
	player_input()
	
	#State Match
	match state:
		States.IDLE:
			idle()
			pass
		
		States.WALK:
			walk()
			pass
		
		States.JUMP:
			jumpin(delta)
			pass
		
		States.DOGE:
			doge()
			pass
		
		States.SHILD:
			shild()
			pass
		
		States.ATTACK:
			attack()
			pass
		
		States.HURT:
			hurt()
			pass
		
		States.RECOVERY:
			recovery()
			pass
		
		
	#stuff to run independently from states
	move_and_slide()

func player_input():
	input = Input.get_vector("left", "right", "down", "up")
	if input.x != 0:
		#save the value unless its zero
		direction = input.x

#Idle State functions
func idle():
	ap.play("idle")
	velocity.x = move_toward(velocity.x, 0, accel)
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		change_state(States.WALK)
	if Input.is_action_just_pressed("up"):
		change_state(States.JUMP)
	if Input.is_action_just_pressed("doge"):
		doge_dir = direction 
		change_state(States.DOGE)
	if Input.is_action_just_pressed("shild"):
		change_state(States.SHILD)
	if Input.is_action_just_pressed("atk"):
		change_state(States.ATTACK)

#TODO : COMBINE THE IDLE STATES WHICH ARE SAME IN ONE FUNCTION

#Walk State functions
func walk():
	velocity.x = move_toward(velocity.x, SPEED*input.x, accel)
	if !Input.is_anything_pressed():
		change_state(States.IDLE)
	if Input.is_action_just_pressed("up"):
		change_state(States.JUMP)
	if Input.is_action_just_pressed("doge"):
		doge_dir = direction
		change_state(States.DOGE)
	if Input.is_action_just_pressed("shild"):
		change_state(States.SHILD)
	if Input.is_action_just_pressed("atk"):
		change_state(States.ATTACK)
	match (direction):
		1:
			sprite.flip_h = false
		-1:
			sprite.flip_h = true
	ap.play("walk")
	#match (input):
		#Vector2(1,0):
			#sprite.flip_h = false
			#ap.play("walk")
		#Vector2(-1,0):
			#sprite.flip_h = true
			#ap.play("walk")

#Jump State functions
func jumpin(delta):
	jump()

func jump():
	velocity.y = jump_velocity
	change_state(States.IDLE)
	#can_jump = false

func get_gravity() ->float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func applay_gravity(delta):
	velocity.y += get_gravity() * delta

#Doge State functions
func doge():
	velocity.x = 300 * doge_dir
	ap.play("doge")

func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "doge":
		#change_state(States.IDLE)
	match anim_name:
		"doge":
			change_state(States.IDLE)
		"shild":
			change_state(States.IDLE)
		"attack1":
			change_state(States.IDLE)
		"hurt":
			change_state(States.RECOVERY)
		"recovery":
			hurtcol.disabled = false
			change_state(States.IDLE)

#Shild State functions
func shild():
	velocity.x = move_toward(velocity.x, 0, accel)
	ap.play("shild")
	pass

#Attack State functions
func attack():
	velocity = Vector2.ZERO
	ap.play("attack1")

#Attack Effects
func _on_attack_1_range_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("rangedEnemy") or area.is_in_group("simpleEnemy"):
		area.hurt()

# HURTBOX 
func _on_hurt_box_area_entered(area):
	if area.is_in_group("rangedEnemy") or area.is_in_group("simpleEnemy"):
		hurter = area
		change_state(States.HURT)

#Hurt State Functions

func hurt():
	if hurter.position.x < position.x:
		sprite.flip_h = true
		velocity.x = 50
		ap.play("hurt")
	else :
		sprite.flip_h = false
		velocity.x = -50
		ap.play("hurt")

func recovery():
	hurtcol.disabled = true
	ap.play("recovery")

# CRAPSSS
#Physicsproc
	#input.x = Input.get_axis("left", "right")
	#input.y = Input.get_axis("up", "down")
	#input = input.normalized()

#func get_input_velocity() -> float:
	#var horizontal := 0.0
	#if Input.is_action_pressed("ui_left"):
		#horizontal -= 1.0
	#if Input.is_action_pressed("ui_right"):
		#horizontal += 1.0
	#return horizontal

#func _unhandled_input(event):
	#if state != States.DOGE:
		#if event.is_action_pressed("left") && event.is_action_pressed("doge"):
			#direction = -1
			#sprite.flip_h = true
			#change_state(States.DOGE)
		#if event.is_action_pressed("right") && event.is_action_pressed("doge"):
			#direction = 1
			#sprite.flip_h = false
			#change_state(States.DOGE)
	
	#UNDER IDLE
	#if event.is_action_pressed("doge"):
		#if event.is_action_pressed("left"):
			#direction = -1
		#elif event.is_action_pressed("right"):
			#direction = 1
		#change_state(States.DOGE)



