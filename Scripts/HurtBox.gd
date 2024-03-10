extends Area2D

@export var life:int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hurt():
	life -= life
	if life == 0:
		get_parent().queue_free()
