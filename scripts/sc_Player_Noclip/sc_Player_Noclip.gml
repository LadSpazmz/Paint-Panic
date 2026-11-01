function sc_Player_Noclip()
{
	var _move = hold_right - hold_left
	var _move_y = hold_down - hold_up
	
	var boost = keyboard_check(vk_shift) * 2
	
	x += _move * 5 * boost
	y += _move_y * 5 * boost
	
	if (jumpBuffer)
	{
		jumpBuffer = false
		jumpStop = false
		state = states.normal
	}
	
}