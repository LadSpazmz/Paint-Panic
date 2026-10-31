	if(vibration_timer >= 0)
	{
		gamepad_set_vibration(global.gamepad_slot, vibration_strenght, vibration_strenght);
		vibration_timer -= 0.05;
		vibration_strenght -= 0.05;
	}
	else
	{
		gamepad_set_vibration(global.gamepad_slot, 0, 0);
	}
	
	vibration_timer = max(vibration_timer-1, 0);
	
	
	if(Up==true&&Down==true)
	Right=false;
	if(Right==true&&Left==true)
	Down=false;