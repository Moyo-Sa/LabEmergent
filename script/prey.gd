extends CharacterBody2D

# variable declarations
var SPEED = 50
var direction = Vector2.ZERO
var predator: Node = null
var in_safe_zone = false
var fleeing = false
@onready var safe_zone = %SafeZoneArea
@onready var animated_prey = $AnimatedSprite2D
var change_timer = 0.0



#direction randomization 
func pick_new_direction():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	change_timer = randf_range(1.0, 3.0)  # change direction every 1–3 seconds

#ready 
func _ready():
	add_to_group("prey")
	randomize()
	pick_new_direction()


#handle movement and animation
func _physics_process(delta):
	change_timer -= delta
	if change_timer <= 0:
		pick_new_direction()
	
# Move prey
	#running away from predator
	if fleeing:
		var target_pos = safe_zone.global_position + Vector2(randf_range(-20,20), randf_range(-20,20))
		direction = (target_pos - global_position).normalized()
		velocity = direction * SPEED * 1.5  # run faster when fleeing

	 # Stop inside safe zone
	if safe_zone.global_position.distance_to(global_position) < 10:
		velocity = Vector2.ZERO
		in_safe_zone = true
	else:
		in_safe_zone = false
		change_timer -= delta
		if change_timer <= 0:
			pick_new_direction()
			velocity = direction * SPEED
	move_and_slide()
		
	#handle sprite animation
	if direction == Vector2.ZERO:
		animated_prey.play("idle")
	else:
		animated_prey.play("run")
		# flip sprite horizontally for left/right movement
		if direction.x != 0:
			animated_prey.flip_h = direction.x < 0
	
	
