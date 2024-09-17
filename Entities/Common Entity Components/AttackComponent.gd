extends Node
class_name AttackComponent

signal hit_enemy

@export var dmg: int = 1
@export var kb_force: float = 20
@export var CB2D: CharacterBody2D

@export var contact: Area2D
@export var left: Area2D
@export var up: Area2D

func deal_dmg(enemy: PhysicsBody2D):
	var enemy_hp: HealthComponent = enemy.get_child(0)
	if enemy.is_in_group("enemies"):
		# apply the knockback
		var kb_direction: Vector2 = (CB2D.position - enemy.position).normalized()
		enemy.velocity = kb_direction * kb_force
		enemy_hp.take_damage(dmg)
		hit_enemy.emit()
