extends RigidBody2D

export var STEERING=100.0
export var ACCELERATION=5.0
export var FRICTION=0.1
export var DRIFT_FRICTION=1.0
export var DRIFT_STEERING=100.0

export (PackedScene) var Skidmarks


func _physics_process(delta):
	
#	if Input.is_action_pressed("ui_left"):
#		apply_torque_impulse(-STEERING)
#	elif Input.is_action_pressed("ui_right"):
#		apply_torque_impulse(STEERING)
#	if Input.is_action_pressed("ui_up"):
#		apply_central_impulse(Vector2(0, -ACCELERATION).rotated(rotation))
#	if Input.is_action_pressed("ui_down"):
#		linear_damp=BREAKING
#	else:
#		linear_damp=FRICTION

	var steering = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	if Input.is_action_pressed("drift"):
		apply_torque_impulse(DRIFT_STEERING * steering)
		linear_damp = DRIFT_FRICTION
		$skid.stream_paused = false
		var skidmark = Skidmarks.instance()
		skidmark.position = position
		skidmark.rotation = rotation
		get_node("/root/racetrack/skidmarks").add_child(skidmark)
	else:
		var acceleration = Input.get_action_strength("accelerate") * Vector2.UP * ACCELERATION
		apply_central_impulse(acceleration.rotated(rotation))
		apply_torque_impulse(STEERING * steering ) #* clamp(linear_velocity.length()/300, 0, 1))
		linear_damp = FRICTION
		$skid.stream_paused = true

	#ar breaking = Input.get_action_strength("break")
	#linear_damp = lerp(FRICTION, BREAKING, breaking)
	
#	if acceleration.length_squared()<0.1 and not 
#		linear_damp = BREAKING
#	else:
#		linear_damp = 0
	
	var scalefactor = 1 + linear_velocity.length()/1000
	$Camera2D.zoom = Vector2(scalefactor, scalefactor)

	$engine.pitch_scale = linear_velocity.length()/1000 + 0.1
	
#


func _on_player_body_entered(body):
	$crash.play()





func _on_steering_gui_input(event):
	if (event is InputEventScreenTouch or event is InputEventMouseButton) and event.pressed == false:
			Input.action_press("steer_right", 0)
	elif event is InputEventScreenTouch or InputEventScreenDrag: # or event is InputEventMouseButton:
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
