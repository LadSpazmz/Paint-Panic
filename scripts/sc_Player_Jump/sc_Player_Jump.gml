function sc_Player_Jump()
{
	image_speed = 0.225

	var _move_Speed = abs(hsp)
	var _move = hold_right - hold_left

	var _against_Wall = (place_meeting(x + sign(DirXscale), y, obj_solid) || place_meeting_sidePlatform(x + sign(DirXscale), y))

	if (!ground)
	{
		switch (sprite_index) 
		{
			case (sp_Player_Jump):
				if (jumpStop == false && !hold_a && vsp <= 0.5)
				{
					ResetAnim(sp_Player_Fall)
					vsp /= 10
					jumpStop = true
				}

				if (AnimEnd()) {
					ResetAnim(sp_Player_Jump_Loop)
				}
				break

			case (sp_Player_Jump_Loop):
				if (vsp >= 0) {
					ResetAnim(sp_Player_Fall)
				}
				break

			case (sp_Player_Fall):
				if (AnimEnd()) {
					ResetAnim(sp_Player_Fall_Loop)
				}
				break
		}
	}

	if (_move != 0)
	{
		DirXscale = _move
		hsp = Approach(hsp, (currentSpd * _move), SpdAcc)
	}
	else {
		hsp = Approach(hsp, 0, SpdDec)
	}

	if (ground && vsp >= 0)
	{
		ResetAnim(sp_Player_Land)
		if (_move != 0) {
			DirXscale = _move
		}
		state = states.normal
	}
}
