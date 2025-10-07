extends Area2D


#action when prey enters predator
func _on_body_entered(body):
	if body.is_in_group("prey"):  
		print("Prey dies")
		Engine.time_scale = 0.5
		body.get_node("PreyCollision").queue_free()
		body.queue_free()
