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
