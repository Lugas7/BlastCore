extends CharacterBody2D
class_name MovementCharacterBody2D

# acceleration is a force that increases the velocity of the character
@export var acceleration: float = 1500
# friction is a force that opposes the movement of the character proportional to its velocity
@export var friction: float = 600
# max_speed is the maximum velocity that the character can reach
@export var max_speed: float = 400




func _velocity(delta: float, direction: Vector2, acceleration_multiplyer: float = 1.0, max_speed_multiplyer: float = 1.0) -> void:
	"""
		Calculates and updates the velocity of the character based on the input direction and delta time.

		Args:
			delta (float): The frame time step, used to ensure consistent movement speed regardless of frame rate.
			direction (Vector2): The direction vector indicating the desired movement direction.

		Behavior:
			- If the direction is zero (no input), the velocity is reduced by applying friction until it stops.
			- If the direction is not zero, the velocity is increased by applying acceleration in the given direction.
			- The velocity is clamped to a maximum speed to prevent it from exceeding the defined limit.
	"""

	if direction == Vector2.ZERO:
		if velocity.length() > friction * delta:
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
	else:
		velocity += direction * acceleration * acceleration_multiplyer * delta
		if velocity.length() > max_speed * max_speed_multiplyer:
			velocity = velocity.normalized() * max_speed * max_speed_multiplyer




	


# func _velocity(delta: float, direction: Vector2) -> void:
# 	"""
# 		Applies a velocity to the character
# 		Use the direction vector to determine the direction of the movement
# 		Use the delta parameter to make the movement frame independent
# 		Use the velocity parameter to determine the future movement
# 	"""

# 	# Apply initial speed if there was no velocity
# 	if direction != Vector2.ZERO:
# 		if velocity == Vector2.ZERO:
# 			velocity = direction.normalized() * instant_speed
		
# 		# Calculate and update velocity with acceleration and friction
# 		var acceleration_vector = direction * acceleration * delta
# 		velocity += acceleration_vector
# 		velocity -= velocity * friction * delta
		
# 		# Clamp the velocity to the maximum speed
# 		if velocity.length() > max_speed:
# 			velocity = velocity.normalized() * max_speed
# 	else:
# 		# Reduce velocity if there is no input direction
# 		if velocity != Vector2.ZERO:
# 			if velocity.length() > instant_speed:
# 				velocity = velocity.normalized() * instant_speed
# 			velocity -= velocity.normalized() * instant_speed * friction * delta
