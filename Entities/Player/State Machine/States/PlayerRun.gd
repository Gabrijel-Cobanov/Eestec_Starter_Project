extends PlayerBaseState
class_name PlayerRun

func enter(ctx: PlayerStateMachine):
	ctx.animation_player.play("run")
	
func update(ctx: PlayerStateMachine):
	check_transitions(ctx)
	
func physics_update(delta:float, ctx: PlayerStateMachine):
	ctx.move_horizontally(delta)
	
func exit(ctx: PlayerStateMachine):
	pass
	
func check_transitions(ctx: PlayerStateMachine):
	if ctx.input_direction.x == 0:
		ctx.switch_state(ctx.idle)
	elif Input.is_action_just_pressed("jump"):
		ctx.switch_state(ctx.jump_start)
