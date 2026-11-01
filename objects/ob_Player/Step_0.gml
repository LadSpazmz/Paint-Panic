if (!global.hitStun)
{
	if (state != undefined) {
		player_states[state]()
	}
	if state != states.noclip
	{
		sc_Entity_Physics()
		sc_Entity_Collision()
	}
}

if (ground) {
	coyoteTime = 7.5
} else if (vsp <= 0) {
	coyoteTime = 0
}

coyoteTime--

if (PaintingFinishTimer >= 0) {
	PaintingFinishTimer--
} else if (sprite_index == sp_Player_PaintingFinish) {
	state = states.normal
	ResetAnim(sp_Player_Idle)
}
