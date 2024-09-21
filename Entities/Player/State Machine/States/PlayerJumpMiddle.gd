extends PlayerBaseState
class_name PlayerJumpMiddle

func enter(ctx: PlayerStateMachine):
	ctx.animation_player.play("jump_middle")
	
func update(ctx: PlayerStateMachine):
	check_transitions(ctx)
	
func physics_update(delta:float, ctx: PlayerStateMachine):
	ctx.move_horizontally(delta)
	
func exit(ctx: PlayerStateMachine):
	pass
	

func check_transitions(ctx: PlayerStateMachine):
	if ctx.is_grounded:
		ctx.switch_state(ctx.jump_end)
