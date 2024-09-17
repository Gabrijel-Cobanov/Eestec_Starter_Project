extends Node
class_name AttackComponent

signal hit_enemy

@export var dmg: int = 1
@export var kb: float = 20
@export var CB2D: CharacterBody2D

@export var contact: Area2D
@export var left: Area2D
@export var up: Area2D

func deal_dmg(enemy: PhysicsBody2D):
	var enemy_hp: HealthComponent = enemy.get_child(0)
	var kb_direction: Vector2 = (CB2D.position - enemy.position).normalized()
	
	
