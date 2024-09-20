extends Node2D
class_name AttackComponent

signal hit_enemy

@export var dmg: int = 1
@export var kb_force: float = 200
@export var CB2D: CharacterBody2D

@export var contact: Area2D
@export var side: Area2D
@export var up: Area2D

func _ready():
	if side:
		side.body_entered.connect(deal_dmg)
	if up:
		up.body_entered.connect(deal_dmg)
	if contact:
		contact.body_entered.connect(deal_dmg)

func deal_dmg(enemy: PhysicsBody2D):
	var enemy_hp: HealthComponent = enemy.get_child(0)
	print_debug("ATTACKING BUT NIT REALLY")
	if enemy.is_in_group("enemies"):
		# apply the knockback
		print_debug("ATTACKING")
		var kb_direction: Vector2 = (enemy.position- CB2D.position).normalized()
		enemy.velocity = kb_direction * kb_force
		enemy_hp.take_damage(dmg)
		hit_enemy.emit()
