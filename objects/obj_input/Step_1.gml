/// @description Input checks	
	if(instance_exists(obj_shell) && !obj_shell.isOpen || !instance_exists(obj_shell))
	{
		var player_shoulder_down = instance_exists(ob_Player) ? gamepad_button_check(global.gamepad_slot, gp_shoulderlb) || gamepad_button_check(global.gamepad_slot, gp_shoulderrb) : false;
		var player_shoulder_down_press = instance_exists(ob_Player) ? gamepad_button_check_pressed(global.gamepad_slot, gp_shoulderlb) || gamepad_button_check_pressed(global.gamepad_slot, gp_shoulderrb) : false;
		
		Up = keyboard_check(global.up) || gamepad_button_check(global.gamepad_slot, gp_padu);
		Down = keyboard_check(global.down) || gamepad_button_check(global.gamepad_slot, gp_padd);
		Left = keyboard_check(global.left) || gamepad_button_check(global.gamepad_slot, gp_padl);
		Right = keyboard_check(global.right) || gamepad_button_check(global.gamepad_slot, gp_padr);
		Dash = keyboard_check(global.dash) || gamepad_button_check(global.gamepad_slot, gp_shoulderrb) || player_shoulder_down;
		A = keyboard_check(global.a) || gamepad_button_check(global.gamepad_slot, gp_face1);
		B = keyboard_check(global.b) || gamepad_button_check(global.gamepad_slot, gp_face2);
		C = keyboard_check(global.c) || gamepad_button_check(global.gamepad_slot, gp_face3);
		Action = A || B || C;
		Start = keyboard_check(global.start) || gamepad_button_check(global.gamepad_slot, gp_start);

		//Pressed
		UpPress = keyboard_check_pressed(global.up) || gamepad_button_check_pressed(global.gamepad_slot, gp_padu);
		DownPress = keyboard_check_pressed(global.down) || gamepad_button_check_pressed(global.gamepad_slot, gp_padd);
		LeftPress = keyboard_check_pressed(global.left) || gamepad_button_check_pressed(global.gamepad_slot, gp_padl);
		RightPress = keyboard_check_pressed(global.right) || gamepad_button_check_pressed(global.gamepad_slot, gp_padr);
		DashPress = keyboard_check_pressed(global.dash) || gamepad_button_check_pressed(global.gamepad_slot, gp_shoulderrb) || player_shoulder_down_press;
		APress = keyboard_check_pressed(global.a) || gamepad_button_check_pressed(global.gamepad_slot, gp_face1);
		BPress = keyboard_check_pressed(global.b) || gamepad_button_check_pressed(global.gamepad_slot, gp_face2);
		CPress = keyboard_check_pressed(global.c) || gamepad_button_check_pressed(global.gamepad_slot, gp_face3);
		ActionPress = APress || BPress || CPress;
		StartPress = keyboard_check_pressed(global.start) || gamepad_button_check_pressed(global.gamepad_slot, gp_start);
		
		//Analog input presses
		event_user(0);
	}else
	{
		//Hold keys
		Up = false;
		Down = false;
		Left = false;
		Right = false;
		A = false;
		B = false;
		C = false;
		Action = false;
		Start = false;
	}