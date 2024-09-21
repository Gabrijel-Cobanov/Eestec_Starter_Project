extends PlayerBaseState
class_name PlayerJumpStart

var anim_duration: float
var anim_length: float = 0.25

func enter(ctx: PlayerStateMachine):
	ctx.animation_player.play("jump_start")
	anim_duration = anim_length
	#anim_duration = ctx.animation_player.get_animation("jump_start").length
	ctx.jump()
	
func update(ctx: PlayerStateMachine):
	pass
	
func physics_update(delta:float, ctx: PlayerStateMachine):
	ctx.move_horizontally(delta)
	anim_duration -= delta
	if anim_duration <= 0:
		check_transitions(ctx)
	
func exit(ctx: PlayerStateMachine):
	pass
	
func check_transitions(ctx: PlayerStateMachine):
	if !ctx.is_grounded:
		ctx.switch_state(ctx.jump_middle)
	elif ctx.is_grounded:
		ctx.switch_state(ctx.jump_end)
