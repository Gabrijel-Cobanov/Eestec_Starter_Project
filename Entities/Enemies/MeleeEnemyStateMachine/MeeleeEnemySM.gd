extends Node2D
class_name MeeleeEnemySM

@export var enemy_name: String = "Imp"

# Nodes
@onready var CB2D = $".."
@onready var health_component: HealthComponent = $"../HealthComponent"
@onready var kb_timer = $"../Timers/KBTimer"

# States
@onready var idle = $MEIdleState
@onready var move= $MEMoveState
@onready var attack = $MEAttackState
@onready var death = $MEDeathState

var current_state: MeeleeEnemyBaseState

# movement variables
var nf: float = 500 # normalization factor
var GRAVITY: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var movement_speed: float = 7

# flags
var is_active: bool = true
var is_facing_right: bool = true
var is_being_knocked_back: bool = false # this will be used to control the velocity

func _ready():
	health_component.hurt.connect(on_hurt)
	kb_timer.timeout.connect(on_kb_time_out)
	
	current_state = idle
	
func _process(delta):
	current_state.update(self)
	
func _physics_process(delta):
	current_state.physics_update(delta, self)
	if !CB2D.is_on_floor():
		CB2D.velocity.y += GRAVITY
	
	# perhaps change
	if not is_being_knocked_back:
		update_velocity(delta)
	
	CB2D.move_and_slide()
	
func switch_state(new_state: MeeleeEnemyBaseState):
	current_state.exit(self)
	current_state = new_state
	new_state.enter(self)
	
func flip():
	pass
	
func update_velocity(delta: float):
	CB2D.velocity.x = -movement_speed * nf * delta
	
func reset_velocity_x():
	CB2D.velocity.x = 0
	
func on_hurt(dmg: int):
	is_being_knocked_back = true
	kb_timer.start()
	
func on_kb_time_out():
	is_being_knocked_back = false
	reset_velocity_x()

