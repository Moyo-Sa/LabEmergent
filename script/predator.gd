extends CharacterBody2D

var SPEED = 50
var direction = Vector2.ZERO
var change_timer = 0.0
@onready var animated_predator = $AnimatedSprite2D

#variable to keep track of prey 
var target_prey: CharacterBody2D = null

#direction randomization 
func pick_new_direction():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	change_timer = randf_range(1.0, 3.0)  # change direction every 1–3 seconds


#ready 
func _ready():
	add_to_group("predator")
	randomize()
	pick_new_direction()

#handle movement and animation
func _physics_process(delta):
	#logic for chasing prey
	if target_prey != null:
		direction  = (target_prey.global_position - global_position).normalized()
		velocity = direction * SPEED * 1.2 
	else:
		#wander mode
		change_timer -= delta
		if change_timer <= 0:
			pick_new_direction()
	# Move predator
	velocity = direction * SPEED
	move_and_slide()
		
	#handle sprite animation
	if direction == Vector2.ZERO:
		animated_predator.play("idle")
	else:
		animated_predator.play("run")
		# flip sprite horizontally for left/right movement
		if direction.x != 0:
			animated_predator.flip_h = direction.x < 0

