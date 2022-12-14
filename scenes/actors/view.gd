extends Area2D

const VIEW_DISTANCE: int = 600


func get_aimed_point() -> Vector2:
	return get_global_mouse_position()


func _process(delta: float) -> void:
	return
	look_at(get_aimed_point())


func _on_body_in_viewcone(body: Node2D) -> void:
	if body.is_in_group("view_conable"):
		if body.global_position.distance_to(global_position) <= VIEW_DISTANCE + 100:
			print("within")
			body.show()
			return

		var space_state = get_world_2d().direct_space_state
		var result = (
			space_state
			. intersect_ray(
				PhysicsRayQueryParameters2D.create(global_position, body.global_position)
			)
		)
		if result != {} and result.collider == body:
			print("not within, but collides")
			print(result.collider)
			body.show()


func _on_body_exited_viewcone(body: Node2D) -> void:
	if (
		body.is_in_group("view_conable")
		and body.global_position.distance_to(global_position) > VIEW_DISTANCE
	):
		print("exited")
		body.hide()
