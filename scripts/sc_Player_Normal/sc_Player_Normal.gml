function sc_Player_Normal()
{
	var _move_Speed = abs(hsp)
	var _move = hold_right - hold_left

	var _against_Wall = (place_meeting(x + sign(DirXscale), y, obj_solid) || place_meeting_sidePlatform(x + sign(DirXscale), y))

	switch (sprite_index) 
	{
		case (sp_Player_Idle):
			if (_move != 0 && sprite_index != sp_Player_Walk && sprite_index != sp_Player_Land) {
				ResetAnim(sp_Player_Walk)
			}
			hsp = 0
			image_speed = 0.2
			break

		case (sp_Player_Walk):
			if (_move == 0 && _move_Speed == 0 && sprite_index != sp_Player_Idle) {
				ResetAnim(sp_Player_Idle)
			}
			image_speed = ((_move_Speed / 6) * 0.2)
			break

		case (sp_Player_Land):
			if (AnimEnd())
			{
				image_index = 0
				if (_move_Speed == 0) {
					sprite_index = sp_Player_Idle
				} else {
					sprite_index = sp_Player_Walk
				}
			}
			image_speed = 0.25
			break
	}

	if (_move != 0 && sprite_index != sp_Player_Idle)
	{
		DirXscale = _move
		if (!_against_Wall) {
			hsp = Approach(hsp, (currentSpd * _move), SpdAcc)
		}
	}
	else {
		hsp = Approach(hsp, 0, SpdDec)
	}

	if (!coyoteTime)
	{
		ResetAnim(sp_Player_Jump_Loop)
		state = states.jump
	}

	if (jumpBuffer && coyoteTime)
	{
		ResetAnim(sp_Player_Jump)
		vsp = jumpStrength
		jumpBuffer = false
		jumpStop = false
		state = states.jump
	}

	if (press_down && ground)
	{
		ResetAnim(sp_Player_CrouchStart)
		state = states.crouch
	}
}
