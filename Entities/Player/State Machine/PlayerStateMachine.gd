extends Node2D
class_name PlayerStateMachine

signal player_dead

# Nodes
@onready var health_component = $"../HealthComponent"
@onready var CB2D = $".."
@onready var coyote_timer = $"../Timers/CoyoteTimer"
@onready var jump_buffer = $"../Timers/JumpBuffer"


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
var coyote_time: float = 0.2
var jump_buffer_time: float = 0.1
@export var movement_speed: float = 10
@export var jump_force: float = -20

# Flags
var is_facing_right: bool = true
var jump_pressed: bool = true
var can_jump: bool = true
var should_jump: bool = true
var can_attack: bool = true

func _ready():
	current_state = idle
	
func _process(delta):
	input_direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	if CB2D.is_on_floor():
		coyote_timer.wait_time = coyote_time
		jump_buffer.wait_time = jump_buffer_time
	elif !CB2D.is_on_floor() and coyote_timer.time_left == 0.2:
		print_debug("Starting timer")
		coyote_timer.start()
		
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start()
		
	can_jump = coyote_timer.time_left >= 0
	should_jump = jump_buffer.time_left >= 0
	
	
	
	current_state.update(self)
	
func _physics_process(delta):
	current_state.physics_update(delta, self)
	if !CB2D.is_on_floor():
		CB2D.velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("jump") and can_jump and should_jump:
		CB2D.velocity.y =  jump_force * 50
		
	CB2D.velocity.x = input_direction.x * movement_speed * nf * delta
	CB2D.move_and_slide()
	

func switch_state(new_state: PlayerBaseState):
	current_state.exit(self)
	current_state = new_state
	new_state.enter(self)

func on_hurt():
	switch_state(hurt)

func flip():
	pass

