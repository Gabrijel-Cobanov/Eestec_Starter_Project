extends PlayerBaseState
class_name PlayerRun

var coyote_time:float  = 0.2
var coyote_timer: float

func enter(ctx: PlayerStateMachine):
	ctx.animation_player.play("run")
	coyote_timer = coyote_time
	
func update(ctx: PlayerStateMachine):
	check_transitions(ctx)
	
func physics_update(delta:float, ctx: PlayerStateMachine):
	if !ctx.is_grounded:
		print_debug("FROM THE PLAYER RUN STATE ")
		coyote_timer -= delta
	ctx.move_horizontally(delta)
	
func exit(ctx: PlayerStateMachine):
	pass
	
func check_transitions(ctx: PlayerStateMachine):
	if ctx.input_direction.x == 0:
		ctx.switch_state(ctx.idle)
	elif Input.is_action_just_pressed("jump") and coyote_timer >= 0:
		ctx.switch_state(ctx.jump_start)
	elif coyote_timer < 0:
		ctx.switch_state(ctx.jump_middle)
