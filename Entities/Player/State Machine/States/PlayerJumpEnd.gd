extends PlayerBaseState
class_name PlayerJumpEnd

var anim_duration: float
var anim_length: float = 0.3

func enter(ctx: PlayerStateMachine):
	anim_duration = anim_length
	ctx.animation_player.play("jump_end")
	
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
	if Input.is_action_just_pressed("jump"):
		ctx.switch_state(ctx.jump_start)
	elif ctx.input_direction.x != 0:
		ctx.switch_state(ctx.run)
	elif !ctx.is_grounded:
		ctx.switch_state(ctx.jump_middle)
	else:
		ctx.switch_state(ctx.idle)
