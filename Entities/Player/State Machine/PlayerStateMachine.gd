extends Node2D
class_name PlayerStateMachine

signal player_dead

# Nodes
@onready var health_component = $"../HealthComponent"

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

# Flags
var is_facing_right: bool = true
var can_jump: bool = true
var can_attack: bool = true

func _ready():
	current_state = idle

func switch_state(new_state: PlayerBaseState):
	current_state.exit(self)
	current_state = new_state
	new_state.enter(self)

func on_hurt():
	switch_state(hurt)

func flip():
	pass

