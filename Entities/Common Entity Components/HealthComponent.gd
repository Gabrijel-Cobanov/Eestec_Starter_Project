extends Node
class_name HealthComponent

signal hurt(dmg: int)
signal dead
signal healed(hp: int)

@export var max_health: int = 5
@export var heal_ammount: int = 1

var current_health: int

func _ready():
	current_health = max_health
	
func take_damage(dmg: int):
	current_health -= dmg
	hurt.emit(dmg)
	if current_health <= 0:
		dead.emit()
	
func heal(hp: int):
	current_health += hp
	healed.emit(hp)
	if current_health >= max_health:
		current_health = max_health
