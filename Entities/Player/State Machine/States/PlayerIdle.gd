extends PlayerBaseState
class_name PlayerIdle

func enter(ctx: PlayerStateMachine):
	ctx.CB2D.velocity.x = 0
	ctx.animation_player.play("idle")
	
func update(ctx: PlayerStateMachine):
	check_transitions(ctx)
	
func physics_update(delta:float, ctx: PlayerStateMachine):
	pass
	
func exit(ctx: PlayerStateMachine):
	pass
	
func check_transitions(ctx: PlayerStateMachine):
	if Input.is_action_just_pressed("jump"):
		ctx.switch_state(ctx.jump_start)
	elif ctx.input_direction.x != 0:
		ctx.switch_state(ctx.run)
	elif !ctx.is_grounded:
		ctx.switch_state(ctx.jump_middle)
