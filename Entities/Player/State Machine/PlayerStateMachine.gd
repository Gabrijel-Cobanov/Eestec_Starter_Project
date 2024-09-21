extends Node2D
class_name PlayerStateMachine

signal player_dead

# Nodes
@onready var health_component = $"../HealthComponent"
@onready var CB2D = $".."
@onready var jump_buffer = $"../Timers/JumpBuffer"
@onready var animation_player = $"../Visuals/AnimationPlayer"


# States
@onready var idle = $PlayerIdle
@onready var run = $PlayerRun
@onready var jump_start = $PlayerJumpStart
@onready var jump_middle = $PlayerJumpMiddle
@onready var jump_end = $PlayerJumpEnd
@onready var attack = $PlayerAttack
@onready var hurt = $PlayerHurt
@onready var death = $PlayerDeath

var current_state: PlayerBaseState

# Movement variables
var nf: float = 500 # normalization factor
var input_direction: Vector2 = Vector2.ZERO
var GRAVITY: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_buffer_time: float = 0.1
@export var movement_speed: float = 10
@export var jump_force: float = -20

# Flags
var is_facing_right: bool = true
var can_jump: bool = true
var jump_buffer_has_time_left: bool = true
var can_attack: bool = true
var is_grounded: bool = true

func _ready():
	current_state = idle
	
func _process(delta):
	input_direction = Input.get_vector("left", "right", "up", "down").normalized()

	if Input.is_action_just_pressed("jump") and !is_grounded:
		jump_buffer.start()

	jump_buffer_has_time_left = jump_buffer.time_left >= 0
	
	flip()
	current_state.update(self)
	
func _physics_process(delta):
	current_state.physics_update(delta, self)
	if !CB2D.is_on_floor():
		CB2D.velocity.y += GRAVITY * delta # important detail!!!!
		is_grounded = false
	else:
		is_grounded = true
		
	CB2D.move_and_slide()
	

func switch_state(new_state: PlayerBaseState):
	current_state.exit(self)
	current_state = new_state
	new_state.enter(self)

func on_hurt():
	switch_state(hurt)

func flip():
	if is_facing_right and input_direction.x < 0:
		CB2D.scale.x *= -1
		is_facing_right = !is_facing_right
	elif !is_facing_right and input_direction.x > 0:
		CB2D.scale.x *= -1
		is_facing_right = !is_facing_right
		
func jump():
	CB2D.velocity.y =  jump_force * nf/44
	
func move_horizontally(delta: float):
	CB2D.velocity.x = input_direction.x * movement_speed * nf * delta

