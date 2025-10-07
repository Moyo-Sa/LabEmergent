extends Area2D

@onready var animated_prey = get_parent()

#to keep track of predators
var predators_in_range = []

#action when predator gets close to prey
func _on_body_entered(body):
	if body.is_in_group("predator"):
		# Add the predator to the list
		if not predators_in_range.has(body):
			predators_in_range.append(body)  
		
		print("Predator is close")
		animated_prey.fleeing = true


		
#action when predator is too far
func _on_body_exited(body):
	if body.is_in_group("predator"):  
		print("Predator is close")
		animated_prey.fleeing = false
