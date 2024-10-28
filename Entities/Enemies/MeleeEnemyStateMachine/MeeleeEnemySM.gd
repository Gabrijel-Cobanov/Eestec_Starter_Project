extends Node2D
class_name MeeleeEnemySM

@export var enemy_name: String = "Imp"
@export var pursue_area: Area2D
@export var attack_area: Area2D
@export var attack_anim_duration: float
@export var death_anim_duration: float

# Nodes
@export var CB2D: CharacterBody2D
@export var health_component: HealthComponent
@export var kb_timer: Timer
@export var attack_timer: Timer

# States
@export var idle: MEIdleState
@export var move: MEMoveState
@export var attack: MEAttackState
@export var death: MEDeathState

var current_state: MeeleeEnemyBaseState

# movement variables
var nf: float = 500 # normalization factor
var GRAVITY: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var movement_speed: float = 7
@export var lunge_force: float = 4

# flags
var is_active: bool = true
var is_facing_right: bool = true
var is_being_knocked_back: bool = false # this will be used to control the velocity
var should_pursue_player: bool = false
var should_attack_player: bool = false
var can_attack: bool = true

func _ready():
	health_component.hurt.connect(on_hurt)
	kb_timer.timeout.connect(on_kb_time_out)
	attack_timer.timeout.connect(func(): can_attack = true)
	
	pursue_area.body_entered.connect(func(body): should_pursue_player = true)
	pursue_area.body_exited.connect(func(body): should_pursue_player = false)
	
	attack_area.body_entered.connect(func(body): should_attack_player = true)
	attack_area.body_exited.connect(func(body): should_attack_player = false)
	
	current_state = idle
	
func _process(delta):
	flip()
	current_state.update(self)
	
func _physics_process(delta):
	current_state.physics_update(delta, self)
	if !CB2D.is_on_floor():
		CB2D.velocity.y += GRAVITY
	
	CB2D.move_and_slide()
	
func switch_state(new_state: MeeleeEnemyBaseState):
	current_state.exit(self)
	current_state = new_state
	new_state.enter(self)
	
func flip():
	if CB2D.velocity.x < 0 and is_facing_right:
		CB2D.scale.x *= -1
		is_facing_right = !is_facing_right
	elif CB2D.velocity.x > 0 and !is_facing_right:
		CB2D.scale.x *= -1
		is_facing_right = !is_facing_right
	
func update_velocity_x(velocity_x: float, delta: float):
	if is_being_knocked_back:
		return
		
	CB2D.velocity.x = velocity_x * nf * delta
	
func reset_velocity_x():
	CB2D.velocity.x = 0
	
func on_hurt(dmg: int):
	is_being_knocked_back = true
	kb_timer.start()
	
func on_kb_time_out():
	is_being_knocked_back = false
	reset_velocity_x()

