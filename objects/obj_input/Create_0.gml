/// @description Values

	#macro Input obj_input

	global.up = vk_up;						
	global.down = vk_down;
	global.left = vk_left;
	global.right = vk_right;
	global.a = ord("Z");
	global.b = ord("S");
	global.c = ord("X");
	global.start = vk_enter;
	global.dash = vk_shift;
	
	Up = keyboard_check((global.up))
	Down = keyboard_check((global.down))
	Left = keyboard_check((global.left))
	Right = keyboard_check((global.right))
	Dash = keyboard_check((global.dash))
	A = keyboard_check((global.a))
	B = keyboard_check((global.b))
	C = keyboard_check((global.c))
	Action = A || B || C;
	Start = keyboard_check((global.start))

	//Pressed:
	UpPress = keyboard_check_pressed((global.up))
	DownPress = keyboard_check_pressed((global.down))
	LeftPress = keyboard_check_pressed((global.left))
	RightPress = keyboard_check_pressed((global.right))
	DashPress = keyboard_check_pressed((global.dash))
	APress = keyboard_check_pressed((global.a))
	BPress = keyboard_check_pressed((global.b))
	CPress = keyboard_check_pressed((global.c))
	ActionPress = APress || BPress || CPress;
	StartPress = keyboard_check_pressed((global.start))
	
	//Analog input presses:
	axis_left_press = false;
	axis_right_press = false;
	axis_up_press = false;
	axis_down_press = false;
	
	//Releaseed:
	UpRelease = keyboard_check_released((global.up))
	DownRelease = keyboard_check_released((global.down))
	LeftRelease = keyboard_check_released((global.left))
	RightRelease = keyboard_check_released((global.right))
	DashRelease = keyboard_check_released((global.dash))
	ARelease = keyboard_check_released((global.a))
	BRelease = keyboard_check_released((global.b))
	CRelease = keyboard_check_released((global.c))
	ActionRelease = ARelease || BRelease || CRelease;
	StartRelease = keyboard_check_released((global.start))
	
	//Analog input Releasees:
	axis_left_release = false;
	axis_right_release = false;
	axis_up_release = false;
	axis_down_release = false;
	
	//Analog deadzone:
	deadzone_x = 0.32;
	deadzone_y = 0.32;
	
	//Vibration values:
	vibration_timer = 0;
	vibration_strenght = 0;
	
	//Gamepad slot value:
	global.gamepad_slot = 0;