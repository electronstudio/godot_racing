# Godot Racing Game Tutorial

* We are going to make [this racing game](https://electronstudio.github.io/godot_racing/).  Click the link to play it now.

* This game uses Godot's physics engine so that all the objects in the game have real physics.  Notice
what happens when you hit the cones.  (Unfortunately Godot does not have correct car physics built-in,
so the cars control like real life boats or spaceships, but it's still fun for a game.)

* You can play on mobile using the touchscreen buttons.

* You can play with cursors keys and hit 'space' to drift.  (You can also play with a controller.)

* You can hit 'C' key to rotate the camera.

* There is a timer and your best time is (temporarily) saved.

## Getting started

Download [this stater project](racing_starter.zip), unzip and import it into Godot.

## Camera

Add a child node of type `Camera2D` to `player`.

In the Inspector, enable `Current`.

Set the `Process mode` to `Physics`.

Try changing the `Zoom x` and `y`.  What happens?

Try enabling `Smoothing`.  What happens?

If you would like the camera to zoom in and out, replace the `camera()` function in `player.gd`
with this code:

```gdscript
func camera():
	var scalefactor = 1.5 + linear_velocity.length()/1000
	$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(scalefactor, scalefactor), 0.01) 
```


## Engine sound



Replace the function `sound()` in `player.gd` with this code:

```gdscript
func sound():
	$engine.pitch_scale = linear_velocity.length()/1000 + 0.1
```


## Track Tilemap

Click on the `track` node.  Edit the tilemap to create your race track.

I have only made collision shapes for the red/white barriers.  The other barriers won't work (unless
you edit `racing_tileset.tres` and create your own shapes.)


## Cones

## Other map objects

## Crash sound effect

Click on the `player` node.  Connect signal `body_entered` to `player.gd` script.  The 
function should look like this:

```gdscript
func _on_player_body_entered(body):
	$crash.play()
```

## HUD

Create a `CanvasLayer` and name it `HUD`.
Add child nodes to it:
* `Label` named `time`.
* `Label` named `best`.
In the Inspector find the `Custom Font` and drag in the big font from the FileSystem (`interface/fonts/kenvector_futre_32.tres`)

Attach a new script to the root node `racetrack`.
Call it `racetrack.gd`, delete any code in it, and add this code:

```gdscript
extends Node2D

var time = 0
var best_time = 999

func _process(delta):
	time += delta
	$HUD/time.text = "TIME: " + str(time).pad_zeros(3).left(6)

func _on_checkpoint_body_entered(body):
	if body.name == 'player':
		if(time < best_time):
			best_time = time
		$HUD/best.text = "BEST: " + str(best_time).pad_zeros(3).left(6)
		time = 0

```


## Analogue controls

In Project Settings set up controls like this:

![inputmap](inputmap.png)

Replace the `input()` function in `player.gd` with this:

```gdscript
func input():
	var steering = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	if Input.is_action_pressed("drift"):
		apply_torque_impulse(DRIFT_STEERING * steering)
		linear_damp = DRIFT_FRICTION
		$skid.stream_paused = false
		doSkidmark()
	else:
		var acceleration = (Input.get_action_strength("accelerate") - Input.get_action_strength("brake")) * Vector2.UP * ACCELERATION
		apply_central_impulse(acceleration.rotated(rotation))
		apply_torque_impulse(STEERING * steering )
		linear_damp = FRICTION
		$skid.stream_paused = true
```

## Skid marks

We already have a `skidmark.tscn` scene that contains a skidmark.  We also already have the sound
effect added to the player.

Create a `Node2d` and name it `skidmarks`.  This will store our skidmark objects.

Replace the `doSkidmark()` function in  `player.gd` with this:

```gdscript
func doSkidmark():
	var skidmark = Skidmark.instance()
	skidmark.position = position
	skidmark.rotation = rotation
	get_node("/root/racetrack/skidmarks").add_child(skidmark)
```

## Challenges

2 players
Computer controlled cars
High score table (online)