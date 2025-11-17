extends CharacterBody2D

# variable declarations
var SPEED = 50
var direction = Vector2.ZERO
@onready var threat_zone: Area2D = $ThreatZone
var in_safe_zone = false
var fleeing = false
#@onready var safe_zone = get_tree().get_current_scene().get_node("SafeZoneArea")
#@onready var safe_zone: Area2D = %SafeZoneArea
@onready var safe_zone: CollisionShape2D = $"../../SafeZoneArea/SafeZone"
@onready var animated_prey = $AnimatedSprite2D
var change_timer = 0.0
@onready var flee_target = Vector2.ZERO



#direction randomization 
func pick_new_direction():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	change_timer = randf_range(3.0, 5.0)  # change direction every 3 - 5 seconds

#ready 
func _ready():
	add_to_group("prey")
	randomize()
	pick_new_direction()
	print("Safe Zone is ", safe_zone)
	print("Safe Zone position: ", safe_zone.global_position) 


#handle movement and animation
func _physics_process(delta):
	# Move prey
	#running away from predator
	if fleeing:
		var distance = (flee_target - global_position).length()
		if distance < 5:  # close enough
			velocity = Vector2.ZERO
			fleeing = false
			in_safe_zone = true
			direction == Vector2.ZERO
		else:
			direction = (flee_target - global_position).normalized()
			velocity = direction * SPEED * 1.5
		change_timer -= delta
		if change_timer <=0:
			pick_new_direction()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO	
	move_and_slide()
		
	#handle sprite animation
	if direction == Vector2.ZERO:
		animated_prey.play("idle")
	else:
		animated_prey.play("run")
		# flip sprite horizontally for left/right movement
		if direction.x != 0:
			animated_prey.flip_h = direction.x < 0
	
	

func _on_threat_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("predator"):  
		fleeing = true
		flee_target = safe_zone.global_position + Vector2(randf_range(-20,20), randf_range(-20,20))


func _on_safe_zone_area_body_entered(body: Node2D) -> void:
	# Stop inside safe zone
	if body == self: 
		in_safe_zone = true
		fleeing = false
		change_timer = 0.0
		print("in safe zone")
		

func _on_safe_zone_area_body_exited(body: Node2D) -> void:
	if body == self: 
		in_safe_zone =  false
		
	
