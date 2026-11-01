function sc_Player_Crouch()
{
	var _move_Speed = abs(hsp)
	var _move = hold_right - hold_left

	switch(sprite_index) 
	{
		case(sp_Player_CrouchStart):
			if (AnimEnd())
				ResetAnim(sp_Player_Crouch)
			image_speed = 0.2
			break

		case(sp_Player_Crouch):
			if (_move != 0 && sprite_index != sp_Player_Crawl)
				ResetAnim(sp_Player_Crawl)
			image_speed = 0.2
			break

		case(sp_Player_Crawl):
			if (_move == 0 && _move_Speed == 0 && sprite_index != sp_Player_Crouch)
				ResetAnim(sp_Player_Crouch)

			image_speed = ((_move_Speed / 6) * 0.2)
			break
	}

	if (_move != 0)
	{
		DirXscale = _move
		hsp = Approach(hsp, (4 * _move), SpdAcc)
	}
	else
		hsp = 0

	if (!coyoteTime)
	{
		ResetAnim(sp_Player_Fall)
		state = states.jump
	}
	var _can_stand = false
	mask_index = sp_PlayerMask
	if (!place_meeting(x, y, obj_solid)) _can_stand = true
			
	mask_index = sp_PlayerMask_crouch
	if (_can_stand)
	{
		if (jumpBuffer && coyoteTime && ground)
		{
			mask_index = sp_PlayerMask
			ResetAnim(sp_Player_Jump)
			vsp = jumpStrength
			jumpBuffer = false
			jumpStop = false
			state = states.jump
		}

		if (!hold_down && ground)
		{
			mask_index = sp_PlayerMask
			image_index = 0
			if (_move_Speed != 0)
				sprite_index = sp_Player_Walk
			else
				sprite_index = sp_Player_Idle
			state = states.normal
		}
	}
}
