extends Area2D
class_name AttackArea2D

@export var active_time: float = 0.1
var _activeTimer : float = 0.0

func _ready():
	deactivate()

func activate():
	monitoring = true
	_activeTimer = active_time
	set_physics_process(true)

func deactivate():
	monitoring = false
	set_physics_process(false)
	_activeTimer = 0.0

func _physics_process(delta: float):
	if _activeTimer < 0:
		deactivate()
		return
	_activeTimer -= delta
