extends CanvasLayer


func _on_steering_gui_input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed == false:
			Input.action_press("steer_right", 0)
	elif event is InputEventScreenTouch or InputEventScreenDrag:
		var amount = (event.position.x-200)/150
		Input.action_press("steer_right", amount)

func _on_drift_pressed():
	Input.action_press("drift", 1.0)


func _on_drift_released():
	Input.action_release("drift")


func _on_accelerate_pressed():
	Input.action_press("accelerate", 1.0)
	

func _on_accelerate_released():
	Input.action_release("accelerate")


func _on_reverse_pressed():
	Input.action_press("brake", 1.0)


func _on_reverse_released():
	Input.action_release("brake")
