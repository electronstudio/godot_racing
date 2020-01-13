extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time = 0
var best_time = 999

# Called when the node enters the scene tree for the first time.
func _ready():
	#$controls/GridContainer.rect_size = get_viewport_rect().size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	$HUD/time.text = "TIME: " + str(time).pad_zeros(3).left(6)


func _on_checkpoint_body_entered(body):
	if body.name == 'player':
		if(time < best_time):
			best_time = time
		$HUD/best.text = "BEST: " + str(best_time).pad_zeros(3).left(6)
		time = 0
