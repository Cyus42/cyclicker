extends Control

var distance : int = 200

func _ready() -> void:
	$Timer.wait_time = global.bapperspeed
	rotation = randi_range(-180,180)
	position += Vector2(distance * cos(rotation),distance * sin(rotation))

func _on_timer_timeout() -> void:
	%Sprite2D.position.x = -100
	global.squeaks += global.bapperhit
	
func _process(delta: float) -> void:
	if %Sprite2D.position.x <= 0 :
		%Sprite2D.position.x -= delta * -100
	$Timer.wait_time = global.bapperspeed
